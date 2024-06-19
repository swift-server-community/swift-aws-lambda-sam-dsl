// swift-tools-version:6.0

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
        .package(url: "https://github.com/apple/swift-syntax.git",  branch: "main"),
        .package(url: "https://github.com/apple/swift-openapi-generator.git", from: "1.2.1"),
        .package(url: "https://github.com/apple/swift-openapi-runtime.git", from: "1.4.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.2")
    ],
    targets: [

        // SAM Deployment Descriptor DSL
        .target(
            name: "AWSLambdaDeploymentDescriptor",
            dependencies: [ .product(name: "Yams", package: "Yams")],
            path: "Sources/AWSLambdaDeploymentDescriptor",
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

        // a test command line that uses Swift Syntax code generation
        .executableTarget(
            name: "AWSLambdaDeploymentDescriptorGeneratorSwiftSyntax",
            dependencies: [
                .target(name: "AWSLambdaDeploymentDescriptorGenerator"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax")
            ],
            path: "Sources/AWSLambdaDeploymentDescriptorGeneratorSwiftSyntax",
            exclude: ["Resources"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")]      
        ),

        // a test command line that uses the OpenAPI generator for Swift
        .executableTarget(
            name: "AWSLambdaDeploymentDescriptorGeneratorOpenAPI",
            dependencies: [
                .target(name: "AWSLambdaDeploymentDescriptorGenerator"),
                .product(name: "OpenAPIRuntime",package: "swift-openapi-runtime"),
            ],
            path: "Sources/AWSLambdaDeploymentDescriptorGeneratorOpenAPI",
            exclude: ["Resources"],
            resources: [
              .copy("openapi.yaml"),
              .copy("openapi-generator-config.yaml")
            ],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")],
            plugins: [
              .plugin(
                  name: "OpenAPIGenerator",
                  package: "swift-openapi-generator"
              )
            ]
        ),

        // the plugin to generate a SAM deployment descriptor
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

        // test the deployment decsriptor
        .testTarget(
            name: "AWSLambdaDeploymentDescriptorTests",
            dependencies: [
                .byName(name: "AWSLambdaDeploymentDescriptor"),
            ]
        ),

        // test the SAM JSON Schema reader
        .testTarget(
            name: "AWSLambdaDeploymentDescriptorGeneratorTests",
            dependencies: [
                .byName(name: "AWSLambdaDeploymentDescriptorGenerator"),
            ],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")]
        ),
    ]
)
