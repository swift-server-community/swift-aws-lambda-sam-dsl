import AWSLambdaDeploymentDescriptorGenerator
import Foundation

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

    }
}

enum GeneratorError: Error {
    case fileNotFound(String)
}
