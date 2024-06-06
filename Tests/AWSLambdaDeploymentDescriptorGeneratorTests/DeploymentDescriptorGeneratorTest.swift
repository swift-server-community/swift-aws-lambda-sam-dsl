//
//  DeploymentDescriptorGeneratorTest.swift
//

@testable import AWSLambdaDeploymentDescriptorGenerator
import Foundation
import HummingbirdMustache
import SwiftSyntax
import XCTest

final class DeploymentDescriptorGeneratorTest: XCTestCase {
    var generator: DeploymentDescriptorGenerator!

    // [https://github.com/apple/swift/blob/9af806e8fd93df3499b1811deae7729176879cb0/test/stdlib/TestJSONEncoder.swift]
    func testTypeSchemaTranslatorReader() throws {
        // load schema from file (the file must be referenced in the Resource section of Package.swift
        // https://stackoverflow.com/questions/47177036/use-resources-in-unit-tests-with-swift-package-manager
        let filePath = Bundle.module.path(forResource: "TypeSchemaTranslator", ofType: "json")
        let fp = try XCTUnwrap(filePath)
        let url = URL(fileURLWithPath: fp)

        let schemaData = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        _ = try decoder.decode(TypeSchema.self, from: schemaData)
    }

    func testGenerateWithSwiftMustache() {
        let templateString = """
        {{%CONTENT_TYPE:TEXT}}
        {{scope}} {{object}} {{name}}: {{shapeProtocol}} {
        {{#properties}}
          {{scope}} let {{variable}}: {{type}}
        {{/properties}}

        {{#subTypes}}
          {{scope}} let {{variable}}: [{{name}}]
        {{/subTypes}}

          {{scope}} init({{#properties}}{{variable}}: {{type}}{{^last}}, {{/last}}{{/properties}}{{#subTypes}}, {{variable}}: [{{name}}]{{/subTypes}}) {
          {{#properties}}
            self.{{variable}} = {{variable}}
          {{/properties}}
          {{#subTypes}}
            self.{{variable}} = {{variable}}
          {{/subTypes}}
        }

          {{scope}} init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            {{#properties}}
              self.{{variable}} = try container.decode({{type}}.self, forKey: .{{variable}})
            {{/properties}}
            {{#subTypes}}
              self.{{variable}} = try container.decode([{{name}}].self, forKey: .{{variable}})
            {{/subTypes}}
          }

          private enum CodingKeys: String, CodingKey {
            {{#properties}}
            case {{variable}}
            {{/properties}}
            {{#subTypes}}
            case {{variable}}
            {{/subTypes}}
          }
        }

        {{#subTypes}}
        {{>structTemplate}}
        {{/subTypes}}
        """

        let template = try! HBMustacheTemplate(string: templateString)
        let library = HBMustacheLibrary()
        library.register(template, named: "structTemplate")

        let generator = DeploymentDescriptorGenerator()

        let output = self.captureOutput {
            generator.generateWithSwiftMustache()
        }

        let expectedOutput = """
        public struct HelloSchema: Codable {
            public let id: Int
            public let name: String
            public let subTypes: [SubType]

            public init(id: Int, name: String, subTypes: [SubType]) {
                self.id = id
                self.name = name
                self.subTypes = subTypes
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.id = try container.decode(Int.self, forKey: .id)
                self.name = try container.decode(String.self, forKey: .name)
                self.subTypes = try container.decode([SubType].self, forKey: .subTypes)
            }

            private enum CodingKeys: String, CodingKey {
                case id
                case name
                case subTypes
            }
        }

        public struct SubType: Codable {
            public let subId: Int
            public let subName: String

            public init(subId: Int, subName: String) {
                self.subId = subId
                self.subName = subName
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.subId = try container.decode(Int.self, forKey: .subId)
                self.subName = try container.decode(String.self, forKey: .subName)
            }

            private enum CodingKeys: String, CodingKey {
                case subId
                case subName
            }
        }
        """

        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines), expectedOutput.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    private func captureOutput(_ closure: () -> Void) -> String {
        let pipe = Pipe()
        let previousStdout = dup(STDOUT_FILENO)
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

        closure()

        fflush(stdout)
        dup2(previousStdout, STDOUT_FILENO)
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }

    func testGenerateWithSwiftSyntax() throws {
        let properties = [
            TypeSchema.Property(name: "id", type: "Int"),
            TypeSchema.Property(name: "name", type: "String"),
        ]
        let subTypeProperties = [
            TypeSchema.Property(name: "subId", type: "Int"),
            TypeSchema.Property(name: "subName", type: "String"),
        ]
        let subTypeSchema = TypeSchema(typeName: "SubType", properties: subTypeProperties, subTypes: [])
        let schema = TypeSchema(typeName: "MainType", properties: properties, subTypes: [subTypeSchema])

        let generator = DeploymentDescriptorGenerator()
        let structDeclSyntax = try generator.generateWithSwiftSyntax(for: schema)

        let expectedOutput = """
        public struct MainTypeRequest: Decodable {
            public let id: Int
            public let name: String
        }
        """
        XCTAssertEqual(structDeclSyntax.description.trimmingCharacters(in: .whitespacesAndNewlines), expectedOutput.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
