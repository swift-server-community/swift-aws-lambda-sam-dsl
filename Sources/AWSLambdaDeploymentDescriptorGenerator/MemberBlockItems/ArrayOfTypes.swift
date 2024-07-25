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
    /// Generates a declaration for an array of types, handling various JSON primitive types.
    ///
    /// This function processes an array of JSON primitive types and generates the appropriate enum cases and
    /// variable declarations.
    ///
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - types: An array of `JSONPrimitiveType` representing the possible types for the array declaration.
    ///   - isRequired: A Boolean value indicating whether the property is required.
    ///
    /// - Returns: A `MemberBlockItemListSyntax` containing the declarations for the array of types.
    func generateArrayOfTypesDeclaration(for name: String, with types: [JSONPrimitiveType], isRequired: Bool) -> MemberBlockItemListSyntax {
        self.logger.info("Generating array of types declaration for: \(name)")

        var memberDecls = [MemberBlockItemListSyntax]()

        let generatedEnum = MemberBlockItemListSyntax {
            for type in types {
                switch type {
                case .string:
                    generateEnumCaseDecl(name: "string", type: "String")
                case .boolean:
                    generateEnumCaseDecl(name: "boolean", type: "Bool")
                case .integer:
                    generateEnumCaseDecl(name: "integer", type: "Int")
                case .number:
                    generateEnumCaseDecl(name: "number", type: "Double")
                default:
                    generateEnumCaseDecl(name: "string", type: "String")
                }
            }
        }

        let enumDecl = EnumDeclSyntax(modifiers: DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.public)) },
                                      name: .identifier(name.toSwiftAWSClassCase().toSwiftClassCase()),
                                      inheritanceClause: generateDefaultInheritance()) {
            addLeadingTrivia(to: generatedEnum, newlines: 1)
        }

        let variableDecl = generateVariableDecl(for: name, with: name, isRequired: isRequired)

        memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        memberDecls.append(MemberBlockItemListSyntax { addLeadingTrivia(to: enumDecl) })

        self.logger.info("Completed generating array of types declaration for: \(name)")

        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
}
