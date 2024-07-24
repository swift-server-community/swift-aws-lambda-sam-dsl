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

import AWSLambdaDeploymentDescriptor
import Foundation
import Logging
import SwiftSyntax
import SwiftSyntaxBuilder

@main
struct DeploymentDescriptorGenerator {
    static var rootPath: String {
        #file
            .split(separator: "/", omittingEmptySubsequences: false)
            .dropLast(3)
            .map { String(describing: $0) }
            .joined(separator: "/")
    }

    var logger = Logging.Logger(label: "DDGenerator")

    static func main() async throws {
        let fm = FileManager.default

        let ddg = DeploymentDescriptorGenerator()

        // TODO: it should be possible to override with command line args
        print("📖 Reading SAM JSON Schema")
        let jsonSchemaPath = "Sources/AWSLambdaDeploymentDescriptorGenerator/Resources/SAMJSONSchema.json"
        guard fm.fileExists(atPath: jsonSchemaPath) else {
            throw GeneratorError.fileNotFound(jsonSchemaPath)
        }

        let schema = try ddg.decode(file: jsonSchemaPath)
        print("👉 \(jsonSchemaPath)")

        try await ddg.generate(from: schema)
    }

    func decode(file: String) throws -> JSONSchema {
        let schema = try Data(contentsOf: URL(filePath: file))
        let decoder = JSONDecoder()
        return try decoder.decode(JSONSchema.self, from: schema)
    }

    /// Asynchronously generates Swift code from a given JSON schema.
    ///
    /// This function processes the provided JSON schema to generate Swift structures that represent the schema's properties and definitions.
    /// It utilizes the `generateStructDeclaration` and `generateDefinitionsDeclaration` functions to create the necessary struct declarations.
    /// The generated code is formatted and written to a file.
    ///
    /// - Parameter schema: The `JSONSchema` object containing the schema to be converted into Swift code.
    /// - Throws: An error if the schema processing or file writing fails.
    func generate(from schema: JSONSchema) async throws {
        let propertyStructDecl = generateStructDeclaration(for: "SAMDeploymentDescriptor",
                                                           with: schema.properties ?? [:],
                                                           isRequired: schema.required)

        let definitionStructDecls = generateDefinitionsDeclaration(from: schema.definitions)

        let source = SourceFileSyntax {
            addLeadingTrivia(to: propertyStructDecl, trivia: generateComment())
            for decl in definitionStructDecls {
                addLeadingTrivia(to: decl)
            }
        }

        let renderedStruct = source.formatted().description
        self.writeGeneratedResultToFile(renderedStruct)
    }
}

extension DeploymentDescriptorGenerator {
    func writeGeneratedResultToFile(_ result: String) {
        let projectDirectory = "\(DeploymentDescriptorGenerator.rootPath)"
        let filePath = projectDirectory + "/Sources/AWSLambdaDeploymentDescriptorGenerator/Generated/DeploymentDescriptor.swift"

        let directoryPath = (filePath as NSString).deletingLastPathComponent
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDirectory) {
            print("Error: Directory does not exist.")
            return
        }

        let writable = FileManager.default.isWritableFile(atPath: directoryPath)
        if !writable {
            print("Error: No write permissions for the directory.")
            return
        }

        do {
            if try result.writeIfChanged(toFile: filePath) {
                print("Success Wrote 🥳")
            }
        } catch {
            print("Error writing file: \(error)")
        }
    }
}
