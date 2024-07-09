//
//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateComment() -> String {
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
        
        let leadingTrivia = Trivia(stringLiteral: commentLine)
        return commentLine
    }
}
