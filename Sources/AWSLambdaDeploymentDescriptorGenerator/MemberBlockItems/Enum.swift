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
    /// Generates an enumeration declaration.
    ///
    /// This function generates an enumeration declaration for the provided key and values.
    /// The enumeration can be used either for coding keys or as a regular enumeration depending on the `isCodingKeys` flag.
    ///
    /// - Parameters:
    ///   - key: An optional string representing the key for the enumeration. If not provided, the default name "Enum" is used.
    ///   - values: An array of strings representing the values of the enumeration.
    ///   - isCodingKeys: A boolean indicating if the enumeration is used for coding keys. Defaults to false.
    /// - Returns: A `MemberBlockItemListSyntax` representing the generated enumeration declaration.
    func generateEnumDeclaration(for key: String? = nil, with values: [String], isCodingKeys: Bool = false) -> MemberBlockItemListSyntax {
        let enumName = isCodingKeys ? "CodingKeys" : (key?.toSwiftClassCase() ?? "Enum")
        let enumInheritance = isCodingKeys ? generateCodingKeysInheritance() : generateEnumWithStringInheritance()
        let modifier: DeclModifierSyntax = isCodingKeys ? DeclModifierSyntax(name: .keyword(.private)) : DeclModifierSyntax(name: .keyword(.public))

        let loggerMessage = isCodingKeys ? "Generating enum coding keys with values: \(values.joined(separator: ", "))" : "Generating enum declaration for enum: \(enumName)"
        self.logger.info("\(loggerMessage)")

        let generatedEnum = MemberBlockItemListSyntax {
            for value in values {
                let caseName = isCodingKeys ? value.toSwiftVariableCase() : (value.allLetterIsNumeric() ? ("v" + value.toSwiftEnumCase()) : value.toSwiftEnumCase())
                EnumCaseDeclSyntax {
                    EnumCaseElementListSyntax {
                        EnumCaseElementSyntax(
                            name: .identifier(caseName),
                            rawValue: InitializerClauseSyntax(
                                equal: .equalToken(trailingTrivia: .space),
                                value: ExprSyntax(StringLiteralExprSyntax(content: value))
                            )
                        )
                    }
                }
            }
        }

        let enumDecl = EnumDeclSyntax(modifiers: DeclModifierListSyntax { modifier },
                                      name: .identifier(enumName),
                                      inheritanceClause: enumInheritance) {
            addLeadingTrivia(to: generatedEnum, newlines: 1)
        }

        return MemberBlockItemListSyntax { addLeadingTrivia(to: enumDecl) }
    }

    /// Generates a property declaration for an enumeration.
    ///
    /// This function generates a property declaration for an enumeration based on the provided name and JSON type.
    /// It includes a variable declaration with an optional default value set to one of the enumeration cases.
    ///
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - jsonType: The JSON type of the property.
    ///   - isRequired: A boolean indicating if the property is required.
    /// - Returns: A `MemberBlockItemListSyntax` representing the generated enumeration property declaration.
    func generateEnumPropertyDeclaration(for name: String, with jsonType: JSONType, isRequired: Bool) -> MemberBlockItemListSyntax {
        let enumName = name.toSwiftClassCase()
        let enumRawValue = jsonType.enumValues()?.first ?? ""
        let enumCaseName = (enumRawValue.allLetterIsNumeric() ? ("v" + enumRawValue.toSwiftEnumCase()) : enumRawValue.toSwiftEnumCase())
        self.logger.info("Generating enum property declaration for name: \(name)")

        // Ex:  let transform: Transform? = .aws_Serverless_2016_10_31
        let enumVariableDecl = generateEnumVariableDecl(for: name,
                                                        with: enumName,
                                                        isRequired: isRequired,
                                                        enumCaseName: enumCaseName)

        return MemberBlockItemListSyntax { enumVariableDecl }
    }

    /// Generates an enumeration case declaration.
    ///
    /// This function generates an enumeration case declaration with the provided name and type.
    ///
    /// - Parameters:
    ///   - name: The name of the enumeration case.
    ///   - type: The type of the enumeration case.
    /// - Returns: An `EnumCaseDeclSyntax` representing the generated enumeration case declaration.
    func generateEnumCaseDecl(name: String, type: String) -> EnumCaseDeclSyntax {
        // Ex: case serverlessFunctionS3Event(ServerlessFunctionS3Event)
        self.logger.info("Generating enum case declaration for case: \(name) with type: \(type)")

        return EnumCaseDeclSyntax {
            EnumCaseElementListSyntax {
                EnumCaseElementSyntax(
                    name: .identifier(name),
                    parameterClause: EnumCaseParameterClauseSyntax(
                        parameters: EnumCaseParameterListSyntax {
                            EnumCaseParameterSyntax(
                                type: TypeSyntax(IdentifierTypeSyntax(name: .identifier(type)))
                            )
                        }
                    )
                )
            }
        }
    }
}
