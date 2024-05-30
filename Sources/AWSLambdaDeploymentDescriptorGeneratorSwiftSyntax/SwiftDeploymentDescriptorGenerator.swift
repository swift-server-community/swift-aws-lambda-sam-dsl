import AWSLambdaDeploymentDescriptorGenerator
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

// TODO: add Command Line Args parser
@main
struct DeploymentDescriptorGenerator {
    // TODO: this will become run when we include command line args library
    static func main() async throws {
        let fm = FileManager.default
        //        let currentDir = fm.currentDirectoryPath
        //        print("👉 \(currentDir)")
        
        let ddg = DeploymentDescriptorGenerator()
        
        // TODO: it should be possible to override with command line args
        print("📖 Reading SAM JSON Schema")
        let jsonSchemaPath = "Sources/AWSLambdaDeploymentDescriptorGeneratorSwiftSyntax/Resources/SAMJSONSchema.json"
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
        let source = SourceFileSyntax {
            StructDeclSyntax(name: "JSONSchema") {

                // TODO: how to add protocol conformance (Codable, Sendable) 
                
                for (name, value) in schema.properties ?? [:] {
                    if case .type(let t) = value  {
                        DeclSyntax("public let \(raw: name.withFirstLetterLowercased()): \(raw: t.swiftType())")
                    }
                }

                DeclSyntax(
                    """
                    func exampleAddingRawCode() -> JSONSChema {
                      var result = self
                      return result
                    }
                    """
                )            
            }
        }
        
        print(source.formatted().description)
    }
    
    // func generateDecodableStruct(for schema: TypeSchema) throws -> SourceFileSyntax {
    //     SourceFileSyntax {
    //         StructDeclSyntax(name: "\(raw: schema.typeName)") {
    //             for prop in schema.properties {
    //                 DeclSyntax("let \(raw: prop.name): \(raw: prop.type)")
    
    //                 DeclSyntax(
    //                     """
    //                     func with\(raw: prop.name.withFirstLetterUppercased())(_ \(raw: prop.name): \(raw: prop.type)) -> \(raw: schema.typeName) {
    //                       var result = self
    //                       result.\(raw: prop.name) = \(raw: prop.name)
    //                       return result
    //                     }
    //                     """
    //                 )
    //             }
    //         }
    //       }
    //   }
}


extension JSONType {
    
    func swiftType() -> String {
        
        guard self.type?.count == 1,
              let t = self.type?[0] else {
            return "not supported yet"
        }
        return switch t {
        case .string: "String"
        default: "not implemented yet"
        }
    }
}

enum GeneratorError: Error {
    case fileNotFound(String)
}

extension String {
    func withFirstLetterUppercased() -> String {
        if let firstLetter = self.first {
            return firstLetter.uppercased() + self.dropFirst()
        } else {
            return self
        }
    }
    func withFirstLetterLowercased() -> String {
        if let firstLetter = self.first {
            return firstLetter.lowercased() + self.dropFirst()
        } else {
            return self
        }
    }
}
