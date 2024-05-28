// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "swift-aws-lambda-sam-dsl",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        // SwiftPM plugin to deploy a SAM Lambda function
        .plugin(name: "AWSLambdaDeployer", targets: ["AWSLambdaDeployer"]),

        // Shared Library to generate a SAM deployment descriptor
        .library(name: "AWSLambdaDeploymentDescriptor", type: .dynamic, targets: ["AWSLambdaDeploymentDescriptor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hummingbird-project/swift-mustache", branch: "main"),
    ],
    targets: [

        // SAM Deployment Descriptor DSL
        .target(
            name: "AWSLambdaDeploymentDescriptor",
            path: "Sources/AWSLambdaDeploymentDescriptor"
//            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")]
        ),

        // SAM Deployment Descriptor Generator
        .target(
            name: "AWSLambdaDeploymentDescriptorGenerator",
            path: "Sources/AWSLambdaDeploymentDescriptorGenerator",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")]
        ),

        // a test command line that uses Mustache as template library
        .executableTarget(
            name: "AWSLambdaDeploymentDescriptorGeneratorMustache",
            dependencies: [
                .target(name: "AWSLambdaDeploymentDescriptorGenerator"),
                .product(name: "Mustache", package: "swift-mustache")
            ],
            path: "Sources/AWSLambdaDeploymentDescriptorGeneratorMustache",
            exclude: ["Resources"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")]      
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
