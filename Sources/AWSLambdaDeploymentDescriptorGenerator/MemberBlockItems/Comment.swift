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
    /// Generates a comment block as `Trivia` for Swift source files.
    ///
    /// This function creates a standardized comment block containing licensing information and project details.
    /// The comment block is intended to be used as leading trivia in Swift source files.
    ///
    /// - Returns: A `Trivia` instance containing the formatted comment block.
    func generateComment() -> Trivia {
        let commentLine = """
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
        // ===----------------------------------------------------------------------===//

        """

        let leadingTrivia = Trivia(stringLiteral: commentLine + "\n")
        return leadingTrivia
    }
}
