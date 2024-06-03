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

    public func generate() {
        // generate code here

        let filePath = Bundle.module.path(forResource: "SamTranslatorSchema", ofType: "json") ?? ""
        let url = URL(fileURLWithPath: filePath)

        do {
            let schemaData = try Data(contentsOf: url)
            do {
                _ = try self.analyzeSAMSchema(from: schemaData)
                // access the schema information
            } catch {
                print("Error analyzing schema: \(error)")
            }

        } catch {
            print("Error getting schemaData contents of URL: \(error)")
        }
    }

    public func generateWithSwiftMustache() {
        do {
            let library = try Templates.createLibrary()
            let template = library.getTemplate(named: "structTemplate")

            let schema = TypeSchema(typeName: "Hello", properties: [.init(name: "one", type: "string")], subTypes: [])
            let modelContext = [
                "scope": "public",
                "object": "struct",
                "name": schema.typeName,
                "shapeProtocol": "Codable",
                "properties": schema.properties.map { property in
                    [
                        "comment": "Fill in comment logic here",
                        "propertyWrapper": nil,
                        // "propertyWrapper": nil as String?,
                        "variable": property.name,
                        "type": property.type,
                        "isOptional": false,
                        // "isOptional": property.type.contains("?"),
                        "default": nil,
                        "last": false,
                        "required": true,
                        "isPrimitive": true,
                        "isCodable": true,
                        "codableType": property.type,
                    ]
                },
            ] as [String: Any]

            if let template = template {
                let renderedStruct = template.render(modelContext)
                print(renderedStruct)
            } else {
                print("Error: Template 'structTemplate' not found")
            }

        } catch {
            print("Error generating Swift struct: \(error)")
        }
    }

    /*
      let renderedStruct = """
      "public struct Hello: Codable {\n        @nil\n  public var Optional(\"one\"): Optional(\"string\")\n\n  public init(Optional(\"one\"): Optional(\"string\") = nil, ) {\n    self.Optional(\"one\") = Optional(\"one\")\n}\n\n\n  private enum CodingKeys: String, CodingKey {\n    case Optional(\"one\") = \"Hello\"\n  }\n}"
      """
     ------------------------
      let expectedOutput = """
      public struct Hello: Codable {
          // Fill in comment logic here
          var one: String
      }
      """
      */

    func analyzeSAMSchema(from jsonData: Data) throws -> JSONSchema {
        let decoder = JSONDecoder()
        let schema = try decoder.decode(JSONSchema.self, from: jsonData)

        print("Schema Information:")
        print("  - Schema URL: \(schema.schema)")
        print("  - Overall Type: \(schema.type ?? [.null])")

        if let properties = schema.properties {
            print("\n  Properties:")
            for (name, propertyType) in properties {
                print("    - \(name): \(propertyType)")
            }
        }

        if let definitions = schema.definitions {
            print("\n  Definitions:")
            for (name, definitionType) in definitions {
                print("    - \(name): \(definitionType)")
            }
        }

        return schema
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

public class HBMustacheTemplateAdapter: TemplateRendering {
    private let template: HBMustacheTemplate

    public init(string: String) throws {
        self.template = try HBMustacheTemplate(string: string)
    }

    public func render(_ object: Any?) -> String {
        self.template.render(object)
    }
}

class MockTemplate: TemplateRendering {
    private let templateString: String

    init(string: String) {
        self.templateString = string
    }

    func render(_: Any?) -> String {
        self.templateString
    }
}

class MockTemplateLibrary: TemplateLibrary {
    private var templates: [String: MockTemplate] = [:]

    func register(_ template: MockTemplate, named name: String) {
        self.templates[name] = template
    }

    func getTemplate(named name: String) -> TemplateRendering? {
        self.templates[name]
    }
}

public class HBMustacheLibraryAdapter: TemplateLibrary {
    private var templates: [String: HBMustacheTemplateAdapter] = [:]

    public func register(_ template: HBMustacheTemplateAdapter, named name: String) {
        self.templates[name] = template
    }

    public func getTemplate(named name: String) -> TemplateRendering? {
        self.templates[name]
    }
}
