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
    /// Adds leading newlines to a syntax node.
    ///
    /// This function updates the `leadingTrivia` of a syntax node to include a specified number of newlines.
    ///
    /// - Parameters:
    ///   - node: The syntax node to which the leading trivia should be added.
    ///   - newlines: The number of newlines to add as leading trivia. Default is 2.
    /// - Returns: The updated syntax node with the new leading trivia.
    func addLeadingTrivia<T: SyntaxProtocol>(to node: T, newlines: Int = 2) -> T {
        node.with(\.leadingTrivia, .newlines(newlines))
    }

    /// Adds custom leading trivia to a syntax node.
    ///
    /// This function updates the `leadingTrivia` of a syntax node to include custom trivia.
    ///
    /// - Parameters:
    ///   - node: The syntax node to which the leading trivia should be added.
    ///   - trivia: The custom trivia to be set as the leading trivia.
    /// - Returns: The updated syntax node with the new leading trivia.
    func addLeadingTrivia<T: SyntaxProtocol>(to node: T, trivia: Trivia) -> T {
        node.with(\.leadingTrivia, trivia)
    }
}
