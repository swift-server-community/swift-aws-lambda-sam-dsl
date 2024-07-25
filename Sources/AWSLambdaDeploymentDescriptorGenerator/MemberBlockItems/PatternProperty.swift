// ===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftAWSLambdaRuntime open source project
//
// Copyright (c) 2023 Apple Inc. and the SwiftAWSLambdaRuntime project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftAWSLambdaRuntime project authors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    /// Generates the declaration for a pattern property.
    ///
    /// This function handles the generation of declarations for pattern properties based on the provided
    /// JSON type. It processes different JSON schemas like `anyOf`, `type`, `object`, and `reference`,
    /// and generates the corresponding Swift declarations.
    ///
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - type: The JSON type of the property.
    ///   - isRequired: A Boolean value indicating whether the property is required.
    /// - Returns: A `MemberBlockItemListSyntax` containing the generated declarations for the pattern property.
    func generatePatternPropertyDeclaration(for name: String, with type: JSONType, isRequired: Bool) -> MemberBlockItemListSyntax {
        var memberDecls = [MemberBlockItemListSyntax]()

        // TODO: handle regex pattern with function
        // TODO: handle min,max Properties
        if let objectSchema = type.object() {
            if let patternProperties = objectSchema.patternProperties {
                for (_, patternValue) in patternProperties {
                    if case .anyOf(let jsonTypes) = patternValue {
                        self.logger.info("Generating declaration for pattern property with 'anyOf' for: \(name)")
                        memberDecls.append(self.generateAnyOfDeclaration(for: name, with: jsonTypes, isRequired: isRequired))
                    } else if case .type(let jsonType) = patternValue {
                        if jsonType.stringSchema() != nil {
                            let swiftType = jsonType.swiftType(for: name)
                            memberDecls.append(MemberBlockItemListSyntax { generateDictionaryVariable(for: name, with: swiftType, isRequired: isRequired) })
                            self.logger.info("Generating declaration for pattern property with 'type' and 'String' schema for: \(name)")
                        } else if let object = jsonType.object() {
                            let properties = object.properties ?? [:]
                            let structDecl = generateStructDeclaration(for: name, with: properties, isRequired: type.required)
                            memberDecls.append(MemberBlockItemListSyntax { addLeadingTrivia(to: structDecl) })

                            let variableDecl = generateDictionaryVariable(for: name,
                                                                          with: jsonType.swiftType(for: name),
                                                                          isRequired: isRequired)
                            memberDecls.append(MemberBlockItemListSyntax { variableDecl })
                            self.logger.info("Generating struct declaration for pattern property with 'object' schema for: \(name)")

                        } else if let reference = jsonType.reference {
                            self.logger.info("Generating declaration for pattern property with 'reference' for: \(name)")
                            let referenceType = reference.toSwiftObject()
                            let variableDecl = generateDictionaryVariable(for: name, with: referenceType, isRequired: isRequired)
                            memberDecls.append(MemberBlockItemListSyntax { variableDecl })
                        }
                    }
                }
            }
        }

        self.logger.info("Finished generating pattern property for: \(name)")

        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
}
