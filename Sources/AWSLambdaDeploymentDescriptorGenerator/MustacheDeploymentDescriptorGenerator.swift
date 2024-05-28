import Foundation
import Mustache

//TODO: add Command Line Args parser
@main
struct DeploymentDescriptorGenerator {
    
        //TODO: this will become run when we include command line args library
    static func main() async throws {
        
        let fm = FileManager.default
//        let currentDir = fm.currentDirectoryPath
//        print("👉 \(currentDir)")

        let ddg: DeploymentDescriptorGenerator = DeploymentDescriptorGenerator()

        //TODO: it should be possible to override with command line args
        print("📖 Reading SAM JSON Schema")
        let jsonSchemaPath = "Sources/AWSLambdaDeploymentDescriptorGenerator/Resources/SAMJSONSchema.json" 
        guard fm.fileExists(atPath: jsonSchemaPath) else {
            throw GeneratorError.fileNotFound(jsonSchemaPath)
        }
        let schema = try ddg.decode(file: jsonSchemaPath)
        print("👉 \(jsonSchemaPath)")

        print("📖 Reading templates directory")
        let templatesPath = "Sources/AWSLambdaDeploymentDescriptorGenerator/Resources/templates" 
        var isDir = ObjCBool(true)
        guard fm.fileExists(atPath: templatesPath, isDirectory: &isDir) else {
            throw GeneratorError.fileNotFound(templatesPath)
        }
        print("👉 \(templatesPath)")
                
        try await ddg.generate(from: schema, with: templatesPath)
    }
    
    func decode(file: String) throws -> JSONSchema {
        let schema = try Data(contentsOf: URL(filePath: file))
        let decoder = JSONDecoder()
        return try decoder.decode(JSONSchema.self, from: schema)
    }
    
    func generate(from schema: JSONSchema, with templates: String) async throws {
        let library = try await MustacheLibrary(directory: templates)
        
        // 1. generate definitions
        print("📝 Generate definitions")
        if let definitions = schema.definitions  {
                        
            if let output = library.render(schema, withTemplate: "definitions") {
                print(output)
            } else {
                print("no output")
            }
        }
    }
}

enum GeneratorError: Error {
    case fileNotFound(String)
}
