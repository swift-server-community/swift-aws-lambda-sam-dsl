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

// maybe this file might be generated entirely or partially automatically from
// https://github.com/aws/serverless-application-model/blob/develop/samtranslator/validator/sam_schema/schema.json

// a Swift definition of a SAM deployment descriptor.
// currently limited to the properties I needed for the examples.
// An immediate TODO if this code is accepted is to add more properties and more struct
public struct SAMDeploymentDescriptor: Encodable, Sendable {
  let templateVersion: String = "2010-09-09"
  let transform: String = "AWS::Serverless-2016-10-31"
  let description: String
  var resources: [String: Resource<ResourceType>]?

  public init(
    description: String,
    resources: [Resource<ResourceType>] = []
  ) {
    self.description = description

    if resources.count > 0 {
      self.resources = [:]
      // extract resources names for serialization
      for res in resources {
        self.resources![res.name] = res
      }
    }
  }

  enum CodingKeys: String, CodingKey {
    case templateVersion = "AWSTemplateFormatVersion"
    case transform = "Transform"
    case description = "Description"
    case resources = "Resources"
  }
}

public protocol SAMResource: Encodable, Equatable, Sendable {}
public protocol SAMResourceType: Encodable, Equatable, Sendable {}
public protocol SAMResourceProperties: Encodable, Sendable {}

// public protocol Table: SAMResource {
//   func type() -> String
// }
// public extension Table {
//   func type() -> String { return "AWS::Serverless::SimpleTable" }
// }

public enum ResourceType: String, SAMResourceType {
  case function = "AWS::Serverless::Function"
  case queue = "AWS::SQS::Queue"
  case table = "AWS::Serverless::SimpleTable"
}

public enum EventSourceType: String, SAMResourceType {
  case httpApi = "HttpApi"
  case sqs = "SQS"
}

// generic type to represent either a top-level resource or an event source
public struct Resource<T: SAMResourceType>: SAMResource {
  let type: T
  let properties: SAMResourceProperties?
  let name: String

  public static func == (lhs: Resource<T>, rhs: Resource<T>) -> Bool {
    lhs.type == rhs.type && lhs.name == rhs.name
  }

  enum CodingKeys: String, CodingKey {
    case type = "Type"
    case properties = "Properties"
  }

  // this is to make the compiler happy : Resource now conforms to Encodable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.type, forKey: .type)
    if let properties = self.properties {
      try container.encode(properties, forKey: .properties)
    }
  }
}

// MARK: Lambda Function resource definition

/*---------------------------------------------------------------------------------------
 Lambda Function

 https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-function.html
 -----------------------------------------------------------------------------------------*/

public struct ServerlessFunctionProperties: SAMResourceProperties {
  public enum Architectures: String, Encodable, CaseIterable, Sendable {
    case x64 = "x86_64"
    case arm64

    // the default value is the current architecture
    public static func defaultArchitecture() -> Architectures {
      #if arch(arm64)
        return .arm64
      #else  // I understand this #else will not always be true. Developers can overwrite the default in Deploy.swift
        return .x64
      #endif
    }

    // valid values for error and help message
    public static func validValues() -> String {
      Architectures.allCases.map(\.rawValue).joined(separator: ", ")
    }
  }

  // https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-function-ephemeralstorage.html
  public struct EphemeralStorage: Encodable, Sendable {
    private let validValues = 512...10240
    let size: Int
    init?(_ size: Int) {
      if self.validValues.contains(size) {
        self.size = size
      } else {
        return nil
      }
    }

    enum CodingKeys: String, CodingKey {
      case size = "Size"
    }
  }

  public struct EventInvokeConfiguration: Encodable, Sendable {
    public enum EventInvokeDestinationType: String, Encodable, Sendable {
      case sqs = "SQS"
      case sns = "SNS"
      case lambda = "Lambda"
      case eventBridge = "EventBridge"

      public static func destinationType(from arn: Arn?) -> EventInvokeDestinationType? {
        guard let service = arn?.service() else {
          return nil
        }
        switch service.lowercased() {
        case "sqs":
          return .sqs
        case "sns":
          return .sns
        case "lambda":
          return .lambda
        case "eventbridge":
          return .eventBridge
        default:
          return nil
        }
      }

      public static func destinationType(from resource: Resource<ResourceType>?)
        -> EventInvokeDestinationType?
      {
        guard let res = resource else {
          return nil
        }
        switch res.type {
        case .queue:
          return .sqs
        case .function:
          return .lambda
        default:
          return nil
        }
      }
    }

    public struct EventInvokeDestination: Encodable, Sendable {
      let destination: Reference?
      let type: EventInvokeDestinationType?
      public enum CodingKeys: String, CodingKey {
        case destination = "Destination"
        case type = "Type"
      }
    }

    public struct EventInvokeDestinationConfiguration: Encodable, Sendable {
      let onSuccess: EventInvokeDestination?
      let onFailure: EventInvokeDestination?
      public enum CodingKeys: String, CodingKey {
        case onSuccess = "OnSuccess"
        case onFailure = "OnFailure"
      }
    }

    let destinationConfig: EventInvokeDestinationConfiguration?
    let maximumEventAgeInSeconds: Int?
    let maximumRetryAttempts: Int?
    public enum CodingKeys: String, CodingKey {
      case destinationConfig = "DestinationConfig"
      case maximumEventAgeInSeconds = "MaximumEventAgeInSeconds"
      case maximumRetryAttempts = "MaximumRetryAttempts"
    }
  }

  // TODO: add support for reference to other resources of type elasticfilesystem or mountpoint
  public struct FileSystemConfig: Encodable, Sendable {
    // regex from
    // https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-function-filesystemconfig.html
    let validMountPathRegex = #"^/mnt/[a-zA-Z0-9-_.]+$"#
    let validArnRegex =
      #"arn:aws[a-zA-Z-]*:elasticfilesystem:[a-z]{2}((-gov)|(-iso(b?)))?-[a-z]+-\d{1}:\d{12}:access-point/fsap-[a-f0-9]{17}"#
    let reference: Reference
    let localMountPath: String

    public init?(arn: String, localMountPath: String) {
      guard arn.range(of: self.validArnRegex, options: .regularExpression) != nil,
        localMountPath.range(of: self.validMountPathRegex, options: .regularExpression) != nil
      else {
        return nil
      }

      guard let realArn = Arn(arn) else { return nil }
      self.reference = .arn(realArn)
      self.localMountPath = localMountPath
    }

    enum CodingKeys: String, CodingKey {
      case reference = "Arn"
      case localMountPath = "LocalMountPath"
    }
  }

  public struct URLConfig: Encodable, Sendable {
    public enum AuthType: String, Encodable, Sendable {
      case iam = "AWS_IAM"
      case none = "None"
    }

    public enum InvokeMode: String, Encodable, Sendable {
      case responseStream = "RESPONSE_STREAM"
      case buffered = "BUFFERED"
    }

    public struct Cors: Encodable, Sendable {
      let allowCredentials: Bool?
      let allowHeaders: [String]?
      let allowMethods: [String]?
      let allowOrigins: [String]?
      let exposeHeaders: [String]?
      let maxAge: Int?
      public enum CodingKeys: String, CodingKey {
        case allowCredentials = "AllowCredentials"
        case allowHeaders = "AllowHeaders"
        case allowMethods = "AllowMethods"
        case allowOrigins = "AllowOrigins"
        case exposeHeaders = "ExposeHeaders"
        case maxAge = "MaxAge"
      }
    }

    let authType: AuthType
    let cors: Cors?
    let invokeMode: InvokeMode?
    public enum CodingKeys: String, CodingKey {
      case authType = "AuthType"
      case cors = "Cors"
      case invokeMode = "InvokeMode"
    }
  }

  let architectures: [Architectures]
  let handler: String
  let runtime: String
  let codeUri: String?
  var autoPublishAlias: String?
  var autoPublishAliasAllProperties: Bool?
  var autoPublishCodeSha256: String?
  var events: [String: Resource<EventSourceType>]?
  var environment: SAMEnvironmentVariable?
  var description: String?
  var ephemeralStorage: EphemeralStorage?
  var eventInvokeConfig: EventInvokeConfiguration?
  var fileSystemConfigs: [FileSystemConfig]?
  var functionUrlConfig: URLConfig?

  public init(
    codeUri: String?,
    architecture: Architectures,
    eventSources: [Resource<EventSourceType>] = [],
    environment: SAMEnvironmentVariable? = nil
  ) {
    self.architectures = [architecture]
    self.handler = "Provided"
    self.runtime = "provided.al2"  // Amazon Linux 2 supports both arm64 and x64
    self.codeUri = codeUri
    self.environment = environment

    if !eventSources.isEmpty {
      self.events = [:]
      for es in eventSources {
        self.events![es.name] = es
      }
    }
  }

  public enum CodingKeys: String, CodingKey {
    case architectures = "Architectures"
    case handler = "Handler"
    case runtime = "Runtime"
    case codeUri = "CodeUri"
    case autoPublishAlias = "AutoPublishAlias"
    case autoPublishAliasAllProperties = "AutoPublishAliasAllProperties"
    case autoPublishCodeSha256 = "AutoPublishCodeSha256"
    case events = "Events"
    case environment = "Environment"
    case description = "Description"
    case ephemeralStorage = "EphemeralStorage"
    case eventInvokeConfig = "EventInvokeConfig"
    case fileSystemConfigs = "FileSystemConfigs"
    case functionUrlConfig = "FunctionUrlConfig"
  }
}

/*
 Environment:
 Variables:
 LOG_LEVEL: debug
 */
public struct SAMEnvironmentVariable: Encodable, Sendable {
  public var variables: [String: SAMEnvironmentVariableValue] = [:]
  public init() {}
  public init(_ variables: [String: String]) {
    for key in variables.keys {
      self.variables[key] = .string(value: variables[key] ?? "")
    }
  }

  public static var none: SAMEnvironmentVariable { SAMEnvironmentVariable([:]) }

  public static func variable(_ name: String, _ value: String) -> SAMEnvironmentVariable {
    SAMEnvironmentVariable([name: value])
  }

  public static func variable(_ variables: [String: String]) -> SAMEnvironmentVariable {
    SAMEnvironmentVariable(variables)
  }

  public static func variable(_ variables: [[String: String]]) -> SAMEnvironmentVariable {
    var mergedDictKeepCurrent: [String: String] = [:]
    variables.forEach { dict in
      // inspired by https://stackoverflow.com/a/43615143/663360
      mergedDictKeepCurrent = mergedDictKeepCurrent.merging(dict) { current, _ in current }
    }

    return SAMEnvironmentVariable(mergedDictKeepCurrent)
  }

  public func isEmpty() -> Bool { self.variables.count == 0 }

  public mutating func append(_ key: String, _ value: String) {
    self.variables[key] = .string(value: value)
  }

  public mutating func append(_ key: String, _ value: [String: String]) {
    self.variables[key] = .array(value: value)
  }

  public mutating func append(_ key: String, _ value: [String: [String]]) {
    self.variables[key] = .dictionary(value: value)
  }

  public mutating func append(_ key: String, _ value: Resource<ResourceType>) {
    self.variables[key] = .array(value: ["Ref": value.name])
  }

  enum CodingKeys: String, CodingKey {
    case variables = "Variables"
  }

  public func encode(to encoder: Encoder) throws {
    guard !self.isEmpty() else {
      return
    }

    var container = encoder.container(keyedBy: CodingKeys.self)
    var nestedContainer = container.nestedContainer(keyedBy: AnyStringKey.self, forKey: .variables)

    for key in self.variables.keys {
      switch self.variables[key] {
      case .string(let value):
        try? nestedContainer.encode(value, forKey: AnyStringKey(key))
      case .array(let value):
        try? nestedContainer.encode(value, forKey: AnyStringKey(key))
      case .dictionary(let value):
        try? nestedContainer.encode(value, forKey: AnyStringKey(key))
      case .none:
        break
      }
    }
  }

  public enum SAMEnvironmentVariableValue: Sendable {
    // KEY: VALUE
    case string(value: String)

    // KEY:
    //    Ref: VALUE
    case array(value: [String: String])

    // KEY:
    //    Fn::GetAtt:
    //      - VALUE1
    //      - VALUE2
    case dictionary(value: [String: [String]])
  }
}

internal struct AnyStringKey: CodingKey, Hashable, ExpressibleByStringLiteral, Sendable {
  var stringValue: String
  init(stringValue: String) { self.stringValue = stringValue }
  init(_ stringValue: String) { self.init(stringValue: stringValue) }
  var intValue: Int?
  init?(intValue: Int) { nil }
  init(stringLiteral value: String) { self.init(value) }
}

// MARK: HTTP API Event definition

/*---------------------------------------------------v------------------------------------
 HTTP API Event (API Gateway v2)

 https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-property-function-httpapi.html
 -----------------------------------------------------------------------------------------*/

struct HttpApiProperties: SAMResourceProperties, Equatable {
  init(method: HttpVerb? = nil, path: String? = nil) {
    self.method = method
    self.path = path
  }

  let method: HttpVerb?
  let path: String?
  enum CodingKeys: String, CodingKey {
    case method = "Method"
    case path = "Path"
  }
}

// TODO: should use HTTP Types instead
public enum HttpVerb: String, Encodable, Sendable {
  case GET
  case POST
  case PUT
  case DELETE
  case OPTION
}

// MARK: SQS event definition

/*---------------------------------------------------------------------------------------
 SQS Event

 https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-property-function-sqs.html
 -----------------------------------------------------------------------------------------*/

/// Represents SQS queue properties.
/// When `queue` name  is a shorthand YAML reference to another resource, like `!GetAtt`, it splits the shorthand into proper YAML to make the parser happy
public struct SQSEventProperties: SAMResourceProperties, Equatable {
  public var reference: Reference
  public var batchSize: Int
  public var enabled: Bool

  init(
    byRef ref: String,
    batchSize: Int,
    enabled: Bool
  ) {
    // when the ref is an ARN, leave it as it, otherwise, create a queue resource and pass a reference to it
    if let arn = Arn(ref) {
      self.reference = .arn(arn)
    } else {
      let logicalName = Resource<EventSourceType>.logicalName(
        resourceType: "Queue",
        resourceName: ref
      )
      let queue = Resource<ResourceType>(
        type: .queue,
        properties: SQSResourceProperties(queueName: ref),
        name: logicalName
      )
      self.reference = .resource(queue)
    }
    self.batchSize = batchSize
    self.enabled = enabled
  }

  init(
    _ queue: Resource<ResourceType>,
    batchSize: Int,
    enabled: Bool
  ) {
    self.reference = .resource(queue)
    self.batchSize = batchSize
    self.enabled = enabled
  }

  enum CodingKeys: String, CodingKey {
    case reference = "Queue"
    case batchSize = "BatchSize"
    case enabled = "Enabled"
  }
}

// MARK: SQS queue resource definition

/*---------------------------------------------------------------------------------------
 SQS Queue Resource

 Documentation
 https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-sqs-queue.html
 -----------------------------------------------------------------------------------------*/

public struct SQSResourceProperties: SAMResourceProperties {
  public let queueName: String
  enum CodingKeys: String, CodingKey {
    case queueName = "QueueName"
  }
}

// MARK: Simple DynamoDB table resource definition

/*---------------------------------------------------------------------------------------
 Simple DynamoDB Table Resource

 Documentation
 https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-simpletable.html
 -----------------------------------------------------------------------------------------*/

public struct SimpleTableProperties: SAMResourceProperties {
  let primaryKey: PrimaryKey
  let tableName: String
  var provisionedThroughput: ProvisionedThroughput?
  struct PrimaryKey: Codable {
    let name: String
    let type: String
    public enum CodingKeys: String, CodingKey {
      case name = "Name"
      case type = "Type"
    }
  }

  struct ProvisionedThroughput: Codable {
    let readCapacityUnits: Int
    let writeCapacityUnits: Int
    enum CodingKeys: String, CodingKey {
      case readCapacityUnits = "ReadCapacityUnits"
      case writeCapacityUnits = "WriteCapacityUnits"
    }
  }

  enum CodingKeys: String, CodingKey {
    case primaryKey = "PrimaryKey"
    case tableName = "TableName"
    case provisionedThroughput = "ProvisionedThroughput"
  }
}

// MARK: Utils

public struct Arn: Encodable, Sendable {
  public let arn: String

  // Arn regex from https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-eventsourcemapping.html#cfn-lambda-eventsourcemapping-eventsourcearn
  private let arnRegex =
    #"arn:(aws[a-zA-Z0-9-]*):([a-zA-Z0-9\-]+):([a-z]{2}(-gov)?-[a-z]+-\d{1})?:(\d{12})?:(.*)"#

  public init?(_ arn: String) {
    if arn.range(of: self.arnRegex, options: .regularExpression) != nil {
      self.arn = arn
    } else {
      return nil
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.arn)
  }

  public func service() -> String? {
    var result: String?

    if #available(macOS 13, *) {
      let regex = try! Regex(arnRegex)
      if let matches = try? regex.wholeMatch(in: self.arn),
        matches.count > 3,
        let substring = matches[2].substring
      {
        result = "\(substring)"
      }
    } else {
      let split = self.arn.split(separator: ":")
      if split.count > 3 {
        result = "\(split[2])"
      }
    }

    return result
  }
}

public enum Reference: Encodable, Equatable, Sendable {
  case arn(Arn)
  case resource(Resource<ResourceType>)

  // if we have an Arn, return the Arn, otherwise pass a reference with GetAtt
  // https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-property-function-sqs.html#sam-function-sqs-queue
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .arn(let arn):
      try container.encode(arn)
    case .resource(let resource):
      var getAttIntrinsicFunction: [String: [String]] = [:]
      getAttIntrinsicFunction["Fn::GetAtt"] = [resource.name, "Arn"]
      try container.encode(getAttIntrinsicFunction)
    }
  }

  public static func == (lhs: Reference, rhs: Reference) -> Bool {
    switch lhs {
    case .arn(let lArn):
      if case .arn(let rArn) = rhs {
        return lArn.arn == rArn.arn
      } else {
        return false
      }
    case .resource(let lResource):
      if case .resource(let rResource) = lhs {
        return lResource == rResource
      } else {
        return false
      }
    }
  }
}

extension Resource {
  // Transform resourceName :
  // remove space
  // remove hyphen
  // camel case
  static func logicalName(resourceType: String, resourceName: String) -> String {
    let noSpaceName = resourceName.split(separator: " ").map(\.capitalized).joined(
      separator: "")
    let noHyphenName = noSpaceName.split(separator: "-").map(\.capitalized).joined(
      separator: "")
    return resourceType.capitalized + noHyphenName
  }
}
