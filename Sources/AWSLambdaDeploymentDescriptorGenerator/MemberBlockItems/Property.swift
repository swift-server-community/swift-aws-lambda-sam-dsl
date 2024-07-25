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
    /// Generates the property declarations for a given name and JSON type.
    ///
    /// This function handles various JSON schemas such as objects, references, arrays, and enums to generate the corresponding Swift declarations.
    ///
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - type: The JSON type of the property.
    ///   - isRequired: A Boolean value indicating whether the property is required.
    /// - Returns: An array of `MemberBlockItemListSyntax` containing the generated declarations.
    func generatePropertyDeclaration(for name: String, with type: JSONType, isRequired: Bool) -> [MemberBlockItemListSyntax] {
        var memberDecls = [MemberBlockItemListSyntax]()
        var swiftType = type.swiftType(for: name)

        if let objectSchema = type.object() {
            if let properties = objectSchema.properties {
                let structDecl = generateStructDeclaration(for: name, with: properties, isRequired: type.required)
                memberDecls.append(MemberBlockItemListSyntax { addLeadingTrivia(to: structDecl) })

                let variableDecl = generateVariableDecl(for: name, with: name.toSwiftAWSClassCase(), isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })
            } else {
                let propertyDecl = generateStructDeclaration(for: name, with: [:], isRequired: type.required)
                memberDecls.append(MemberBlockItemListSyntax { addLeadingTrivia(to: propertyDecl) })

                let variableDecl = generateVariableDecl(for: name, with: swiftType, isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })
            }
        } else if let reference = type.reference {
            swiftType = reference.toSwiftAWSClassCase()
            let variableDecl = generateVariableDecl(for: name, with: swiftType, isRequired: isRequired)
            memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        } else if let arrayValue = type.arraySchema() {
            if let jsonType = arrayValue.items {
                if let objectValue = jsonType.object() {
                    let structDecl = generateStructDeclaration(for: name,
                                                               with: objectValue.properties ?? [:], isRequired: type.required)
                    memberDecls.append(MemberBlockItemListSyntax { addLeadingTrivia(to: structDecl) })

                } else if let _ = jsonType.stringSchema() {
                    swiftType = "[\(jsonType.swiftType(for: name))]"
                }
            } else {
                swiftType = "[String]"
            }
            let variableDecl = generateVariableDecl(for: name, with: swiftType, isRequired: isRequired)
            memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        } else {
            if let arrayOfType = type.type, arrayOfType.count > 1 {
                memberDecls.append(generateArrayOfTypesDeclaration(for: name, with: arrayOfType, isRequired: isRequired))
            } else {
                let variableDecl = generateVariableDecl(for: name, with: swiftType, isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })
            }
        }

        return memberDecls
    }

    /// Generates a regular property declaration for a given name and JSON type.
    ///
    /// This function is a wrapper around `generatePropertyDeclaration` to convert the result into a single `MemberBlockItemListSyntax`.
    ///
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - type: The JSON type of the property.
    ///   - isRequired: A Boolean value indicating whether the property is required.
    /// - Returns: A `MemberBlockItemListSyntax` containing the generated declarations.
    func generateRegularPropertyDeclaration(for name: String, with type: JSONType, isRequired: Bool) -> MemberBlockItemListSyntax {
        let memberDecls = self.generatePropertyDeclaration(for: name, with: type, isRequired: isRequired)

        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }

    /// Generates property declarations and coding keys for the provided properties.
    ///
    /// This function iterates over the given properties, generating the necessary declarations and coding keys
    /// for each property based on its JSON type.
    ///
    /// - Parameters:
    ///   - properties: A dictionary containing the property names and their corresponding JSON types.
    ///   - isRequired: An optional array of property names that are required.
    /// - Returns: A tuple containing an array of `MemberBlockItemListSyntax` and an array of coding key strings.
    func generateProperties(properties: [String: JSONUnionType], isRequired: [String]?) -> ([MemberBlockItemListSyntax], [String]) {
        var memberDecls = [MemberBlockItemListSyntax]()
        var codingKeys = [String]()

        for (propertyName, propertyType) in properties {
            let required = isRequired?.contains(propertyName) ?? false

            if case .type(let jSONType) = propertyType {
                if propertyType.jsonType().hasEnum() {
                    memberDecls.append(generateEnumDeclaration(for: propertyName, with: jSONType.enumValues() ?? ["No case found!"]))
                    memberDecls.append(generateEnumPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required))
                } else if propertyType.jsonType().reference != nil {
                    let propertyDecl = self.generateRegularPropertyDeclaration(for: propertyName, with: propertyType.jsonType(), isRequired: required)
                    memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                } else if let objectSchema = jSONType.object(), objectSchema.patternProperties != nil {
                    memberDecls.append(generatePatternPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required))
                } else if let objectSchema = jSONType.object(), objectSchema.properties != nil {
                    let propertyDecl = self.generateRegularPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required)
                    memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                } else {
                    let propertyDecl = self.generateRegularPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required)
                    memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                }
                codingKeys.append(propertyName)
            } else if case .anyOf(let jSONTypes) = propertyType {
                memberDecls.append(generateAnyOfDeclaration(for: propertyName, with: jSONTypes, isRequired: required))
                codingKeys.append(propertyName)
            } else if case .allOf(let jSONTypes) = propertyType {
                memberDecls.append(generateAllOfDeclaration(for: propertyName, with: jSONTypes, isRequired: required))
                codingKeys.append(propertyName)
            }
        }

        return (memberDecls, codingKeys)
    }
}
