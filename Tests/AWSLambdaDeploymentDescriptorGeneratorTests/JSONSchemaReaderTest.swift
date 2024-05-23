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
        
        
        XCTAssertTrue(schema.type == .single(.object))
        XCTAssertNotNil(schema.properties)
        XCTAssertTrue(schema.properties?.count == 2)
        
        //fruits properties
        if let fruitsProperty = schema.properties?["fruits"] {
            switch fruitsProperty {
            case .type(let jsonType):
                XCTAssertEqual(jsonType.type?.first, .array)
                XCTAssertEqual(jsonType.getItems()?.type?.first, .string)
            default:
                XCTFail("Expected a JSONType")
            }
        }
        
        //vegetables properties
        if let vegetablesProperty = schema.properties?["vegetables"] {
            switch vegetablesProperty {
            case .type(let jsonType):
                XCTAssertEqual(jsonType.type?.first, .array)
                if let items = jsonType.getItems() {
                    XCTAssertEqual(items.ref, "#/definitions/veggie")
                }
            default:
                XCTFail("Expected a JSONType")
            }
        }
        
        //veggie definitions
        if let veggieDefinition = schema.definitions?["veggie"] {
            switch veggieDefinition {
            case .type(let jsonType):
                XCTAssertEqual(jsonType.type?.first, .object)
                XCTAssertEqual(jsonType.required, ["veggieName", "veggieLike"])
                
                if let properties = jsonType.getProperties() {
                    XCTAssertEqual(properties.count, 2)
                    
                    if let veggieNameProperty = properties["veggieName"] {
                        switch veggieNameProperty {
                        case .type(let jsonType):
                            XCTAssertEqual(jsonType.type?.first, .string)
                            XCTAssertEqual(jsonType.description, "The name of the vegetable.")
                        default:
                            XCTFail("Expected a JSONType")
                        }
                    }
                    
                    if let veggieLikeProperty = properties["veggieLike"] {
                        switch veggieLikeProperty {
                        case .type(let jsonType):
                            XCTAssertEqual(jsonType.type?.first, .boolean)
                            XCTAssertEqual(jsonType.description, "Do I like this vegetable?")
                        default:
                            XCTFail("Expected a JSONType")
                        }
                    }
                }
            default:
                XCTFail("Expected a JSONType")
            }
        }
        
        // DependsOn definitions
        if let dependsOnDefinition = schema.definitions?["DependsOn"] {
            switch dependsOnDefinition {
            case .anyOf(let jsonTypes):
                XCTAssertEqual(jsonTypes.count, 2)
                
                if let firstType = jsonTypes.first, let secondType = jsonTypes.last {
                    switch firstType.schemaType {
                    case .string(let stringSchema):
                        XCTAssertEqual(stringSchema.pattern, "^[a-zA-Z0-9]+$")
                        XCTAssertEqual(firstType.type?.first, .string)
                    default:
                        XCTFail("Expected a StringSchema")
                    }
                    
                    switch secondType.schemaType {
                    case .array(let arraySchema):
                        XCTAssertEqual(arraySchema.items?.type?.first, .string)
                        XCTAssertEqual(secondType.type?.first, .array)
                    default:
                        XCTFail("Expected an ArraySchema")
                    }
                }
            default:
                XCTFail("Expected an anyOf type")
            }
        }
        
        
    }
    
    
    func testSAMJSONSchemaReader() throws { // add more cases
        
        // load schema from file (the file must be referenced in the Resource section of Package.swift
        // https://stackoverflow.com/questions/47177036/use-resources-in-unit-tests-with-swift-package-manager
        let filePath = Bundle.module.path(forResource: "SAMJSONSchema", ofType: "json")
        let fp = try XCTUnwrap(filePath)
        let url = URL(fileURLWithPath: fp)
        
        let schemaData = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        let schema = try decoder.decode(JSONSchema.self, from: schemaData)
        
        
        XCTAssertEqual(schema.type, .single(.object))
        
        
        
        XCTAssertNotNil(schema.properties?["AWSTemplateFormatVersion"])
        if let formatVersion = schema.properties?["AWSTemplateFormatVersion"] {
            XCTAssertEqual(formatVersion.jsonType().type?.first, .string)
        }
        
        
        let patternProperties = ["Conditions", "Mappings", "Outputs", "Parameters", "Resources"]
        for prop in patternProperties {
            XCTAssertNotNil(schema.properties?[prop])
            if let property = schema.properties?[prop] {
                XCTAssertTrue(property.jsonType().additionalProperties == false)
            }
        }
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
    
    
    func testJSONTypeDependsOn() throws {
        
        try _testJSONExtract(json:"""
                        {
                              "DependsOn": {
                                "anyOf": [
                                  {
                                    "pattern": "^[a-zA-Z0-9]+$",
                                    "type": "string"
                                  },
                                  {
                                    "items": {
                                      "pattern": "^[a-zA-Z0-9]+$",
                                      "type": "string"
                                    },
                                    "type": "array"
                                  }
                                ]
                              }
                        }
       """,decodeTo: JSONType.self)
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
    
    func testAllOfJSONType() throws {
        try _testJSONExtract(json: """
                             {
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
                             }
                             """,decodeTo: JSONType.self)
    }
    
    
    ///allOf
    func testJSONTypeServerlessFunction() throws {
        
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
    
    internal func _testJSONExtract(json: String, decodeTo type: Decodable.Type) throws {
        let decoder = JSONDecoder()
        let data = try XCTUnwrap(json.data(using: .utf8))
        XCTAssertNoThrow(try decoder.decode(type, from: data))
    }
    
    
}
