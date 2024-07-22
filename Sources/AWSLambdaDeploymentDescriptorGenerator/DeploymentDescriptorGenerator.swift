import AWSLambdaDeploymentDescriptor
import Foundation
import Logging
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

    var logger = Logging.Logger(label: "DDGenerator")

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
        let propertyStructDecl = generateStructDeclaration(for: "SAMDeploymentDescriptor",
                                                           with: schema.properties ?? [:],
                                                           isRequired: schema.required)

        let definitionStructDecls = generateDefinitionsDeclaration(from: schema.definitions)

        let source = SourceFileSyntax {
            propertyStructDecl.with(\.leadingTrivia, .newlines(1))
            for decl in definitionStructDecls {
                decl.with(\.leadingTrivia, .newlines(2))
            }
        }

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
                print("Success Wrote 🥳")
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
            return "not supported yet"
        }

        return switch t {
        case .string: self.hasEnum() ? "\(key)" : "String"
        case .integer: "Int"
        case .number: "Double"
        case .boolean: "Bool"
        case .array: "[\(self.hasReference() ? "\(key)" : (self.items()?.swiftType(for: key) ?? "String"))]"
        case .object: self.hasReference() ? "\(key)" : self.swiftObjectType(for: key)
        default: "not implemented yet"
        }
    }

    private func swiftObjectType(for key: String) -> String {
        if case .object = self.subType {
            let structName = key

            return structName
        } else {
            return "[String: Any]"
        }
    }
}
