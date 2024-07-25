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
    /// Generates the inheritance clause for coding keys.
    ///
    /// This function creates an inheritance clause for an enumeration used as coding keys,
    /// specifying that it inherits from `String` and `CodingKey`.
    ///
    /// - Returns: An `InheritanceClauseSyntax` representing the inheritance clause for coding keys.
    func generateCodingKeysInheritance() -> InheritanceClauseSyntax {
        InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("String"))
            InheritedTypeSyntax(type: TypeSyntax("CodingKey"))
        }
    }

    /// Generates the inheritance clause for an enumeration with a string raw type.
    ///
    /// This function creates an inheritance clause for an enumeration that has a string raw type,
    /// specifying that it inherits from `String`, `Codable`, and `Sendable`.
    ///
    /// - Returns: An `InheritanceClauseSyntax` representing the inheritance clause for an enumeration with a string raw type.
    func generateEnumWithStringInheritance() -> InheritanceClauseSyntax {
        InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("String"))
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
    }

    /// Generates the default inheritance clause for a struct or class.
    ///
    /// This function creates a default inheritance clause for a struct or class,
    /// specifying that it inherits from `Codable` and `Sendable`.
    ///
    /// - Returns: An `InheritanceClauseSyntax` representing the default inheritance clause.
    func generateDefaultInheritance() -> InheritanceClauseSyntax {
        InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
    }
}
