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
    /// Generates a declaration for an 'allOf' type property, handling nested 'anyOf' types and regular properties.
    ///
    /// This function processes 'allOf' types, which are a combination of multiple types, potentially including 'anyOf' types.
    /// It generates the appropriate property declarations, struct declarations, and coding keys.
    ///
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - unionTypes: An array of `JSONUnionType` representing the types to be included in the 'allOf' declaration.
    ///   - isRequired: A Boolean value indicating whether the property is required.
    ///
    /// - Returns: A `MemberBlockItemListSyntax` containing the declarations for the 'allOf' property.
    ///
    func generateAllOfDeclaration(for name: String, with unionTypes: [JSONUnionType], isRequired: Bool) -> MemberBlockItemListSyntax {
        var propertyDecls = [MemberBlockItemListSyntax]()
        var memberDecls = [MemberBlockItemListSyntax]()
        var codingKeys = [String]()

        for type in unionTypes {
            if case .anyOf(let jsonTypes) = type {
                self.logger.info("Generating 'allOf' declaration for: \(name) with 'anyOf' types")

                for jsonType in jsonTypes {
                    if let properties = jsonType.properties {
                        self.logger.info("Processing properties for 'anyOf' type in: \(name)")

                        for (propertyName, propertyType) in properties {
                            if case .type(let jSONType) = propertyType {
                                let swiftType = jSONType.swiftType(for: propertyName)
                                let requiredProperty = jSONType.required?.contains(propertyName) ?? false
                                let propertyDecl = generateRegularPropertyDeclaration(for: propertyName,
                                                                                      with: jSONType,
                                                                                      isRequired: requiredProperty)
                                propertyDecls.append(MemberBlockItemListSyntax { propertyDecl })
                                self.logger.info("Generating regular property declaration for: \(propertyName) with type: \(swiftType)")

                            } else if case .anyOf(let jSONTypes) = propertyType {
                                self.logger.info("Generating 'anyOf' declaration for property: \(propertyName) inside 'allOf' declaration")

                                let requiredProperty = jSONTypes.compactMap(\.required).flatMap { $0 }.contains(propertyName)
                                propertyDecls.append(self.generateAnyOfDeclaration(for: propertyName, with: jSONTypes, isRequired: requiredProperty))
                            }
                            codingKeys.append(propertyName)
                        }
                    }
                }

            } else if case .type(let jSONType) = type {
                if let objectSchema = jSONType.object(), let properties = objectSchema.properties {
                    let (memberDeclsProperties, codingKeysProperties) = generateProperties(properties: properties, isRequired: jSONType.required)

                    for memberDeclsProperty in memberDeclsProperties {
                        propertyDecls.append(MemberBlockItemListSyntax { memberDeclsProperty })
                    }
                    codingKeys.append(contentsOf: codingKeysProperties)
                    self.logger.info("Generating 'allOf' declaration for: \(name) with 'type' properties")
                }
            }
        }
        propertyDecls.append(MemberBlockItemListSyntax { generateEnumDeclaration(with: codingKeys, isCodingKeys: true) })

        let structDecl = StructDeclSyntax(modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
                                          name: TokenSyntax(stringLiteral: name),
                                          inheritanceClause: generateDefaultInheritance()) {
            MemberBlockItemListSyntax {
                for propertyDecl in propertyDecls {
                    propertyDecl
                }
            }
        }

        let variableDecl = generateDictionaryVariable(for: name, with: name, isRequired: isRequired)

        memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        memberDecls.append(MemberBlockItemListSyntax { structDecl })

        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
}
