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
        let defaultInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
        
        let source = SourceFileSyntax {
            //TODO: is there a result builder for DeclModifierSyntax?
            StructDeclSyntax(modifiers:  DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.public)) },
                             name: "JSONSchema",
                             inheritanceClause: defaultInheritance) {

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
        
        //TODO: save this to a file instead
        print(source.formatted().description)
    }
}


extension JSONType {
    
    //TODO: should return a type safe value from Swift Syntax library 
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

