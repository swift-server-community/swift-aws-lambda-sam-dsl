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

    func testUnsupportedSChemaVersion() throws {
        
        let JSONSchemaData = """
{
  "$id": "https://example.com/arrays.schema.json",
  "$schema": "https://json-schema.org/draft/UNSUPPORTED/schema",
  "description": "A representation of a person, company, organization, or place",
  "type": "object"
}
""".data(using: .utf8)

        let decoder = JSONDecoder()
        let data = try XCTUnwrap(JSONSchemaData)
        XCTAssertThrowsError(try decoder.decode(JSONSchema.self, from: data))
    }


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
        XCTAssertTrue(fruits.jsonType().getItems()?.type?.contains([.string]) ?? false)
        
        let testArrayMultipleTypes = try XCTUnwrap(schema.properties?["testArrayMultipleTypes"])
        XCTAssertTrue(testArrayMultipleTypes.jsonType().getItems()?.type?.contains([.string, .boolean]) ?? false)
        
        let testAnyOfArrayItem = try XCTUnwrap(schema.properties?["testAnyOfArrayItem"])
        if case .anyOf(let ai) = testAnyOfArrayItem {
            XCTAssertTrue(ai.count == 2)
            XCTAssertTrue(ai[0].type?.contains([.string]) ?? false)
            XCTAssertTrue(ai[1].ref == "#/definitions/AWS::Serverless::Api.S3Location")
        } else {
            XCTFail("Not an [ArrayItem]")
        }

        let vegetable = try XCTUnwrap(schema.properties?["vegetables"])
        XCTAssertTrue(vegetable.jsonType().getItems()?.ref == "#/definitions/veggie")
        
        XCTAssertTrue(schema.definitions?.count == 2)
        let veggie = try XCTUnwrap(schema.definitions?["veggie"])
        let veggieType = try XCTUnwrap(veggie.jsonType().type)
        XCTAssertTrue(veggieType.contains(.object))
        XCTAssertTrue(veggie.jsonType().required?.count == 2)
        
        let veggieName = try XCTUnwrap(veggie.jsonType().getObject(for: "veggieName"))
        let veggieNameType = try XCTUnwrap(veggieName.jsonType().type)
        XCTAssertTrue(veggieNameType.contains(.string))
        
        let veggieLike = try XCTUnwrap(veggie.jsonType().getObject(for: "veggieLike"))
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
        let schema = try decoder.decode(JSONSchema.self, from: schemaData)
        print(schema)
        
        // validate top level properties 
        XCTAssertTrue(schema.schema == .draft4)
        XCTAssertTrue(try XCTUnwrap(schema.required?.contains("Resources")))
        XCTAssertTrue(schema.type == .object)
        XCTAssertTrue(schema.additionalProperties == false)

        // check properties
        XCTAssertTrue(schema.properties?.count == 11)
        let t1 = try XCTUnwrap(schema.properties?["Transform"]?.jsonType().enumeration)
        XCTAssertTrue(t1.contains(["AWS::Serverless-2016-10-31"]))
        let t2 = try XCTUnwrap(schema.properties?["Resources"]?.jsonType())
        if case let .object(schema) = t2.subType {
            let t3 = try XCTUnwrap(schema.patternProperties?["^[a-zA-Z0-9]+$"])
            XCTAssertTrue(t3.any()?.count == 4)
            XCTAssertTrue(t3.any()?[0].ref == "#/definitions/AWS::Serverless::Api")
        } else {
            XCTFail("the subschema is not an object")
        }
        
        // check definition
        XCTAssertTrue(schema.definitions?.count == 32)
        let t4 = try XCTUnwrap(schema.definitions?["AWS::Serverless::SimpleTable"]?.jsonType())
        if case let .object(schema) = t4.subType {
            let t3 = try XCTUnwrap(schema.properties?["DependsOn"])
            let t4 = try XCTUnwrap(t3.any())
            XCTAssertTrue(t4.count == 2)
            XCTAssertTrue(t4[0].type?.count == 1)
            XCTAssertTrue(t4[0].type?.contains([.string]) ?? false)
            if case let .string(schema) = t4[0].subType {
                XCTAssertTrue(schema.pattern == "^[a-zA-Z0-9]+$")
            } else {
                XCTFail("the subschema is not a string")
            }
            XCTAssertTrue(t4[1].type?.count == 1)
            XCTAssertTrue(t4[1].type?.contains([.array]) ?? false)
            if case let .array(schema) = t4[1].subType {
                XCTAssertTrue(schema.items?.type?.count == 1)
                XCTAssertTrue(schema.items?.type?.contains([.string]) ?? false)
                XCTAssertTrue(schema.items?.getPattern() == "^[a-zA-Z0-9]+$")
            } else {
                XCTFail("the subschema is not an array")
            }
        } else {
            XCTFail("the subschema is not an object")
        }

        // TODO : validate a couple of assertions here (not all)
    }
    
    func testJSONTypePatternProperties() throws {

        try _testJSONExtract(json:"""
    {
      "additionalProperties": false,
      "patternProperties": {
        "^[a-zA-Z0-9]+$": {
          "type": "object"
        }
      },
      "type": "object"
    }
""", decodeTo: JSONType.self)
    }
    
    func testJSONTypeMinMaxProperties() throws {
        
        try _testJSONExtract(json:"""
    {
      "additionalProperties": false,
      "maxProperties": 50,
      "patternProperties": {
        "^[a-zA-Z0-9]+$": {
          "$ref": "#/definitions/Parameter"
        }
      },
      "type": "object"
    }
""", decodeTo: JSONType.self)

    }
    
    func testJSONTypeResources() throws {
        
        try _testJSONExtract(json:"""
    {
      "additionalProperties": false,
      "patternProperties": {
        "^[a-zA-Z0-9]+$": {
          "anyOf": [
            {
              "$ref": "#/definitions/AWS::Serverless::Api"
            },
            {
              "$ref": "#/definitions/AWS::Serverless::Function"
            },
            {
              "$ref": "#/definitions/AWS::Serverless::SimpleTable"
            },
            {
              "$ref": "#/definitions/CloudFormationResource"
            }
          ]
        }
      },
      "type": "object"
    }
""", decodeTo: JSONType.self)
    }
    
    func testJSONTYpeServerlessFunction() throws {

        try _testJSONExtract(json:"""
    {
      "additionalProperties": false,
      "properties": {

        "Properties": {
          "allOf": [
             {
               "anyOf": [
                 {
                   "properties": {
                     "InlineCode": {
                       "type": "string"
                     }
                   }
                 },
                 {
                   "properties": {
                     "CodeUri": {
                       "anyOf": [
                         {
                           "type": [
                             "string"
                           ]
                         },
                         {
                           "$ref": "#/definitions/AWS::Serverless::Function.S3Location"
                         }
                       ]
                     }
                   }
                 }
               ]
             }
          ]
        }
      },
      "required": [
        "Type",
        "Properties"
      ],
      "type": "object"
    }
""", decodeTo: JSONType.self)

    }
    
    
    func testBasicJSONType() throws {
        
        try _testJSONExtract(json:"""
                 {
                   "properties": {
                     "InlineCode": {
                       "type": "string"
                     }
                   }
                 }
""",decodeTo: JSONType.self)
    }
    
    internal func _testJSONExtract(json: String, decodeTo type: Decodable.Type) throws {
        let decoder = JSONDecoder()
        let data = try XCTUnwrap(json.data(using: .utf8))
        XCTAssertNoThrow(try decoder.decode(type, from: data))
    }
}
