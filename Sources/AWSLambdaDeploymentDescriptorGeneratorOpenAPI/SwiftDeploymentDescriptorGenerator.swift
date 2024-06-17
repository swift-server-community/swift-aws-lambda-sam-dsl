import AWSLambdaDeploymentDescriptorGenerator
import Foundation

// TODO: add Command Line Args parser
@main
struct DeploymentDescriptorGenerator {
    // TODO: this will become run when we include command line args library
    static func main() async throws {
        print("""
🛠️ Compile on the command line with:

swift run AWSLambdaDeploymentDescriptorGeneratorOpenAPI

Then, check the generated code in .build/plugins/outputs/...../Types.swift
""")
    }
}
