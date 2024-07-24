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
    /// Generates a Swift struct declaration based on the provided properties and required fields.
    ///
    /// This function creates a `StructDeclSyntax` representing a Swift struct with the specified properties,
    /// and includes a coding keys enum if any properties are provided. The struct is marked as `public`
    /// and conforms to `Codable` and `Sendable` protocols.
    ///
    /// - Parameters:
    ///   - name: The name of the struct to be generated. This name will be transformed to follow Swift's
    ///     class naming conventions.
    ///   - properties: A dictionary of property names to their respective `JSONUnionType` values. Each entry
    ///     represents a property of the struct, including its type and optional constraints.
    ///   - isRequired: An optional array of property names that are required. If provided, these properties
    ///     will be marked as required in the struct declaration.
    ///
    /// - Returns: A `StructDeclSyntax` representing the Swift struct with the specified properties and coding keys.
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
}
