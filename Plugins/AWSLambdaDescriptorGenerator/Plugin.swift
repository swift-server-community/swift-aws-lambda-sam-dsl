
import Foundation
import PackagePlugin

@main struct AWSLambdaDescriptorGenerator: BuildToolPlugin {
    func createBuildCommands(
        context: PluginContext,
        target: Target
    ) throws -> [Command] {
        guard let target = target as? SourceModuleTarget else {
            return []
        }

        return try target.sourceFiles(withSuffix: "json").map { samSchema in
            let base = samSchema.path.stem
            let input = samSchema.path
            let output = context.pluginWorkDirectory.appending(["\(base).swift"])

            return try .buildCommand(displayName: "Generating constants for \(base)",
                                     executable: context.tool(named: "DeploymentDescriptorGeneratorExecutable").path,
                                     arguments: [input.string, output.string],
                                     inputFiles: [input],
                                     outputFiles: [output])
        }
    }
}
