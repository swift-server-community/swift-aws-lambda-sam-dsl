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

    //[https://github.com/apple/swift/blob/9af806e8fd93df3499b1811deae7729176879cb0/test/stdlib/TestJSONEncoder.swift]

    func testSimpleJSONSchemaReader() throws {
        
        // load schema from file (the file must be referenced in the Resource section of Package.swift
        // https://stackoverflow.com/questions/47177036/use-resources-in-unit-tests-with-swift-package-manager
        let filePath = Bundle.module.path(forResource: "SimpleJSONSchema", ofType: "json")
        let fp = try XCTUnwrap(filePath)
        let url = URL(fileURLWithPath: fp)        
        
        let schemaData = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        let schema = try decoder.decode(JSONSchema.self, from: schemaData)
        
    
        
        XCTAssertTrue(schema.type == .object)
        XCTAssertTrue(schema.properties?.count == 2)
        
        let fruits = try XCTUnwrap(schema.properties?["fruits"])
        XCTAssertTrue(fruits.jsonType().type == .array)
        XCTAssertTrue(fruits.jsonType().items?.type == .string)
        
        
        let vegetable = try XCTUnwrap(schema.properties?["vegetables"])
        XCTAssertEqual(vegetable.jsonType().type, .array)
        XCTAssertEqual(vegetable.jsonType().items?.reference, "#/definitions/veggie")
        
        
        XCTAssertTrue(schema.definitions?.count == 2)
        let veggie = try XCTUnwrap(schema.definitions?["veggie"])
        XCTAssertTrue(veggie.jsonType().type == .object)
        XCTAssertTrue(veggie.jsonType().required?.count == 2)
        
        
        let veggieName = try XCTUnwrap(veggie.jsonType().getProperties()?["veggieName"])
        XCTAssertTrue(veggieName.jsonType().type == .string)
        
        let veggieLike = try XCTUnwrap(veggie.jsonType().getProperties()?["veggieLike"])
        XCTAssertTrue(veggieLike.jsonType().type == .boolean)
    }
    

    func testSAMJSONSchemaReader() throws {
        
        // load schema from file (the file must be referenced in the Resource section of Package.swift
        // https://stackoverflow.com/questions/47177036/use-resources-in-unit-tests-with-swift-package-manager
        let filePath = Bundle.module.path(forResource: "SAMJSONSchema", ofType: "json")
        let fp = try XCTUnwrap(filePath)
        let url = URL(fileURLWithPath: fp)
        
        let schemaData = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        let schema = try decoder.decode(JSONSchema.self, from: schemaData)
        
        
        XCTAssertEqual(schema.type, .object)
        XCTAssertEqual(schema.required?.count, 1)
        XCTAssertEqual(schema.required?.first, "Resources")
        
        
        XCTAssertNotNil(schema.properties?["AWSTemplateFormatVersion"])
        if let formatVersion = schema.properties?["AWSTemplateFormatVersion"] {
            XCTAssertEqual(formatVersion.jsonType().type, .string)
        }
        
        let patternProperties = ["Conditions", "Mappings", "Outputs", "Parameters", "Resources"]
        for prop in patternProperties {
            XCTAssertNotNil(schema.properties?[prop])
            if let property = schema.properties?[prop] {
                XCTAssertEqual(property.jsonType().type, .object)
                XCTAssertTrue(property.jsonType().additionalProperties == false)
            }
        }
        
        
    }

}
