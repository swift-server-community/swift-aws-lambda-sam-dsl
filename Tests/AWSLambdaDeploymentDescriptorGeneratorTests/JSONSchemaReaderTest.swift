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

@testable import AWSLambdaDeploymentDescriptorGenerator
import Foundation
import XCTest

final class JSONSchemaReaderTest: XCTestCase {
    // [https://github.com/apple/swift/blob/9af806e8fd93df3499b1811deae7729176879cb0/test/stdlib/TestJSONEncoder.swift]

    /// Tests the `SAMJSONSchemaReader` functionality by verifying the contents of a JSON schema file.
    func testSAMJSONSchemaReader() throws {
        /// **Load the Schema**: Retrieves the JSON schema file named `SAMJSONSchema.json` from the package's resources.
        ///    - The file should be referenced in the `Resources` section of the `Package.swift` file.
        ///    - If the file path is not found, the test will fail.
        // https://stackoverflow.com/questions/47177036/use-resources-in-unit-tests-with-swift-package-manager
        let filePath = Bundle.module.path(forResource: "SAMJSONSchema", ofType: "json")
        let fp = try XCTUnwrap(filePath)
        let url = URL(fileURLWithPath: fp)

        /// **Decode the Schema**: Uses `JSONDecoder` to decode the schema data into a `JSONSchema` object.
        ///    - Verifies that the schema URL follows the expected format (starts with `http://json-schema.org/draft-`).
        ///    - Checks that the schema version is among the supported versions.
        let schemaData = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let schema = try decoder.decode(JSONSchema.self, from: schemaData)
        let schemaURLString = schema.schema.rawValue
        XCTAssertTrue(schemaURLString.hasPrefix("http://json-schema.org/draft-"), "Unknown schema version format")
        let expectedVersion = JSONSchemaDialectVersion(rawValue: schemaURLString)
        XCTAssertNotNil(expectedVersion, "Schema version not found in supported versions")
        XCTAssertEqual(schema.schema.rawValue, "http://json-schema.org/draft-04/schema#")
    }

    /// Validates key properties of the provided `JSONSchema` to ensure it meets specific criteria.
    /// - Parameter schema: The `JSONSchema` instance to be validated. It should conform to the expected structure and include the `additionalProperties`, `required`, `type`, and `properties` properties.
    func testSchemaValidation(schema: JSONSchema) throws {
        XCTAssertFalse(schema.additionalProperties!)
        XCTAssertEqual(schema.required, ["Resources"])
        XCTAssertEqual(schema.type, .object)
        XCTAssertNotNil(schema.properties)
    }

    /// Tests various properties within the provided `JSONSchema` to ensure they meet specific criteria.
    /// - Parameter schema: The `JSONSchema` instance containing the properties to be validated. It must include the properties being tested and conform to the expected structure.
    func testSchemaProperties(schema: JSONSchema) throws {
        guard let awstefVersion = schema.properties?["AWSTemplateFormatVersion"] else {
            XCTFail("Missing AWSTemplateFormatVersion property in schema")
            return
        }
        XCTAssertEqual(awstefVersion.jsonType().type?.first, .string)
        XCTAssertEqual(awstefVersion.jsonType().enumeration?.first, "2010-09-09")
        guard let conditionsProperty = schema.properties?["Conditions"] else {
            XCTFail("Missing Conditions property in schema")
            return
        }
        XCTAssertEqual(conditionsProperty.jsonType().type?.first, .object)
        XCTAssertNotNil(conditionsProperty.jsonType().object()?.patternProperties)
        guard let descriptionProperty = schema.properties?["Description"] else {
            XCTFail("Missing Description property in schema")
            return
        }
        XCTAssertEqual(descriptionProperty.jsonType().type?.first, .string)
        XCTAssertEqual(descriptionProperty.jsonType().description, "Template description")
        XCTAssertEqual(descriptionProperty.jsonType().stringSchema()?.maxLength, 1024)
        guard let resourcesProperty = schema.properties?["Resources"] else {
            XCTFail("Missing Resources property in schema")
            return
        }
        XCTAssertEqual(resourcesProperty.jsonType().type?.first, .object)
        XCTAssertNotNil(resourcesProperty.jsonType().object()?.patternProperties)

        if let patternProperties = schema.properties?["patternProperties"] {
            switch patternProperties {
            case .anyOf(let jsonTypes):

                if let firstType = jsonTypes.first, let secondType = jsonTypes.last {
                    switch firstType.subType {
                    case .string(let stringSchema):
                        XCTAssertEqual(stringSchema.pattern, "^[a-zA-Z0-9]+$")
                        XCTAssertEqual(firstType.type?.first, .string)
                    default:
                        XCTFail("Expected a StringSchema")
                    }

                    switch secondType.subType {
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
        guard let parametersProperty = schema.properties?["Parameters"] else {
            XCTFail("Missing Parameters property in schema")
            return
        }
        XCTAssertEqual(parametersProperty.jsonType().type?.first, .object)
        XCTAssertEqual(parametersProperty.jsonType().object()?.maxProperties, 50)

        let paramPatternProperties = parametersProperty.jsonType().object()?.patternProperties
        XCTAssertNotNil(paramPatternProperties)
        XCTAssertEqual(paramPatternProperties?.keys.first, "^[a-zA-Z0-9]+$")
        guard let paramSchema = paramPatternProperties?.values.first as? JSONUnionType else {
            XCTFail("Expected a JSONUnionType in Parameters patternProperties")
            return
        }
        XCTAssertEqual(paramSchema.jsonType().reference, "#/definitions/Parameter")
        guard let mappingsProperty = schema.properties?["Mappings"] else {
            XCTFail("Missing Mappings property in schema")
            return
        }
        XCTAssertEqual(mappingsProperty.jsonType().type?.first, .object)
        XCTAssertEqual(mappingsProperty.jsonType().object()?.patternProperties?.keys.first, "^[a-zA-Z0-9]+$")
        guard let metadataProperty = schema.properties?["Metadata"] else {
            XCTFail("Missing Metadata property in schema")
            return
        }
        XCTAssertEqual(metadataProperty.jsonType().type?.first, .object)
        guard let outputsProperty = schema.properties?["Outputs"] else {
            XCTFail("Missing Outputs property in schema")
            return
        }
        XCTAssertEqual(outputsProperty.jsonType().type?.first, .object)
        XCTAssertEqual(outputsProperty.jsonType().object()?.maxProperties, 60)
        XCTAssertEqual(outputsProperty.jsonType().object()?.minProperties, 1)
        XCTAssertEqual(outputsProperty.jsonType().object()?.patternProperties?.keys.first, "^[a-zA-Z0-9]+$")
        guard let transformProperty = schema.properties?["Transform"] else {
            XCTFail("Missing Transform property in schema")
            return
        }
        XCTAssertEqual(transformProperty.jsonType().type?.first, .string)
        XCTAssertEqual(transformProperty.jsonType().enumeration?.first, "AWS::Serverless-2016-10-31")
        guard let globalsProperty = schema.properties?["Globals"] else {
            XCTFail("Missing Globals property in schema")
            return
        }
        XCTAssertEqual(globalsProperty.jsonType().type?.first, .object)
        guard let propertiesProperty = schema.properties?["Properties"] else {
            XCTFail("Missing Properties property in schema")
            return
        }
        XCTAssertEqual(propertiesProperty.jsonType().type?.first, .object)
    }

    /// Tests the `definitions` section of the provided `JSONSchema` to ensure it is properly defined.
    /// - Parameter schema: The `JSONSchema` instance to be validated. It should conform to the expected schema structure and include the `definitions` property.
    func testSchemaDefinitions(schema: JSONSchema) throws {
        XCTAssertNotNil(schema.definitions)
    }

    /// Tests the `patternProperties` section of the given `JSONSchema` to ensure compliance with specific rules.
    /// - Parameter schema: The `JSONSchema` instance to be tested. It should conform to the expected schema structure and contain the properties listed for validation.
    func testSchemaPatternProperties(schema: JSONSchema) throws {
        /// . **Pattern Properties**: Checks that specific properties (`Conditions`, `Mappings`, `Outputs`, `Parameters`, `Resources`) are present and that their `additionalProperties` is `false`.
        let patternProperties = ["Conditions", "Mappings", "Outputs", "Parameters", "Resources"]
        for prop in patternProperties {
            XCTAssertNotNil(schema.properties?[prop])
            if let property = schema.properties?[prop] {
                XCTAssertTrue(property.jsonType().additionalProperties == false)
            }
        }
    }

    /// Tests the extraction and decoding of a JSON schema with `patternProperties` and `additionalProperties` constraints.
    func testJSONTypePatternProperties() throws {
        try self._testJSONExtract(json: """
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

    /// Tests the extraction and decoding of a JSON schema with `maxProperties`, `patternProperties`, and `additionalProperties` constraints.
    func testJSONTypeMinMaxProperties() throws {
        try self._testJSONExtract(json: """
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

    /// Tests the extraction and decoding of a JSON schema with `patternProperties` containing `anyOf` constraints for resource types.
    func testJSONTypeResources() throws {
        try self._testJSONExtract(json: """
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

    /// Tests the extraction and decoding of a JSON schema that uses `anyOf` for property definitions.
    func testJSONTypeAnyOf() throws {
        try self._testJSONExtract(json: """
        {
                 "additionalProperties": false,
                 "properties": {
                   "Method": {
                     "type": "string"
                   },
                   "Path": {
                     "type": "string"
                   },
                   "RestApiId": {
                     "anyOf": [
                       {
                         "type": "string"
                       },
                       {
                         "type": "object"
                       }
                     ]
                   }
                 },
                 "required": [
                   "Method",
                   "Path"
                 ],
                 "type": "object"
        }
        """, decodeTo: JSONType.self)
    }

    /// Tests the extraction and decoding of a JSON schema that uses `anyOf` and `array` for property definitions.
    func testJSONUnionType() throws {
        try self._testJSONExtract(json: """
        {
                    "additionalProperties": false,
                    "properties": {
                      "UserPool": {
                        "anyOf": [
                          {
                            "type": "string"
                          },
                          {
                            "type": "object"
                          }
                        ]
                      },
                      "Trigger": {
                        "anyOf": [
                          {
                            "type": "string"
                          },
                          {
                            "items": {
                              "type": "string"
                            },
                            "type": "array"
                          }
                        ]
                      }
                    },
                    "required": [
                      "UserPool",
                      "Trigger"
                    ],
                    "type": "object"

        }
        """, decodeTo: JSONType.self)
    }

    /// Tests the extraction and decoding of a JSON schema with specific `properties` and `required` fields.
    func testJSONTypeProperties() throws {
        try self._testJSONExtract(json: """
        {
                    "additionalProperties": false,
                    "properties": {
                      "Properties": {
                        "anyOf": [
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.S3Event"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.SNSEvent"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.KinesisEvent"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.MSKEvent"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.MQEvent"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.SQSEvent"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.DynamoDBEvent"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.ApiEvent"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.ScheduleEvent"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.CloudWatchEventEvent"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.EventBridgeRule"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.LogEvent"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.IoTRuleEvent"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.AlexaSkillEvent"
                          },
                          {
                            "$ref": "#/definitions/AWS::Serverless::Function.CognitoEvent"
                          }
                        ]
                      },
                      "Type": {
                        "type": "string"
                      }
                    },
                    "required": [
                      "Properties",
                      "Type"
                    ],
                    "type": "object"

        }
        """, decodeTo: JSONType.self)
    }

    /// Tests the extraction and decoding of a JSON schema for a `Parameter` object.
    func testJSONTypeParameter() throws {
        try self._testJSONExtract(json: """
        {
        "Parameter": {
          "additionalProperties": false,
          "properties": {
            "AllowedPattern": {
              "type": "string"
            },
            "AllowedValues": {
              "type": "array"
            },
            "ConstraintDescription": {
              "type": "string"
            },
            "Default": {
              "type": "string"
            },
            "Description": {
              "type": "string"
            },
            "MaxLength": {
              "type": "string"
            },
            "MaxValue": {
              "type": "string"
            },
            "MinLength": {
              "type": "string"
            },
            "MinValue": {
              "type": "string"
            },
            "NoEcho": {
              "type": [
                "string",
                "boolean"
              ]
            },
            "Type": {
              "enum": [
                "String",
                "Number",
                "List<Number>",
                "CommaDelimitedList",
                "AWS::EC2::AvailabilityZone::Name",
                "AWS::EC2::Image::Id",
                "AWS::EC2::Instance::Id",
                "AWS::EC2::KeyPair::KeyName",
                "AWS::EC2::SecurityGroup::GroupName",
                "AWS::EC2::SecurityGroup::Id",
                "AWS::EC2::Subnet::Id",
                "AWS::EC2::Volume::Id",
                "AWS::EC2::VPC::Id",
                "AWS::Route53::HostedZone::Id",
                "List<AWS::EC2::AvailabilityZone::Name>",
                "List<AWS::EC2::Image::Id>",
                "List<AWS::EC2::Instance::Id>",
                "List<AWS::EC2::SecurityGroup::GroupName>",
                "List<AWS::EC2::SecurityGroup::Id>",
                "List<AWS::EC2::Subnet::Id>",
                "List<AWS::EC2::Volume::Id>",
                "List<AWS::EC2::VPC::Id>",
                "List<AWS::Route53::HostedZone::Id>",
                "List<String>"
              ],
              "type": "string"
            }
          },
          "required": [
            "Type"
          ],
          "type": "object"
        }

        }
        """, decodeTo: JSONType.self)
    }

    /// Tests the extraction and decoding of a JSON schema for a `DependsOn` object.
    func testJSONTypeDependsOn() throws {
        try self._testJSONExtract(json: """
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
        """, decodeTo: JSONType.self)
    }

    /// Tests the extraction and decoding of a basic JSON schema with a single property.
    func testBasicJSONType() throws {
        try self._testJSONExtract(json: """
                         {
                           "properties": {
                             "InlineCode": {
                               "type": "string"
                             }
                           }
                         }
        """, decodeTo: JSONType.self)
    }

    /// Tests the extraction and decoding of a JSON schema that uses the `allOf` and `anyOf` constructs.
    func testAllOfJSONType() throws {
        try self._testJSONExtract(json: """
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
        """, decodeTo: JSONType.self)
    }

    /// Tests the extraction and decoding of a JSON schema for a serverless function configuration.
    func testJSONTypeServerlessFunction() throws {
        try self._testJSONExtract(json: """
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

    /// Tests the extraction and decoding of a JSON string into a specified Decodable type.
    /// - Parameters:
    ///   - json: A string containing the JSON data to be decoded. This JSON string should represent the schema or data to be validated.
    ///   - type: The type that the JSON data should be decoded into. This type must conform to the `Decodable` protocol.
    func _testJSONExtract(json: String, decodeTo type: Decodable.Type) throws {
        let decoder = JSONDecoder()
        let data = try XCTUnwrap(json.data(using: .utf8))
        XCTAssertNoThrow(try decoder.decode(type, from: data))
    }
}
