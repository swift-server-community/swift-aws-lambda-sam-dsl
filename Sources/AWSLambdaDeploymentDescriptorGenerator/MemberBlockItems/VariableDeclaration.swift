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
    /// Generates a Swift variable declaration for a property.
    ///
    /// This function creates a variable declaration with a specified type and optionality.
    /// The variable will be declared as either a required or optional property, based on the `isRequired` flag.
    ///
    /// - Parameters:
    ///   - name: The name of the variable, which will be formatted according to Swift's variable naming conventions.
    ///   - type: The type of the variable as a string. It is converted to a Swift class case format.
    ///   - isRequired: A boolean indicating whether the variable is required (non-optional) or optional.
    ///
    /// - Returns: A `MemberBlockItemSyntax` representing the variable declaration.
    func generateVariableDecl(for name: String, with type: String, isRequired: Bool) -> MemberBlockItemSyntax {
        let typeAnnotation: TypeSyntaxProtocol = isRequired ? TypeSyntax(stringLiteral: type.toSwiftClassCase()) : OptionalTypeSyntax(wrappedType: TypeSyntax(stringLiteral: type.toSwiftClassCase()))
        self.logger.info("Generating variable declaration for property: \(name)")

        return MemberBlockItemSyntax(decl: VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
            PatternBindingSyntax(
                pattern: PatternSyntax(stringLiteral: name.toSwiftVariableCase()),
                typeAnnotation: TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space), type: typeAnnotation)
            )
        })
    }

    /// Generates a Swift variable declaration for an enum property.
    ///
    /// This function creates a variable declaration for an enum type, including its initializer.
    /// The variable can be required or optional based on the `isRequired` flag.
    ///
    /// - Parameters:
    ///   - propertyName: The name of the variable, formatted according to Swift's variable naming conventions.
    ///   - enumName: The name of the enum type.
    ///   - isRequired: A boolean indicating whether the variable is required (non-optional) or optional.
    ///   - enumCaseName: The name of the enum case to initialize the variable with.
    ///
    /// - Returns: A `MemberBlockItemSyntax` representing the variable declaration with an enum case initializer.
    func generateEnumVariableDecl(for propertyName: String, with enumName: String, isRequired: Bool, enumCaseName: String) -> MemberBlockItemSyntax {
        let typeAnnotation: TypeSyntaxProtocol = isRequired ?
            TypeSyntax(stringLiteral: enumName) :
            OptionalTypeSyntax(wrappedType: TypeSyntax(stringLiteral: enumName))

        self.logger.info("Generating enum variable declaration for property: \(propertyName)")

        return MemberBlockItemSyntax(decl:
            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                PatternBindingSyntax(
                    pattern: PatternSyntax(stringLiteral: propertyName.toSwiftVariableCase()),
                    typeAnnotation: TypeAnnotationSyntax(
                        colon: .colonToken(trailingTrivia: .space),
                        type: typeAnnotation
                    ),
                    initializer: InitializerClauseSyntax(value: ExprSyntax(".\(raw: enumCaseName)"))
                )
            }
        )
    }

    /// Generates a Swift variable declaration for a dictionary property.
    ///
    /// This function creates a variable declaration for a dictionary type, which can be required or optional
    /// depending on the `isRequired` flag. The dictionary type is defined with `String` keys and a specified value type.
    ///
    /// - Parameters:
    ///   - name: The name of the dictionary variable, formatted according to Swift's variable naming conventions.
    ///   - swiftType: The type of the dictionary values as a string. This will be used in the dictionary type annotation.
    ///   - isRequired: A boolean indicating whether the dictionary variable is required (non-optional) or optional.
    ///
    /// - Returns: A `MemberBlockItemSyntax` representing the variable declaration for the dictionary.
    func generateDictionaryVariable(for name: String, with swiftType: String, isRequired: Bool) -> MemberBlockItemSyntax {
        self.logger.info("Generating dictionary variable for: \(name) with type: \(swiftType)")

        let typeAnnotation: TypeSyntaxProtocol = isRequired ? TypeSyntax(DictionaryTypeSyntax(
            leftSquare: .leftSquareToken(),
            key: TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))),
            colon: .colonToken(),
            value: TypeSyntax(stringLiteral: swiftType),
            rightSquare: .rightSquareToken()
        )) : OptionalTypeSyntax(wrappedType: TypeSyntax(DictionaryTypeSyntax(
            leftSquare: .leftSquareToken(),
            key: TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))),
            colon: .colonToken(),
            value: TypeSyntax(stringLiteral: swiftType),
            rightSquare: .rightSquareToken()
        )))

        return MemberBlockItemSyntax(decl: VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
            PatternBindingSyntax(
                pattern: PatternSyntax(stringLiteral: name.toSwiftVariableCase()),
                typeAnnotation: TypeAnnotationSyntax(
                    colon: .colonToken(trailingTrivia: .space),
                    type: typeAnnotation
                )
            )
        })
    }
}
