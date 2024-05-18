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
        XCTAssertTrue(schema.properties?.count == 4)
        let fruits = try XCTUnwrap(schema.properties?["fruits"])
        let fruitType = try XCTUnwrap(fruits.jsonType().type)
        XCTAssertTrue(fruitType.contains(.array))
        XCTAssertTrue(fruits.jsonType().items == ArrayItem.type([.string]))
        
        let testArrayMultipleTypes = try XCTUnwrap(schema.properties?["testArrayMultipleTypes"])
        XCTAssertTrue(testArrayMultipleTypes.jsonType().items == ArrayItem.type([.string, .boolean]))
        
        let testAnyOfArrayItem = try XCTUnwrap(schema.properties?["testAnyOfArrayItem"])
        if case .anyOfArrayItem(let ai) = testAnyOfArrayItem {
            XCTAssertTrue(ai.count == 2)
            XCTAssertTrue(ai[0] == ArrayItem.type([.string]))
            XCTAssertTrue(ai[1] == ArrayItem.ref("#/definitions/AWS::Serverless::Api.S3Location"))
        } else {
            XCTFail("Not an [ArrayItem]")
        }


        let vegetable = try XCTUnwrap(schema.properties?["vegetables"])
        XCTAssertTrue(vegetable.jsonType().items == ArrayItem.ref("#/definitions/veggie"))
        
        XCTAssertTrue(schema.definitions?.count == 2)
        let veggie = try XCTUnwrap(schema.definitions?["veggie"])
        let veggieType = try XCTUnwrap(veggie.jsonType().type)
        XCTAssertTrue(veggieType.contains(.object))
        XCTAssertTrue(veggie.jsonType().required?.count == 2)
        
        let veggieName = try XCTUnwrap(veggie.jsonType().properties?["veggieName"])
        let veggieNameType = try XCTUnwrap(veggieName.jsonType().type)
        XCTAssertTrue(veggieNameType.contains(.string))
        
        let veggieLike = try XCTUnwrap(veggie.jsonType().properties?["veggieLike"])
        let veggieLikeType = try XCTUnwrap(veggieLike.jsonType().type)
        XCTAssertTrue(veggieLikeType.contains(.boolean))
    }

    func testSAMJSONSchemaReader() throws {
        
        // load schema from file (the file must be referenced in the Resource section of Package.swift
        // https://stackoverflow.com/questions/47177036/use-resources-in-unit-tests-with-swift-package-manager
        let filePath = Bundle.module.path(forResource: "SAMJSONSchema", ofType: "json")
        let fp = try XCTUnwrap(filePath)
        let url = URL(fileURLWithPath: fp)        
        
        let schemaData = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        let schema = try? decoder.decode(JSONSchema.self, from: schemaData)
//        print(schema)

        // TODO : validate a couple of assertions here (not all)
    }
}
