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
  public static var none: SAMEnvironmentVariable { return SAMEnvironmentVariable([:]) }

  public static func variable(_ name: String, _ value: String) -> SAMEnvironmentVariable {
    return SAMEnvironmentVariable([name: value])
  }
  public static func variable(_ variables: [String: String]) -> SAMEnvironmentVariable {
    return SAMEnvironmentVariable(variables)
  }
  public static func variable(_ variables: [[String: String]]) -> SAMEnvironmentVariable {

    var mergedDictKeepCurrent: [String: String] = [:]
    variables.forEach { dict in
      // inspired by https://stackoverflow.com/a/43615143/663360
      mergedDictKeepCurrent = mergedDictKeepCurrent.merging(dict) { (current, _) in current }
    }

    return SAMEnvironmentVariable(mergedDictKeepCurrent)

  }
  public func isEmpty() -> Bool { return variables.count == 0 }

  public mutating func append(_ key: String, _ value: String) {
    variables[key] = .string(value: value)
  }
  public mutating func append(_ key: String, _ value: [String: String]) {
    variables[key] = .array(value: value)
  }
  public mutating func append(_ key: String, _ value: [String: [String]]) {
    variables[key] = .dictionary(value: value)
  }
  public mutating func append(_ key: String, _ value: Resource<ResourceType>) {
    variables[key] = .array(value: ["Ref": value.name])
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

    for key in variables.keys {
      switch variables[key] {
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

internal struct AnyStringKey: CodingKey, Hashable, ExpressibleByStringLiteral {
  var stringValue: String
  init(stringValue: String) { self.stringValue = stringValue }
  init(_ stringValue: String) { self.init(stringValue: stringValue) }
  var intValue: Int?
  init?(intValue: Int) { return nil }
  init(stringLiteral value: String) { self.init(value) }
}

