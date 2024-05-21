
import ArgumentParser
import Foundation
import Logging
import AWSLambdaDeploymentDescriptorGenerator

@main
struct Command: AsyncParsableCommand, DeploymentDescriptorGeneratorCommand {
    @Option(name: .long, help: "Folder to output service files to")
    var outputFolder: String

    @Option(name: .long, help: "Folder to find model files")
    var inputFolder: String?

    @Option(name: .shortAndLong, help: "Input model file")
    var inputFile: String?

    @Option(name: [.short, .customLong("config")], help: "Configuration file")
    var configFile: String?

    @Option(name: .shortAndLong, help: "Prefix applied to output swift files")
    var prefix: String?

    @Option(name: .shortAndLong, help: "Endpoint JSON file")
    var endpoints: String = Self.defaultEndpoints

    @Option(name: .shortAndLong, help: "Only output files for specified module")
    var module: String?

    @Flag(name: .long, inversion: .prefixedNo, help: "Output files")
    var output: Bool = true

 
    @Option(name: .long, help: "Log Level (trace, debug, info, error)")
    var logLevel: String?

    static var rootPath: String {
        return #file
            .split(separator: "/", omittingEmptySubsequences: false)
            .dropLast(3)
            .map { String(describing: $0) }
            .joined(separator: "/")
    }

    static var defaultOutputFolder: String { return "\(rootPath)/awsLambda/output" }
    static var defaultInputFolder: String { return "\(rootPath)/awsLambda/inputs" }
    static var defaultEndpoints: String { return "\(rootPath)/awsLambda/json" }

    func run() async throws {
        try await DeploymentDescriptorGenerator(command: self).generate()
    }
}
