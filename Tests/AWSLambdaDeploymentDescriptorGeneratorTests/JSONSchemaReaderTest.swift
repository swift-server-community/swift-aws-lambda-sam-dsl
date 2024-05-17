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

import Foundation
import XCTest
@testable import AWSLambdaDeploymentDescriptorGenerator

final class JSONSchemaReaderTest: XCTestCase {


    func testSimpleJSONSchemaReader() throws {
        
        // load schema from file (the file must be referenced in the Resource section of Package.swift
        // https://stackoverflow.com/questions/47177036/use-resources-in-unit-tests-with-swift-package-manager
        let filePath = Bundle.module.path(forResource: "SimpleJSONSchema", ofType: "json")
        let fp = try XCTUnwrap(filePath)
        let url = URL(fileURLWithPath: fp)        
        
        let schemaData = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        let schema = try decoder.decode(JSONSchema.self, from: schemaData)
//        print(schema)
        
        XCTAssertTrue(schema.type == .object)
        XCTAssertTrue(schema.properties?.count == 2)
        let fruits = try XCTUnwrap(schema.properties?["fruits"])
        XCTAssertTrue(fruits.type == .array)
        XCTAssertTrue(fruits.items == ArrayItem.type(.string))
        
        let vegetable = try XCTUnwrap(schema.properties?["vegetables"])
        XCTAssertTrue(vegetable.items == ArrayItem.ref("#/definitions/veggie"))
        
        XCTAssertTrue(schema.definitions?.count == 1)
        let veggie = try XCTUnwrap(schema.definitions?["veggie"])
        XCTAssertTrue(veggie.type == .object)
        XCTAssertTrue(veggie.required?.count == 2)
        let veggieName = try XCTUnwrap(veggie.properties?["veggieName"])
        XCTAssertTrue(veggieName.type == .string)
        let veggieLike = try XCTUnwrap(veggie.properties?["veggieLike"])
        XCTAssertTrue(veggieLike.type == .boolean)
    }

}
