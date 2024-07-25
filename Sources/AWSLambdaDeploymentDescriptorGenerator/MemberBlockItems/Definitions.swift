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
    /// Generates an array of `StructDeclSyntax` from a dictionary of JSON definitions.
    ///
    /// This function processes a dictionary of JSON union types and generates Swift struct declarations for each definition.
    /// Each definition is converted into a struct if it contains an object schema with properties.
    ///
    /// - Parameter dictionary: A dictionary containing JSON definitions where the key is a string and the value is a `JSONUnionType`.
    /// - Returns: An array of `StructDeclSyntax` representing the generated struct declarations.
    func generateDefinitionsDeclaration(from dictionary: [String: JSONUnionType]?) -> [StructDeclSyntax] {
        guard let dictionary = dictionary else { return [] }
        var structDecls: [StructDeclSyntax] = []

        for (name, value) in dictionary {
            self.logger.info("Processing key: \(name) in definitions declaration")

            if case .type(let jsonType) = value {
                self.logger.info("Processing type of value for key: \(name) in definitions declaration")

                if let objectSchema = value.jsonType().object(), let properties = objectSchema.properties {
                    let structDecl = generateStructDeclaration(for: name, with: properties, isRequired: jsonType.required)
                    structDecls.append(structDecl)
                    self.logger.info("Generating struct declaration for object schema with properties for key: \(name)")
                }
            }
        }
        return structDecls
    }
}
