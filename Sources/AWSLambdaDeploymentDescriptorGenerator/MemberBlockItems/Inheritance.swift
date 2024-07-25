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

    /// Represents possible types for inheritance
    enum InheritanceType: String {
        case string = "String"
        case codingKey = "CodingKey"
        case codable = "Codable"
        case sendable = "Sendable"

        /// Returns a Swift Format type to represent this inheritance type
        func typeSyntax() -> TypeSyntax {
            TypeSyntax(stringLiteral: self.rawValue)
        }
    }

    /// Generates the inheritance clause.
    ///
    /// This function creates an inheritance clause f,
    /// - Parameter for: The list of types to inherit from
    /// - Returns: An `InheritanceClauseSyntax` representing the inheritance clause for the given list of types.
    func generateInheritance(for inheritedTypes: [InheritanceType]) -> InheritanceClauseSyntax {
        InheritanceClauseSyntax {
            inheritedTypes.map { InheritedTypeSyntax(type: $0.typeSyntax()) }
        }
    }

    /// Generates the default inheritance clause for a struct or class.
    ///
    /// This function creates a default inheritance clause for a struct or class,
    /// specifying that it inherits from `Codable` and `Sendable`.
    ///
    /// - Returns: An `InheritanceClauseSyntax` representing the default inheritance clause.
    func generateDefaultInheritance() -> InheritanceClauseSyntax {
        generateInheritance(for: [.codable, .sendable])
    }
}
