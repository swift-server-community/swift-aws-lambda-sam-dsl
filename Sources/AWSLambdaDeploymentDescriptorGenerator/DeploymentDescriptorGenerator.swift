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
        var propertyDecls = [MemberBlockItemListSyntax]()
        var propertyEnumDecls = [MemberBlockItemListSyntax]()
        var propertyCodingKeys = [String]()
        
        var definitionDecls = [MemberBlockItemListSyntax]()
        var definitionEnumDecls = [MemberBlockItemListSyntax]()
        var definitionCodingKeys = [String]()
        
       

        generateDeclarations(from: schema.properties, into: &propertyDecls, enumDecls: &propertyEnumDecls,
                             codingKeys: &propertyCodingKeys)
        let definitionStructDecls = generateDefinitionsDeclaration(from: schema.definitions,
                                       into: &definitionDecls,
                                       enumDecls: &propertyEnumDecls,
                                       codingKeys: &definitionCodingKeys)

        
        propertyEnumDecls.append(generateEnumCodingKeys(with: propertyCodingKeys))
        definitionEnumDecls.append(generateEnumCodingKeys(with: definitionCodingKeys))

        let propertyStructDecl = generateStructDecl(name: "SAMDeploymentDescriptor", decls: propertyDecls, enumDecls: propertyEnumDecls)
        

//        let definitionStructDecl = generateStructDecl(name: "Definitions", decls: definitionDecls, enumDecls: definitionEnumDecls)
        
    
        // Create a source file syntax
        let source = SourceFileSyntax {
            propertyStructDecl
            for decl in definitionStructDecls {
                decl
            }
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
            let structName = key

            return structName
        } else {
            return "[String: Any]"
        }
    }
}
