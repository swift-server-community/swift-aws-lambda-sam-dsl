/**

 TODO:

 1. read `samtranslator schema.json`
 2. generate `../DeploymentDescriptor.swift`

 */
import Foundation
import HummingbirdMustache
import Logging

public protocol DeploymentDescriptorGeneratorCommand {
    var inputFile: String? { get }
    var configFile: String? { get }
    var prefix: String? { get }
    var outputFolder: String { get }
    var inputFolder: String? { get }
    var endpoints: String { get }
    var module: String? { get }
    var output: Bool { get }
    var logLevel: String? { get }
}

public struct DeploymentDescriptorGenerator {
    struct FileError: Error {
        let filename: String
        let error: Error
    }

    let command: DeploymentDescriptorGeneratorCommand
//    let library: HBMustacheLibrary
    let logger: Logging.Logger

    public init(command: DeploymentDescriptorGeneratorCommand) throws {
        self.command = command
//        self.library = try Templates.createLibrary()
        var logger = Logging.Logger(label: "DeploymentDescriptorGenerator")
        logger.logLevel = self.command.logLevel.map { Logging.Logger.Level(rawValue: $0) ?? .info } ?? .info
        self.logger = logger
    }

    public func generate() {
        // generate code here

        let filePath = Bundle.module.path(forResource: "SamTranslatorSchema", ofType: "json") ?? ""
        let url = URL(fileURLWithPath: filePath)

        do {
            let schemaData = try Data(contentsOf: url)
            do {
                _ = try analyzeSAMSchema(from: schemaData)
                // You can now access and analyze the schema information stored in the `schema` struct
            } catch {
                print("Error analyzing schema: \(error)")
            }

        } catch {
            print("Error getting schemaData contents of URL: \(error)")
        }
    }

    func analyzeSAMSchema(from jsonData: Data) throws -> JSONSchema {
        let decoder = JSONDecoder()
        let schema = try decoder.decode(JSONSchema.self, from: jsonData)

        print("Schema Information:")
        print("  - Schema URL: \(schema.schema)")
        print("  - Overall Type: \(schema.type ?? [.null])")

        if let properties = schema.properties {
            print("\n  Properties:")
            for (name, propertyType) in properties {
                print("    - \(name): \(propertyType)") // Briefly describe the type
            }
        }

        if let definitions = schema.definitions {
            print("\n  Definitions:")
            for (name, definitionType) in definitions {
                print("    - \(name): \(definitionType)") // Briefly describe the type
            }
        }

        return schema
    }

    func getModelFiles() -> [String] {
        if let input = self.command.inputFile {
            return [input]
        } else if (self.command.inputFolder) != nil {
            if (command.module) != nil {
                return []
//                return Glob.entries(pattern: "\(inputFolder)/\(module)*.json")
            }
            return []
//            return Glob.entries(pattern: "\(inputFolder)/*.json")
        } else {
            return []
        }
    }
}

extension String {
    /// Only writes to file if the string contents are different to the file contents. This is used to stop XCode rebuilding and reindexing files unnecessarily.
    /// If the file is written to XCode assumes it has changed even when it hasn't
    /// - Parameters:
    ///   - toFile: Filename
    ///   - atomically: make file write atomic
    ///   - encoding: string encoding
    func writeIfChanged(toFile: String) throws -> Bool {
        do {
            let original = try String(contentsOfFile: toFile)
            guard original != self else { return false }
        } catch {
            // print(error)
        }
        try write(toFile: toFile, atomically: true, encoding: .utf8)
        return true
    }
}
