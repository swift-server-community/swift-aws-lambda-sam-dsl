//
//  DeploymentDescriptorGeneratorTest.swift
//

@testable import AWSLambdaDeploymentDescriptorGenerator
import Foundation
import HummingbirdMustache
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
        public struct {{name}}: {{shapeProtocol}} {
            // {{comment}}
            var {{variable}}: {{type}}
        }
        """
        let template = try! HBMustacheTemplate(string: templateString)
        let library = HBMustacheLibrary()
        library.register(template, named: "structTemplate")

        let generator = DeploymentDescriptorGenerator()

        let output = self.captureOutput {
            generator.generateWithSwiftMustache()
        }

        let expectedOutput = """
        public struct Hello: Codable {
            // Fill in comment logic here
            var one: String
        }
        """

        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines), expectedOutput.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    private func captureOutput(_ closure: () -> Void) -> String {
        let pipe = Pipe()
        let oldStdOut = dup(STDOUT_FILENO)
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

        closure()

        fflush(stdout)
        dup2(oldStdOut, STDOUT_FILENO)
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }
}
