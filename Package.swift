// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "swift-aws-lambda-sam-dsl",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        // SwiftPM plugin to deploy a SAM Lambda function
        .plugin(name: "AWSLambdaDeployer", targets: ["AWSLambdaDeployer"]),
        
        .executable(name: "DeploymentDescriptorGeneratorExecutable",
                        targets: ["DeploymentDescriptorGeneratorExecutable"]),
        
        // SwiftPM plugin to generate a SAM deployment descriptor
        .plugin(name: "AWSLambdaDescriptorGenerator", targets: ["AWSLambdaDescriptorGenerator"]),
        
        // Shared Library to generate a SAM deployment descriptor
        .library(name: "AWSLambdaDeploymentDescriptor", type: .dynamic, targets: ["AWSLambdaDeploymentDescriptor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", .upToNextMajor(from: "1.4.2")),
        .package(url: "https://github.com/hummingbird-project/hummingbird-mustache.git", from: "1.0.3"),
    ],
    targets: [
        .target(
            name: "AWSLambdaDeploymentDescriptor",
            path: "Sources/AWSLambdaDeploymentDescriptor"
        ),
        .executableTarget(
            name: "DeploymentDescriptorGeneratorExecutable",
            dependencies: [
                .byName(name: "AWSLambdaDeploymentDescriptorGenerator"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .target(name: "AWSLambdaDeploymentDescriptorGenerator", dependencies: [
            .product(name: "Logging", package: "swift-log"),
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "HummingbirdMustache", package: "hummingbird-mustache"),
        ],
                resources: [
                    .process("Resources/SamTranslatorSchema.json")
                ]
        ),
        .plugin(
            name: "AWSLambdaDeployer",
            capability: .command(
                intent: .custom(
                    verb: "deploy",
                    description: "Deploy the Lambda ZIP created by the archive plugin. Generates SAM-compliant deployment files based on deployment struct passed by the developer and invoke the SAM command."
                )
//                permissions: [.writeToPackageDirectory(reason: "This plugin generates a SAM template to describe your deployment")]
            )
        ),
        
        .plugin(
            name: "AWSLambdaDescriptorGenerator",
            capability: .buildTool(),
            dependencies: ["DeploymentDescriptorGeneratorExecutable"]
        ),
        .testTarget(
            name: "AWSLambdaDeploymentDescriptorTests",
            dependencies: [
                .byName(name: "AWSLambdaDeploymentDescriptor"),
            ]
        ),
        .testTarget(
            name: "AWSLambdaDeploymentDescriptorGeneratorTests",
            dependencies: [
                .byName(name: "AWSLambdaDeploymentDescriptorGenerator"),
            ],
            // https://stackoverflow.com/questions/47177036/use-resources-in-unit-tests-with-swift-package-manager
            resources: [
                .copy("Resources/SimpleJSONSchema.json"),
                .copy("Resources/SAMJSONSchema.json")]
        ),
    ]
)
