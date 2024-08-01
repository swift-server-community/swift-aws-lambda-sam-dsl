
## Overview

Deploying AWS Lambda functions using AWS SAM (Serverless Application Model) can be complicated for Swift developers. It involves creating a deployment descriptor manually, learning a new DSL (Domain Specific Language), and using tools like SAM CLI and Docker. To make this easier, the community proposed a Swift-based DSL and a Swift package plugin. However, these solutions need to accurately copy the evolving SAM AWS deployment descriptor.

To solve this problem, my Google Summer of Code project for 2024 focuses on automatically generating the AWSLambdaDeploymentDescriptor library based on the SAM template definition. This generated code will be used by the Swift-based DSL to create the SAM YAML templates needed to deploy Lambda functions and their dependencies to AWS.

In this article, I’ll share the progress Sébastien Stormacq (my mentor) and I made over the past few weeks, the challenges we encountered, and the remaining steps to complete this implementation.

Main repository: [swift-aws-lambda-sam-dsl](https://github.com/sebsto/swift-aws-lambda-sam-dsl)

Project’s fork: [esraaeiid/swift-aws-lambda-sam-dsl](https://github.com/esraaeiid/swift-aws-lambda-sam-dsl)

---

## Week 1 & 2:

During the first two weeks, I focused on understanding the AWS environment with guidance from my mentor. We went over the project scope with a helpful diagram.

Here’s what I accomplished:

- **Learned JSON Schema Specification**: Gained a solid understanding of JSON Schema, which is crucial for defining and validating the structure of JSON data.
- **Developed and Deployed Lambda Functions**: Explored how to create and deploy Lambda functions using Python and TypeScript.
- **Deployed Lambda Functions with SAM**: Learned the process of deploying Lambda functions using AWS SAM (Serverless Application Model).
- **Swift Development**: Discovered how to develop and deploy Lambda functions in Swift using the SwiftPM archive plugin and SwiftPM deploy plugin.
- **Opened a [Discussion](https://forums.swift.org/t/add-a-deploy-swiftpm-plugin-and-a-swift-based-dsl-to-the-swift-runtime-for-aws-lambda/71564)**: Engaged with the Swift community to discuss the project goals and proposed modifications.

These activities helped me become familiar with the overall architecture of the project, SwiftPM plugins, and Swift command line tools.



## Week 3 & 4:

In Week 3 & 4, we focused on developing a generic JSON Schema Reader. Based on an example provided by my mentor, which can be found [here](https://github.com/sebsto/swift-aws-lambda-sam-dsl/blob/11d73a2f9a4bd5e24348849fa13e9f844dfb5be5/Sources/AWSLambdaDeploymentDescriptorGenerator/JSONSChemaReader.swift).

Main tasks included:

- **Creating the JSON Schema Reader**: We started writing a generic JSON Schema Reader to handle various schema definitions effectively.
- **Addressing Challenges with SAM Templates**: We tackled specific challenges related to SAM templates, using the [SAM schema](https://github.com/aws/serverless-application-model/blob/develop/samtranslator/validator/sam_schema/schema.json) as a reference.
- **Unit Testing**: Implemented unit tests for each case to ensure the JSON Schema Reader is stable and reliable, setting a solid foundation for the code generation phase.

You can review the code developed during these weeks in the following branches: \
→ [branch #1](https://github.com/esraaeiid/swift-aws-lambda-sam-dsl/commits/week-21) \
→ [branch #2](https://github.com/esraaeiid/swift-aws-lambda-sam-dsl/commits/week-22)

This work was essential for establishing a solid JSON Schema reader, which will be used in the subsequent phases of our project.

## Week 5 & 6 & 7:

During Weeks 5, 6, and 7, we evaluated three techniques for Swift code generation to achieve our project goals:
Swift Hummingbird Mustache, Swift Syntax and Swift OpenAPI

To gather insights on which method might be best for our use case, I initiated a [discussion](https://forums.swift.org/t/code-generation-swift-syntax-or-mustache/72131/11) on the Swift Forums. The feedback and examples provided by the community were instrumental in developing our proof of concept.

As stated [here](https://esraaeiid.github.io/posts/GSoC-Exploring-Code-Generation/), in the evaluation of tools I made later, here’s a summary of each technique:

**Swift Mustache**

The [Swift Hummingbird Mustache](https://github.com/hummingbird-project/swift-mustache) implementation uses a simple key-value coding approach for rendering values from model objects. We tried implementing a minimal example to mimic our use case. The main challenge with Mustache is its learning curve for generating complex code, such as methods and enums.

**Swift Syntax**

SwiftSyntax offers a detailed, tree-based model of Swift source code, allowing tools to parse, inspect, and generate Swift code. We were inclined toward using SwiftSyntax because of its flexibility and accuracy. However, generating functions or control statements might require extra effort, as noted in [this discussion](https://forums.swift.org/t/announcing-swiftsyntaxbuilder/56565/6). Despite this, we felt confident it could handle our needs, with some challenges manageable through careful planning and iteration.

**Swift OpenAPI**

The [Swift OpenAPI](https://github.com/apple/swift-openapi-generator) tool generates Swift code based on OpenAPI specifications. While it excels in adhering to Swift code generation best practices, it faces limitations in handling complex JSON schemas. Challenges include managing nested structs, statement functions, and edge cases with enums.

Based on community feedback from the [Swift Forums](https://forums.swift.org/t/code-generation-swift-syntax-or-mustache/72131) and the examples we reviewed, we decided to proceed with SwiftSyntax. It’s better suited for generating Swift structs from complex JSON schema specifications. Although SwiftSyntax has some challenges, they are manageable with careful planning and iterative development.

You can review the code developed during these weeks in the following branches: \
→ [branch #1](https://github.com/esraaeiid/swift-aws-lambda-sam-dsl/commits/week-23) Swift Hummingbird Mustache \
→ [branch #2](https://github.com/esraaeiid/swift-aws-lambda-sam-dsl/commits/week-24)  Swift Syntax \
→ [branch #3](https://github.com/esraaeiid/swift-aws-lambda-sam-dsl/commits/week-25)  Swift OpenAPI

## Week 8 & 9:

The objective for these weeks was to define a coding strategy for generating code using Swift Syntax, focusing first on type definitions (structs and enums) without considering behaviors (functions and code) yet.

Here’s an example snippet of the code:

```swift
    func generateStructDeclaration(for name: String, with properties: [String: JSONUnionType],
                                   isRequired: [String]?) -> StructDeclSyntax {
        let (memberDecls, codingKeys) = generateProperties(properties: properties, isRequired: isRequired)

        self.logger.info("Generating struct declaration for: \(name)")

        let codingKeysEnum = properties.isEmpty ? MemberBlockItemListSyntax {} : generateEnumDeclaration(with: codingKeys, isCodingKeys: true)

        return StructDeclSyntax(modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
                                name: TokenSyntax(stringLiteral: name.toSwiftAWSClassCase().toSwiftClassCase()),
                                inheritanceClause: generateDefaultInheritance()) {
            MemberBlockItemListSyntax {
                if !(memberDecls.isEmpty) {
                    for memberDecl in memberDecls {
                        memberDecl
                    }
                }
                codingKeysEnum
            }
        }
    }
```

You can review the code developed during these weeks in the following branches:

→ [branch #1](https://github.com/esraaeiid/swift-aws-lambda-sam-dsl/commits/week-26) \
→ [branch #2](https://github.com/esraaeiid/swift-aws-lambda-sam-dsl/commits/week-27)

## Week 10 & 11:

During Weeks 10 and 11, we focused on finalizing the code generation to ensure 100% of the data definitions were generated. We also made sure that the generated code compiles successfully.

Here’s an example snippet of the code:

```swift
    func generateDefinitionsDeclaration(from dictionary: [String: JSONUnionType]?) -> [StructDeclSyntax] {
        guard let dictionary = dictionary else { return [] }
        var structDecls: [StructDeclSyntax] = []

        for (name, value) in dictionary {
            self.logger.info("Processing key: \(name) in definitions declaration")

            if case .type(let jsonType) = value {
                self.logger.info("Processing type of value for key: \(name) in definitions declaration")

                if let objectSchema = value.jsonType().object(), let properties = objectSchema.properties {
                    let structDecl = generateStructDeclaration(for: name, with: properties, isRequired: jsonType.required)
                    structDecls.append(structDecl)
                    self.logger.info("Generating struct declaration for object schema with properties for key: \(name)")
                }
            }
        }
        return structDecls
    }
```

You can review the code developed during these weeks in the following branch:

→ [branch #1](https://github.com/esraaeiid/swift-aws-lambda-sam-dsl/commits/week-28)


## Week  12:

The final week of the project focused on cleaning up the code before submitting it as a pull request (PR) that has now been merged into the main repository.

You can review the code developed during this week in the following branches:

→ [branch #1: Last Week](https://github.com/esraaeiid/swift-aws-lambda-sam-dsl/commits/week-30) \
→ [branch #2: Merged Code](https://github.com/sebsto/swift-aws-lambda-sam-dsl/tree/esraa/generator/Sources/AWSLambdaDeploymentDescriptorGenerator) \
→ [PR #1](https://github.com/sebsto/swift-aws-lambda-sam-dsl/pull/8), [PR #2](https://github.com/sebsto/swift-aws-lambda-sam-dsl/pull/9)


## What's left to do?

The main task remaining is to generate helper functions for the generated SAMDeploymentDescriptor. This includes handling regex patterns with functions and trying to match the behavior of the [SAMDeploymentDescriptor](https://github.com/sebsto/swift-aws-lambda-runtime/blob/sebsto/deployerplugin_dsl/Sources/AWSLambdaDeploymentDescriptor/DeploymentDescriptor.swift) that was manually written. These helper functions will be essential for integrating the generated code into the [DSL](https://github.com/sebsto/swift-aws-lambda-runtime/blob/sebsto/deployerplugin_dsl/Sources/AWSLambdaDeploymentDescriptor/DeploymentDescriptorBuilder.swift) later on.

## Final thought

This Google Summer of Code project has been a rewarding experience. Working with my mentor, Sébastien Stormacq, I gained valuable insights into AWS Lambda, SAM, and Swift development. Our goal was to simplify AWS Lambda deployments for developers by automating SAM deployment descriptor generation.

We faced several challenges, from understanding JSON Schema specifications to evaluating code generation techniques. Opting for SwiftSyntax proved effective due to its flexibility and alignment with Swift's syntax

While we've made significant progress, there's more to do. The next steps involve generating helper functions for SAMDeploymentDescriptor and ensuring seamless integration with the DSL, which will enhance the project's functionality.

I'm proud of our achievements and excited about the project's potential impact on the community.

