/**

 TODO:

 1. read `samtranslator schema.json`
 2. generate `../DeploymentDescriptor.swift`

 */
import Foundation
import HummingbirdMustache
import Logging
import SwiftSyntax
import SwiftSyntaxBuilder

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

    // MARK: - generateWithSwiftOpenapi

    public func generateWithSwiftOpenAPI() {}

    // MARK: - generateWithSwiftSyntax

    func generateWithSwiftSyntax(for schema: TypeSchema) throws -> StructDeclSyntax {
        try StructDeclSyntax("public struct \(raw: schema.typeName)Request: Decodable") {
            for property in schema.properties {
                "public let \(raw: property.name): \(raw: property.type)"
            }
            for subType in schema.subTypes {
                try self.generateWithSwiftSyntax(for: subType)
            }
        }
    }

//    static func main() {
//      let properties = [
//        "firstName": "String",
//        "lastName": "String",
//        "age": "Int",
//      ]
//
//      let source = SourceFileSyntax {
//        StructDeclSyntax(name: "Person") {
//          for (propertyName, propertyType) in properties {
//            DeclSyntax("var \(raw: propertyName): \(raw: propertyType)")
//
//            DeclSyntax(
//              """
//              func with\(raw: propertyName.withFirstLetterUppercased())(_ \(raw: propertyName): \(raw: propertyType)) -> Person {
//                var result = self
//                result.\(raw: propertyName) = \(raw: propertyName)
//                return result
//              }
//              """
//            )
//          }
//        }
//      }
//
//      print(source.formatted().description)
//    }

    // MARK: - generateWithSwiftMustache

    public func generateWithSwiftMustache() {
        do {
            let library = try Templates.createLibrary()
            let template = library.getTemplate(named: "structTemplate")

            let properties: [TypeSchema.Property] = [
                .init(name: "id", type: "Int"),
                .init(name: "name", type: "String"),
            ]

            let subTypeProperties: [TypeSchema.Property] = [
                .init(name: "subId", type: "Int"),
                .init(name: "subName", type: "String"),
            ]

            let subTypeSchema = TypeSchema(typeName: "SubType", properties: subTypeProperties, subTypes: [])

            let schema = TypeSchema(typeName: "Hello",
                                    properties: properties,
                                    subTypes: [subTypeSchema])

            let modelContext: [String: Any] = [
                "scope": "public",
                "object": "struct",
                "name": schema.typeName,
                "shapeProtocol": "Codable",
                "properties": schema.properties.map { property in
                    [
                        "comment": "Fill in comment logic here",
                        "propertyWrapper": nil,
                        "variable": property.name,
                        "type": property.type,
                        "isOptional": property.type.contains("?"),
                        "default": false,
                        "last": property == schema.properties.last,
                        "required": true,
                        "isPrimitive": true,
                        "isCodable": true,
                        "codableType": property.type,
                    ]
                },
                "subTypes": schema.subTypes.map { subType in
                    [
                        "object": "struct",
                        "name": subType.typeName,
                        "shapeProtocol": "Codable",
                        "properties": subType.properties.map { property in
                            [
                                "comment": "Fill in comment logic here",
                                "propertyWrapper": nil,
                                "variable": property.name,
                                "type": property.type,
                                "isOptional": property.type.contains("?"),
                                "default": false,
                                "last": property == subType.properties.last,
                                "required": true,
                                "isPrimitive": true,
                                "isCodable": true,
                                "codableType": property.type,
                            ]
                        },
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
     "public struct Hello: Codable {\n  public let Optional(\"id\"): Optional(\"Int\")\n  public let Optional(\"name\"): Optional(\"String\")\n\n  public let subTypes: [SubType]\n\n  public init(Optional(\"id\"): Optional(\"Int\"), Optional(\"name\"): Optional(\"String\"), subTypes: [SubType]) {\n    self.Optional(\"id\") = Optional(\"id\")\n    self.Optional(\"name\") = Optional(\"name\")\n    self.subTypes = subTypes\n}\n\n  public init(from decoder: Decoder) throws {\n    let container = try decoder.container(keyedBy: CodingKeys.self)\n      self.Optional(\"id\") = try container.decode(Optional(\"Int\").self, forKey: .Optional(\"id\"))\n      self.Optional(\"name\") = try container.decode(Optional(\"String\").self, forKey: .Optional(\"name\"))\n      self.subTypes = try container.decode([SubType].self, forKey: .subTypes)\n  }\n\n  private enum CodingKeys: String, CodingKey {\n    case Optional(\"id\")\n    case Optional(\"name\")\n    case subTypes\n  }\n}\n\n"
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
