import AWSLambdaDeploymentDescriptor
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

@main
struct DeploymentDescriptorGenerator {
    static var rootPath: String {
        #file
            .split(separator: "/", omittingEmptySubsequences: false)
            .dropLast(3)
            .map { String(describing: $0) }
            .joined(separator: "/")
    }

    static func main() async throws {
        let fm = FileManager.default

        let ddg = DeploymentDescriptorGenerator()

        // TODO: it should be possible to override with command line args
        print("📖 Reading SAM JSON Schema")
        let jsonSchemaPath = "Sources/AWSLambdaDeploymentDescriptorGenerator/Resources/SAMJSONSchema.json"
        guard fm.fileExists(atPath: jsonSchemaPath) else {
            throw GeneratorError.fileNotFound(jsonSchemaPath)
        }
        let schema = try ddg.decode(file: jsonSchemaPath)
        print("👉 \(jsonSchemaPath)")

        try await ddg.generate(from: schema)
    }

    func decode(file: String) throws -> JSONSchema {
        let schema = try Data(contentsOf: URL(filePath: file))
        let decoder = JSONDecoder()
        return try decoder.decode(JSONSchema.self, from: schema)
    }

    func generate(from schema: JSONSchema) async throws {
        let defaultInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }

        var propertyDecls = [MemberBlockItemListSyntax]()
        var enumDecls = [MemberBlockItemListSyntax]()

        for (name, value) in schema.properties ?? [:] {
            if case .type(let jsonType) = value {
                let swiftType = jsonType.swiftType(for: name)
                let propertyName = name.toSwiftLabelCase()

                if jsonType.hasEnum() {
                    let enumDecl = generateEnumDeclaration(for: name, with: jsonType.enumValues() ?? ["No case found!"])
                    enumDecls.append(enumDecl)

                    let enumPropertyDecl = generateEnumPropertyDeclaration(for: name, with: jsonType)
                    propertyDecls.append(enumPropertyDecl)
                } else {
                    let propertyDecl = generateRegularPropertyDeclaration(for: name, with: jsonType)
                    propertyDecls.append(propertyDecl)
                }
            }
        }

        // Extract keys from the dictionary to generate coding keys enum
        let keys = schema.properties?.keys.map { $0 } ?? []
        let codingKeysEnum = generateEnumCodingKeys(with: keys)
        enumDecls.append(codingKeysEnum)

        let structDecl = StructDeclSyntax(modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
                                          name: "Property",
                                          inheritanceClause: defaultInheritance) {
            // Members of the struct (properties)
            MemberBlockItemListSyntax {
                for decl in propertyDecls {
                    decl
                }
            }
            // Enums
            MemberBlockItemListSyntax {
                for enumDecl in enumDecls {
                    enumDecl
                }
            }
        }

        // Create a source file syntax
        let source = SourceFileSyntax {
            structDecl
        }

        // Write to a file
        let renderedStruct = source.formatted().description
        self.writeGeneratedResultToFile(renderedStruct)
    }
}

extension DeploymentDescriptorGenerator {
    func writeGeneratedResultToFile(_ result: String) {
        let projectDirectory = "\(DeploymentDescriptorGenerator.rootPath)"
        let filePath = projectDirectory + "/Sources/AWSLambdaDeploymentDescriptorGenerator/Generated/DeploymentDescriptor.swift"

        let directoryPath = (filePath as NSString).deletingLastPathComponent
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDirectory) {
            print("Error: Directory does not exist.")
            return
        }

        let writable = FileManager.default.isWritableFile(atPath: directoryPath)
        if !writable {
            print("Error: No write permissions for the directory.")
            return
        }

        do {
            if try result.writeIfChanged(toFile: filePath) {
                print("Success Wrote ✅")
            }
        } catch {
            print("Error writing file: \(error)")
        }
    }
}

// TODO: Move this into JSONSchemaReader..
extension JSONType {
    // TODO: should return a type safe value from Swift Syntax library
    func swiftType(for key: String) -> String {
        guard self.type?.count == 1,
              let t = self.type?[0] else {
            return "not supported yet ⚠️" // anyOf - allOf
        }

        return switch t {
        case .string: self.hasEnum() ? "\(key)" : "String"
        case .integer: "Int"
        case .number: "Double"
        case .boolean: "Bool"
        case .array: "[\(self.items()?.swiftType(for: key) ?? "Any")]"
        case .object: self.swiftObjectType(for: key)
        default: "not implemented yet ⚠️"
        }
    }

    private func swiftObjectType(for key: String) -> String {
        if case .object(let objectSchema) = self.subType {
            var properties = [String]()
            for (name, type) in objectSchema.properties ?? [:] {
                properties.append("let \(name.toSwiftLabelCase()): \(type.jsonType().swiftType(for: name))")
            }

            let structName = key
            let structBody = properties.joined(separator: "\n")

            return structName
        } else {
            return "[String: Any]"
        }
    }
}
