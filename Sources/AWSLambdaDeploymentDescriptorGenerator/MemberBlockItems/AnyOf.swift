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
    /// Generates a declaration for an 'anyOf' type property, handling various JSON schema types.
    ///
    /// This function processes 'anyOf' types, which are a combination of multiple possible types. It generates
    /// the appropriate enum cases, struct declarations, and variable declarations.
    ///
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - types: An array of `JSONType` representing the possible types for the 'anyOf' declaration.
    ///   - isRequired: A Boolean value indicating whether the property is required.
    ///
    /// - Returns: A `MemberBlockItemListSyntax` containing the declarations for the 'anyOf' property.
    func generateAnyOfDeclaration(for name: String, with types: [JSONType], isRequired: Bool) -> MemberBlockItemListSyntax {
        var memberDecls = [MemberBlockItemListSyntax]()
        var enumDecls = [EnumCaseDeclSyntax]()

        for jsonType in types {
            if let arrayType = jsonType.arraySchema() {
                if let item = arrayType.items, item.stringSchema() != nil {
                    self.logger.info("Generating 'anyOf' case for an array of strings in: \(name)")

                    enumDecls.append(generateEnumCaseDecl(name: "itemArray", type: "[\(item.swiftType(for: name))]"))
                } else if let reference = arrayType.items?.reference {
                    let caseName = reference.toSwiftEnumCaseName()

                    let caseType = reference.toSwiftObject()
                    enumDecls.append(generateEnumCaseDecl(name: "\(caseName)Array", type: "[\(caseType)]"))
                    self.logger.info("Generating 'anyOf' case for an array of references in: \(name) with type: \(reference)")
                }

            } else if jsonType.stringSchema() != nil {
                self.logger.info("Generating 'anyOf' case for a string type in: \(name)")

                enumDecls.append(generateEnumCaseDecl(name: "item", type: "\(jsonType.swiftType(for: name))"))

            } else if jsonType.object() != nil {
                self.logger.info("Generating 'anyOf' case for an object type in: \(name)")
                enumDecls.append(generateEnumCaseDecl(name: "itemObject", type: "\(name.toSwiftAWSClassCase().toSwiftClassCase())Object"))
            } else if let reference = jsonType.reference {
                self.logger.info("Generating 'anyOf' case for a reference type in: \(name) with type: \(reference)")

                let caseName = reference.toSwiftEnumCaseName()

                let caseType = reference.toSwiftObject()
                enumDecls.append(generateEnumCaseDecl(name: caseName, type: caseType))
            }
        }

        let variableDecl = generateDictionaryVariable(for: name, with: name, isRequired: isRequired)

        for jsonType in types {
            if let objectType = jsonType.object() {
                self.logger.info("Generating struct declaration for object type in 'anyOf': \(name)")

                let properties = objectType.properties ?? [:]
                let structDecl = generateStructDeclaration(for: "\(name)Object",
                                                           with: properties, isRequired: jsonType.required)
                memberDecls.append(MemberBlockItemListSyntax { structDecl })
            }
        }

        let generatedEnumDecl = MemberBlockItemListSyntax {
            for enumDecl in enumDecls {
                enumDecl
            }
        }

        let enumDecl = EnumDeclSyntax(modifiers: DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.public)) },
                                      name: .identifier(name.toSwiftAWSClassCase().toSwiftClassCase()),
                                      inheritanceClause: generateDefaultInheritance()) {
            addLeadingTrivia(to: generatedEnumDecl, newlines: 1)
        }

        memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        memberDecls.append(MemberBlockItemListSyntax { addLeadingTrivia(to: enumDecl) })

        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
}
