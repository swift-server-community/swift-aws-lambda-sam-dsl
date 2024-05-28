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

// This is based on Foundation's TestJSONEncoder
// https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests/TestJSONEncoder.swift

import XCTest

@testable import AWSLambdaDeploymentDescriptor

struct TopLevelObjectWrapper<T: Codable & Equatable>: Codable, Equatable {
    var value: T

    static func == (lhs: TopLevelObjectWrapper, rhs: TopLevelObjectWrapper) -> Bool {
        lhs.value == rhs.value
    }

    init(_ value: T) {
        self.value = value
    }
}

class TestYAMLEncoder: XCTestCase {
    // MARK: - Encoding Top-Level fragments

    func test_encodingTopLevelFragments() {
        func _testFragment<T: Codable & Equatable>(value: T, fragment: String) {
            let data: Data
            let payload: String

            do {
                data = try YAMLEncoder().encode(value)
                payload = try XCTUnwrap(String(decoding: data, as: UTF8.self))
                XCTAssertEqual(fragment, payload)
            } catch {
                XCTFail("Failed to encode \(T.self) to YAML: \(error)")
                return
            }
        }

        _testFragment(value: 2, fragment: "2")
        _testFragment(value: false, fragment: "false")
        _testFragment(value: true, fragment: "true")
        _testFragment(value: Float(1), fragment: "1")
        _testFragment(value: Double(2), fragment: "2")
        _testFragment(
            value: Decimal(Double(Float.leastNormalMagnitude)),
            fragment: "0.000000000000000000000000000000000000011754943508222875648"
        )
        _testFragment(value: "test", fragment: "test")
        let v: Int? = nil
        _testFragment(value: v, fragment: "null")
    }

    // MARK: - Encoding Top-Level Empty Types

    func test_encodingTopLevelEmptyStruct() {
        let empty = EmptyStruct()
        self._testRoundTrip(of: empty, expectedYAML: self._yamlEmptyDictionary)
    }

    func test_encodingTopLevelEmptyClass() {
        let empty = EmptyClass()
        self._testRoundTrip(of: empty, expectedYAML: self._yamlEmptyDictionary)
    }

    // MARK: - Encoding Top-Level Single-Value Types

    func test_encodingTopLevelSingleValueEnum() {
        self._testRoundTrip(of: Switch.off)
        self._testRoundTrip(of: Switch.on)

        self._testRoundTrip(of: TopLevelArrayWrapper(Switch.off))
        self._testRoundTrip(of: TopLevelArrayWrapper(Switch.on))
    }

    func test_encodingTopLevelSingleValueStruct() {
        self._testRoundTrip(of: Timestamp(3_141_592_653))
        self._testRoundTrip(of: TopLevelArrayWrapper(Timestamp(3_141_592_653)))
    }

    func test_encodingTopLevelSingleValueClass() {
        self._testRoundTrip(of: Counter())
        self._testRoundTrip(of: TopLevelArrayWrapper(Counter()))
    }

    // MARK: - Encoding Top-Level Structured Types

    func test_encodingTopLevelStructuredStruct() {
        // Address is a struct type with multiple fields.
        let address = Address.testValue
        self._testRoundTrip(of: address)
    }

    func test_encodingTopLevelStructuredClass() {
        // Person is a class with multiple fields.
        let expectedYAML = ["name: Johnny Appleseed", "email: appleseed@apple.com"]
        let person = Person.testValue
        self._testRoundTrip(of: person, expectedYAML: expectedYAML)
    }

    func test_encodingTopLevelStructuredSingleStruct() {
        // Numbers is a struct which encodes as an array through a single value container.
        let numbers = Numbers.testValue
        self._testRoundTrip(of: numbers)
    }

    func test_encodingTopLevelStructuredSingleClass() {
        // Mapping is a class which encodes as a dictionary through a single value container.
        let mapping = Mapping.testValue
        self._testRoundTrip(of: mapping)
    }

    func test_encodingTopLevelDeepStructuredType() {
        // Company is a type with fields which are Codable themselves.
        let company = Company.testValue
        self._testRoundTrip(of: company)
    }

    // MARK: - Output Formatting Tests

    func test_encodingOutputFormattingDefault() {
        let expectedYAML = ["name: Johnny Appleseed", "email: appleseed@apple.com"]
        let person = Person.testValue
        self._testRoundTrip(of: person, expectedYAML: expectedYAML)
    }

    func test_encodingOutputFormattingPrettyPrinted() throws {
        let expectedYAML = ["name: Johnny Appleseed", "email: appleseed@apple.com"]
        let person = Person.testValue
        self._testRoundTrip(of: person, expectedYAML: expectedYAML)

        let encoder = YAMLEncoder()
        encoder.outputFormatting = [.sortedKeys]

        let emptyArray: [Int] = []
        let arrayOutput = try encoder.encode(emptyArray)
        XCTAssertEqual(String(decoding: arrayOutput, as: UTF8.self), "")

        let emptyDictionary: [String: Int] = [:]
        let dictionaryOutput = try encoder.encode(emptyDictionary)
        XCTAssertEqual(String(decoding: dictionaryOutput, as: UTF8.self), "")

        struct DataType: Encodable {
            let array = [1, 2, 3]
            let dictionary: [String: Int] = [:]
            let emptyAray: [Int] = []
            let secondArray: [Int] = [4, 5, 6]
            let secondDictionary: [String: Int] = ["one": 1, "two": 2, "three": 3]
            let singleElement: [Int] = [1]
            let subArray: [String: [Int]] = ["array": []]
            let subDictionary: [String: [String: Int]] = ["dictionary": [:]]
        }

        let dataOutput = try encoder.encode([DataType(), DataType()])
        XCTAssertEqual(
            String(decoding: dataOutput, as: UTF8.self),
            """

            -
            array:
               - 1
               - 2
               - 3
            dictionary:
            emptyAray:
            secondArray:
               - 4
               - 5
               - 6
            secondDictionary:
            one: 1
            three: 3
            two: 2
            singleElement:
               - 1
            subArray:
            array:
            subDictionary:
            dictionary:
            -
            array:
               - 1
               - 2
               - 3
            dictionary:
            emptyAray:
            secondArray:
               - 4
               - 5
               - 6
            secondDictionary:
            one: 1
            three: 3
            two: 2
            singleElement:
               - 1
            subArray:
            array:
            subDictionary:
            dictionary:
            """
        )
    }

    func test_encodingOutputFormattingSortedKeys() {
        let expectedYAML = ["name: Johnny Appleseed", "email: appleseed@apple.com"]
        let person = Person.testValue
        self._testRoundTrip(of: person, expectedYAML: expectedYAML)
    }

    func test_encodingOutputFormattingPrettyPrintedSortedKeys() {
        let expectedYAML = ["name: Johnny Appleseed", "email: appleseed@apple.com"]
        let person = Person.testValue
        self._testRoundTrip(of: person, expectedYAML: expectedYAML)
    }

    // MARK: - Date Strategy Tests

    func test_encodingDate() {
        // We can't encode a top-level Date, so it'll be wrapped in an array.
        self._testRoundTrip(of: TopLevelArrayWrapper(Date()))
    }

    func test_encodingDateSecondsSince1970() {
        let seconds = 1000.0
        let expectedYAML = ["1000"]

        let d = Date(timeIntervalSince1970: seconds)
        self._testRoundTrip(
            of: d,
            expectedYAML: expectedYAML,
            dateEncodingStrategy: .secondsSince1970
        )
    }

    func test_encodingDateMillisecondsSince1970() {
        let seconds = 1000.0
        let expectedYAML = ["1000000"]

        self._testRoundTrip(
            of: Date(timeIntervalSince1970: seconds),
            expectedYAML: expectedYAML,
            dateEncodingStrategy: .millisecondsSince1970
        )
    }

    func test_encodingDateISO8601() {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime

        let timestamp = Date(timeIntervalSince1970: 1000)
        let expectedYAML = ["\(formatter.string(from: timestamp))"]

        // We can't encode a top-level Date, so it'll be wrapped in an array.
        self._testRoundTrip(
            of: TopLevelArrayWrapper(timestamp),
            expectedYAML: expectedYAML,
            dateEncodingStrategy: .iso8601
        )
    }

    func test_encodingDateFormatted() {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full

        let timestamp = Date(timeIntervalSince1970: 1000)
        let expectedYAML = ["\(formatter.string(from: timestamp))"]

        // We can't encode a top-level Date, so it'll be wrapped in an array.
        self._testRoundTrip(
            of: TopLevelArrayWrapper(timestamp),
            expectedYAML: expectedYAML,
            dateEncodingStrategy: .formatted(formatter)
        )
    }

    func test_encodingDateCustom() {
        let timestamp = Date()

        // We'll encode a number instead of a date.
        let encode = { (_: Date, _ encoder: Encoder) throws in
            var container = encoder.singleValueContainer()
            try container.encode(42)
        }
        // let decode = { (_: Decoder) throws -> Date in return timestamp }

        // We can't encode a top-level Date, so it'll be wrapped in an array.
        let expectedYAML = ["42"]
        self._testRoundTrip(
            of: TopLevelArrayWrapper(timestamp),
            expectedYAML: expectedYAML,
            dateEncodingStrategy: .custom(encode)
        )
    }

    func test_encodingDateCustomEmpty() {
        let timestamp = Date()

        // Encoding nothing should encode an empty keyed container ({}).
        let encode = { (_: Date, _: Encoder) throws in }
        // let decode = { (_: Decoder) throws -> Date in return timestamp }

        // We can't encode a top-level Date, so it'll be wrapped in an array.
        let expectedYAML = [""]
        self._testRoundTrip(
            of: TopLevelArrayWrapper(timestamp),
            expectedYAML: expectedYAML,
            dateEncodingStrategy: .custom(encode)
        )
    }

    // MARK: - Data Strategy Tests

    func test_encodingBase64Data() {
        let data = Data([0xDE, 0xAD, 0xBE, 0xEF])

        // We can't encode a top-level Data, so it'll be wrapped in an array.
        let expectedYAML = ["3q2+7w=="]
        self._testRoundTrip(of: TopLevelArrayWrapper(data), expectedYAML: expectedYAML)
    }

    func test_encodingCustomData() {
        // We'll encode a number instead of data.
        let encode = { (_: Data, _ encoder: Encoder) throws in
            var container = encoder.singleValueContainer()
            try container.encode(42)
        }
        // let decode = { (_: Decoder) throws -> Data in return Data() }

        // We can't encode a top-level Data, so it'll be wrapped in an array.
        let expectedYAML = ["42"]
        self._testRoundTrip(
            of: TopLevelArrayWrapper(Data()),
            expectedYAML: expectedYAML,
            dataEncodingStrategy: .custom(encode)
        )
    }

    func test_encodingCustomDataEmpty() {
        // Encoding nothing should encode an empty keyed container ({}).
        let encode = { (_: Data, _: Encoder) throws in }
        // let decode = { (_: Decoder) throws -> Data in return Data() }

        // We can't encode a top-level Data, so it'll be wrapped in an array.
        let expectedYAML = [""]
        self._testRoundTrip(
            of: TopLevelArrayWrapper(Data()),
            expectedYAML: expectedYAML,
            dataEncodingStrategy: .custom(encode)
        )
    }

    // MARK: - Non-Conforming Floating Point Strategy Tests

    func test_encodingNonConformingFloats() {
        self._testEncodeFailure(of: TopLevelArrayWrapper(Float.infinity))
        self._testEncodeFailure(of: TopLevelArrayWrapper(-Float.infinity))
        self._testEncodeFailure(of: TopLevelArrayWrapper(Float.nan))

        self._testEncodeFailure(of: TopLevelArrayWrapper(Double.infinity))
        self._testEncodeFailure(of: TopLevelArrayWrapper(-Double.infinity))
        self._testEncodeFailure(of: TopLevelArrayWrapper(Double.nan))
    }

    func test_encodingNonConformingFloatStrings() {
        let encodingStrategy: YAMLEncoder.NonConformingFloatEncodingStrategy = .convertToString(
            positiveInfinity: "INF", negativeInfinity: "-INF", nan: "NaN"
        )
        // let decodingStrategy: YAMLDecoder.NonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "INF", negativeInfinity: "-INF", nan: "NaN")

        self._testRoundTrip(
            of: TopLevelArrayWrapper(Float.infinity),
            expectedYAML: ["INF"],
            nonConformingFloatEncodingStrategy: encodingStrategy
        )
        self._testRoundTrip(
            of: TopLevelArrayWrapper(-Float.infinity),
            expectedYAML: ["-INF"],
            nonConformingFloatEncodingStrategy: encodingStrategy
        )

        // Since Float.nan != Float.nan, we have to use a placeholder that'll encode NaN but actually round-trip.
        self._testRoundTrip(
            of: TopLevelArrayWrapper(FloatNaNPlaceholder()),
            expectedYAML: ["NaN"],
            nonConformingFloatEncodingStrategy: encodingStrategy
        )

        self._testRoundTrip(
            of: TopLevelArrayWrapper(Double.infinity),
            expectedYAML: ["INF"],
            nonConformingFloatEncodingStrategy: encodingStrategy
        )
        self._testRoundTrip(
            of: TopLevelArrayWrapper(-Double.infinity),
            expectedYAML: ["-INF"],
            nonConformingFloatEncodingStrategy: encodingStrategy
        )

        // Since Double.nan != Double.nan, we have to use a placeholder that'll encode NaN but actually round-trip.
        self._testRoundTrip(
            of: TopLevelArrayWrapper(DoubleNaNPlaceholder()),
            expectedYAML: ["NaN"],
            nonConformingFloatEncodingStrategy: encodingStrategy
        )
    }

    // MARK: - Encoder Features

    func test_nestedContainerCodingPaths() {
        let encoder = YAMLEncoder()
        do {
            _ = try encoder.encode(NestedContainersTestType())
        } catch {
            XCTFail("Caught error during encoding nested container types: \(error)")
        }
    }

    func test_superEncoderCodingPaths() {
        let encoder = YAMLEncoder()
        do {
            _ = try encoder.encode(NestedContainersTestType(testSuperEncoder: true))
        } catch {
            XCTFail("Caught error during encoding nested container types: \(error)")
        }
    }

    func test_notFoundSuperDecoder() {
        struct NotFoundSuperDecoderTestType: Decodable {
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                _ = try container.superDecoder(forKey: .superDecoder)
            }

            private enum CodingKeys: String, CodingKey {
                case superDecoder = "super"
            }
        }
        // let decoder = YAMLDecoder()
        // do {
        //     let _ = try decoder.decode(NotFoundSuperDecoderTestType.self, from: Data(#"{}"#.utf8))
        // } catch {
        //     XCTFail("Caught error during decoding empty super decoder: \(error)")
        // }
    }

    // MARK: - Test encoding and decoding of built-in Codable types

    func test_codingOfBool() {
        self.test_codingOf(value: Bool(true), toAndFrom: "true")
        self.test_codingOf(value: Bool(false), toAndFrom: "false")

        // do {
        //     _ = try YAMLDecoder().decode([Bool].self, from: "[1]".data(using: .utf8)!)
        //     XCTFail("Coercing non-boolean numbers into Bools was expected to fail")
        // } catch { }

        // Check that a Bool false or true isn't converted to 0 or 1
        //        struct Foo: Decodable {
        //            var intValue: Int?
        //            var int8Value: Int8?
        //            var int16Value: Int16?
        //            var int32Value: Int32?
        //            var int64Value: Int64?
        //            var uintValue: UInt?
        //            var uint8Value: UInt8?
        //            var uint16Value: UInt16?
        //            var uint32Value: UInt32?
        //            var uint64Value: UInt64?
        //            var floatValue: Float?
        //            var doubleValue: Double?
        //            var decimalValue: Decimal?
        //            let boolValue: Bool
        //        }

        // func testValue(_ valueName: String) {
        //     do {
        //         let jsonData = "{ \"\(valueName)\": false }".data(using: .utf8)!
        //         _ = try YAMLDecoder().decode(Foo.self, from: jsonData)
        //         XCTFail("Decoded 'false' as non Bool for \(valueName)")
        //     } catch {}
        //     do {
        //         let jsonData = "{ \"\(valueName)\": true }".data(using: .utf8)!
        //         _ = try YAMLDecoder().decode(Foo.self, from: jsonData)
        //         XCTFail("Decoded 'true' as non Bool for \(valueName)")
        //     } catch {}
        // }

        // testValue("intValue")
        // testValue("int8Value")
        // testValue("int16Value")
        // testValue("int32Value")
        // testValue("int64Value")
        // testValue("uintValue")
        // testValue("uint8Value")
        // testValue("uint16Value")
        // testValue("uint32Value")
        // testValue("uint64Value")
        // testValue("floatValue")
        // testValue("doubleValue")
        // testValue("decimalValue")
        // let falseJsonData = "{ \"boolValue\": false }".data(using: .utf8)!
        // if let falseFoo = try? YAMLDecoder().decode(Foo.self, from: falseJsonData) {
        //     XCTAssertFalse(falseFoo.boolValue)
        // } else {
        //     XCTFail("Could not decode 'false' as a Bool")
        // }

        // let trueJsonData = "{ \"boolValue\": true }".data(using: .utf8)!
        // if let trueFoo = try? YAMLDecoder().decode(Foo.self, from: trueJsonData) {
        //     XCTAssertTrue(trueFoo.boolValue)
        // } else {
        //     XCTFail("Could not decode 'true' as a Bool")
        // }
    }

    func test_codingOfNil() {
        let x: Int? = nil
        self.test_codingOf(value: x, toAndFrom: "null")
    }

    func test_codingOfInt8() {
        self.test_codingOf(value: Int8(-42), toAndFrom: "-42")
    }

    func test_codingOfUInt8() {
        self.test_codingOf(value: UInt8(42), toAndFrom: "42")
    }

    func test_codingOfInt16() {
        self.test_codingOf(value: Int16(-30042), toAndFrom: "-30042")
    }

    func test_codingOfUInt16() {
        self.test_codingOf(value: UInt16(30042), toAndFrom: "30042")
    }

    func test_codingOfInt32() {
        self.test_codingOf(value: Int32(-2_000_000_042), toAndFrom: "-2000000042")
    }

    func test_codingOfUInt32() {
        self.test_codingOf(value: UInt32(2_000_000_042), toAndFrom: "2000000042")
    }

    func test_codingOfInt64() {
        #if !arch(arm)
        self.test_codingOf(value: Int64(-9_000_000_000_000_000_042), toAndFrom: "-9000000000000000042")
        #endif
    }

    func test_codingOfUInt64() {
        #if !arch(arm)
        self.test_codingOf(value: UInt64(9_000_000_000_000_000_042), toAndFrom: "9000000000000000042")
        #endif
    }

    func test_codingOfInt() {
        let intSize = MemoryLayout<Int>.size
        switch intSize {
        case 4: // 32-bit
            self.test_codingOf(value: Int(-2_000_000_042), toAndFrom: "-2000000042")
        case 8: // 64-bit
            #if arch(arm)
            break
            #else
            self.test_codingOf(value: Int(-9_000_000_000_000_000_042), toAndFrom: "-9000000000000000042")
            #endif
        default:
            XCTFail("Unexpected UInt size: \(intSize)")
        }
    }

    func test_codingOfUInt() {
        let uintSize = MemoryLayout<UInt>.size
        switch uintSize {
        case 4: // 32-bit
            self.test_codingOf(value: UInt(2_000_000_042), toAndFrom: "2000000042")
        case 8: // 64-bit
            #if arch(arm)
            break
            #else
            self.test_codingOf(value: UInt(9_000_000_000_000_000_042), toAndFrom: "9000000000000000042")
            #endif
        default:
            XCTFail("Unexpected UInt size: \(uintSize)")
        }
    }

    func test_codingOfFloat() {
        self.test_codingOf(value: Float(1.5), toAndFrom: "1.5")

        // Check value too large fails to decode.
        // XCTAssertThrowsError(try YAMLDecoder().decode(Float.self, from: "1e100".data(using: .utf8)!))
    }

    func test_codingOfDouble() {
        self.test_codingOf(value: Double(1.5), toAndFrom: "1.5")

        // Check value too large fails to decode.
        // XCTAssertThrowsError(try YAMLDecoder().decode(Double.self, from: "100e323".data(using: .utf8)!))
    }

    func test_codingOfDecimal() {
        self.test_codingOf(value: Decimal.pi, toAndFrom: "3.14159265358979323846264338327950288419")

        // Check value too large fails to decode.
        // XCTAssertThrowsError(try YAMLDecoder().decode(Decimal.self, from: "100e200".data(using: .utf8)!))
    }

    func test_codingOfString() {
        self.test_codingOf(value: "Hello, world!", toAndFrom: "Hello, world!")
    }

    func test_codingOfURL() {
        self.test_codingOf(value: URL(string: "https://swift.org")!, toAndFrom: "https://swift.org")
    }

    // UInt and Int
    func test_codingOfUIntMinMax() {
        struct MyValue: Codable, Equatable {
            var int64Min = Int64.min
            var int64Max = Int64.max
            var uint64Min = UInt64.min
            var uint64Max = UInt64.max
        }

        let myValue = MyValue()
        self._testRoundTrip(
            of: myValue,
            expectedYAML: [
                "uint64Min: 0",
                "uint64Max: 18446744073709551615",
                "int64Min: -9223372036854775808",
                "int64Max: 9223372036854775807",
            ]
        )
    }

    func test_CamelCaseEncoding() throws {
        struct MyTestData: Codable, Equatable {
            let thisIsAString: String
            let thisIsABool: Bool
            let thisIsAnInt: Int
            let thisIsAnInt8: Int8
            let thisIsAnInt16: Int16
            let thisIsAnInt32: Int32
            let thisIsAnInt64: Int64
            let thisIsAUint: UInt
            let thisIsAUint8: UInt8
            let thisIsAUint16: UInt16
            let thisIsAUint32: UInt32
            let thisIsAUint64: UInt64
            let thisIsAFloat: Float
            let thisIsADouble: Double
            let thisIsADate: Date
            let thisIsAnArray: [Int]
            let thisIsADictionary: [String: Bool]
        }

        let data = MyTestData(
            thisIsAString: "Hello",
            thisIsABool: true,
            thisIsAnInt: 1,
            thisIsAnInt8: 2,
            thisIsAnInt16: 3,
            thisIsAnInt32: 4,
            thisIsAnInt64: 5,
            thisIsAUint: 6,
            thisIsAUint8: 7,
            thisIsAUint16: 8,
            thisIsAUint32: 9,
            thisIsAUint64: 10,
            thisIsAFloat: 11,
            thisIsADouble: 12,
            thisIsADate: Date(timeIntervalSince1970: 0),
            thisIsAnArray: [1, 2, 3],
            thisIsADictionary: ["trueValue": true, "falseValue": false]
        )

        let encoder = YAMLEncoder()
        encoder.keyEncodingStrategy = .camelCase
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(data)
        let yaml = String(decoding: encodedData, as: UTF8.self)

        XCTAssertTrue(yaml.contains("ThisIsABool: true"))
        XCTAssertTrue(yaml.contains("ThisIsAnInt: 1"))
        XCTAssertTrue(yaml.contains("ThisIsAnInt8: 2"))
        XCTAssertTrue(yaml.contains("ThisIsAnInt16: 3"))
        XCTAssertTrue(yaml.contains("ThisIsAnInt32: 4"))
        XCTAssertTrue(yaml.contains("ThisIsAnInt64: 5"))
        XCTAssertTrue(yaml.contains("ThisIsAUint: 6"))
        XCTAssertTrue(yaml.contains("ThisIsAUint8: 7"))
        XCTAssertTrue(yaml.contains("ThisIsAUint16: 8"))
        XCTAssertTrue(yaml.contains("ThisIsAUint32: 9"))
        XCTAssertTrue(yaml.contains("ThisIsAUint64: 10"))
        XCTAssertTrue(yaml.contains("ThisIsAFloat: 11"))
        XCTAssertTrue(yaml.contains("ThisIsADouble: 12"))
        XCTAssertTrue(yaml.contains("ThisIsADate: 1970-01-01T00:00:00Z"))
        XCTAssertTrue(yaml.contains("ThisIsAnArray:"))
        XCTAssertTrue(yaml.contains("- 1"))
        XCTAssertTrue(yaml.contains("- 2"))
        XCTAssertTrue(yaml.contains("- 3"))
    }

    func test_DictionaryCamelCaseEncoding() throws {
        let camelCaseDictionary = ["camelCaseKey": ["nestedDictionary": 1]]

        let encoder = YAMLEncoder()
        encoder.keyEncodingStrategy = .camelCase
        let encodedData = try encoder.encode(camelCaseDictionary)

        let yaml = String(decoding: encodedData, as: UTF8.self)

        print(yaml)
        XCTAssertTrue(yaml.contains("CamelCaseKey:"))
        XCTAssertTrue(yaml.contains("   NestedDictionary: 1"))
    }

    func test_OutputFormattingValues() {
        XCTAssertEqual(YAMLEncoder.OutputFormatting.withoutEscapingSlashes.rawValue, 8)
    }

    func test_SR17581_codingEmptyDictionaryWithNonstringKeyDoesRoundtrip() throws {
        struct Something: Codable {
            struct Key: Codable, Hashable {
                var x: String
            }

            var dict: [Key: String]

            enum CodingKeys: String, CodingKey {
                case dict
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.dict = try container.decode([Key: String].self, forKey: .dict)
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.dict, forKey: .dict)
            }

            init(dict: [Key: String]) {
                self.dict = dict
            }
        }

        // let toEncode = Something(dict: [:])
        // let data = try YAMLEncoder().encode(toEncode)
        // let result = try YAMLDecoder().decode(Something.self, from: data)
        // XCTAssertEqual(result.dict.count, 0)
    }

    // MARK: - Helper Functions

    private var _yamlEmptyDictionary: [String] {
        [""]
    }

    private func _testEncodeFailure<T: Encodable>(of value: T) {
        do {
            _ = try YAMLEncoder().encode(value)
            XCTFail("Encode of top-level \(T.self) was expected to fail.")
        } catch {}
    }

    private func _testRoundTrip<T>(
        of value: T,
        expectedYAML yaml: [String] = [],
        dateEncodingStrategy: YAMLEncoder.DateEncodingStrategy = .deferredToDate,
        dataEncodingStrategy: YAMLEncoder.DataEncodingStrategy = .base64,
        nonConformingFloatEncodingStrategy: YAMLEncoder.NonConformingFloatEncodingStrategy = .throw
    ) where T: Codable, T: Equatable {
        var payload: Data! = nil
        do {
            let encoder = YAMLEncoder()
            encoder.dateEncodingStrategy = dateEncodingStrategy
            encoder.dataEncodingStrategy = dataEncodingStrategy
            encoder.nonConformingFloatEncodingStrategy = nonConformingFloatEncodingStrategy
            payload = try encoder.encode(value)
        } catch {
            XCTFail("Failed to encode \(T.self) to YAML: \(error)")
        }

        // We do not compare expectedYAML to payload directly, because they might have values like
        // {"name": "Bob", "age": 22}
        // and
        // {"age": 22, "name": "Bob"}
        // which if compared as Data would not be equal, but the contained YAML values are equal.
        // So we wrap them in a YAML type, which compares data as if it were a json.

        let payloadYAMLObject = String(decoding: payload, as: UTF8.self)
        let result = yaml.allSatisfy { payloadYAMLObject.contains($0) || $0 == "" }
        XCTAssertTrue(result, "Produced YAML not identical to expected YAML.")

        if !result {
            print("===========")
            print(payloadYAMLObject)
            print("-----------")
            print(yaml.filter { !payloadYAMLObject.contains($0) }.compactMap { $0 })
            print("===========")
        }
    }

    func test_codingOf<T: Codable & Equatable>(value: T, toAndFrom stringValue: String) {
        self._testRoundTrip(
            of: TopLevelObjectWrapper(value),
            expectedYAML: ["value: \(stringValue)"]
        )

        self._testRoundTrip(
            of: TopLevelArrayWrapper(value),
            expectedYAML: ["\(stringValue)"]
        )
    }
}

// MARK: - Helper Global Functions

func expectEqualPaths(_ lhs: [CodingKey?], _ rhs: [CodingKey?], _ prefix: String) {
    if lhs.count != rhs.count {
        XCTFail("\(prefix) [CodingKey?].count mismatch: \(lhs.count) != \(rhs.count)")
        return
    }

    for (k1, k2) in zip(lhs, rhs) {
        switch (k1, k2) {
        case (nil, nil): continue
        case (let _k1?, nil):
            XCTFail("\(prefix) CodingKey mismatch: \(type(of: _k1)) != nil")
            return
        case (nil, let _k2?):
            XCTFail("\(prefix) CodingKey mismatch: nil != \(type(of: _k2))")
            return
        default: break
        }

        let key1 = k1!
        let key2 = k2!

        switch (key1.intValue, key2.intValue) {
        case (nil, nil): break
        case (let i1?, nil):
            XCTFail("\(prefix) CodingKey.intValue mismatch: \(type(of: key1))(\(i1)) != nil")
            return
        case (nil, let i2?):
            XCTFail("\(prefix) CodingKey.intValue mismatch: nil != \(type(of: key2))(\(i2))")
            return
        case (let i1?, let i2?):
            guard i1 == i2 else {
                XCTFail(
                    "\(prefix) CodingKey.intValue mismatch: \(type(of: key1))(\(i1)) != \(type(of: key2))(\(i2))"
                )
                return
            }
        }

        XCTAssertEqual(
            key1.stringValue,
            key2.stringValue,
            "\(prefix) CodingKey.stringValue mismatch: \(type(of: key1))('\(key1.stringValue)') != \(type(of: key2))('\(key2.stringValue)')"
        )
    }
}

// MARK: - Test Types

/* FIXME: Import from %S/Inputs/Coding/SharedTypes.swift somehow. */

// MARK: - Empty Types

private struct EmptyStruct: Codable, Equatable {
    static func == (_: EmptyStruct, _: EmptyStruct) -> Bool {
        true
    }
}

private class EmptyClass: Codable, Equatable {
    static func == (_: EmptyClass, _: EmptyClass) -> Bool {
        true
    }
}

// MARK: - Single-Value Types

/// A simple on-off switch type that encodes as a single Bool value.
private enum Switch: Codable {
    case off
    case on

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(Bool.self) {
        case false: self = .off
        case true: self = .on
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .off: try container.encode(false)
        case .on: try container.encode(true)
        }
    }
}

/// A simple timestamp type that encodes as a single Double value.
private struct Timestamp: Codable, Equatable {
    let value: Double

    init(_ value: Double) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(Double.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }

    static func == (_ lhs: Timestamp, _ rhs: Timestamp) -> Bool {
        lhs.value == rhs.value
    }
}

/// A simple referential counter type that encodes as a single Int value.
private final class Counter: Codable, Equatable {
    var count: Int = 0

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.count = try container.decode(Int.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.count)
    }

    static func == (_ lhs: Counter, _ rhs: Counter) -> Bool {
        lhs === rhs || lhs.count == rhs.count
    }
}

// MARK: - Structured Types

/// A simple address type that encodes as a dictionary of values.
private struct Address: Codable, Equatable {
    let street: String
    let city: String
    let state: String
    let zipCode: Int
    let country: String

    init(street: String, city: String, state: String, zipCode: Int, country: String) {
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
    }

    static func == (_ lhs: Address, _ rhs: Address) -> Bool {
        lhs.street == rhs.street && lhs.city == rhs.city && lhs.state == rhs.state
            && lhs.zipCode == rhs.zipCode && lhs.country == rhs.country
    }

    static var testValue: Address {
        Address(
            street: "1 Infinite Loop",
            city: "Cupertino",
            state: "CA",
            zipCode: 95014,
            country: "United States"
        )
    }
}

/// A simple person class that encodes as a dictionary of values.
private class Person: Codable, Equatable {
    let name: String
    let email: String

    // FIXME: This property is present only in order to test the expected result of Codable synthesis in the compiler.
    // We want to test against expected encoded output (to ensure this generates an encodeIfPresent call), but we need an output format for that.
    // Once we have a VerifyingEncoder for compiler unit tests, we should move this test there.
    let website: URL?

    init(name: String, email: String, website: URL? = nil) {
        self.name = name
        self.email = email
        self.website = website
    }

    static func == (_ lhs: Person, _ rhs: Person) -> Bool {
        lhs.name == rhs.name && lhs.email == rhs.email && lhs.website == rhs.website
    }

    static var testValue: Person {
        Person(name: "Johnny Appleseed", email: "appleseed@apple.com")
    }
}

/// A simple company struct which encodes as a dictionary of nested values.
private struct Company: Codable, Equatable {
    let address: Address
    var employees: [Person]

    init(address: Address, employees: [Person]) {
        self.address = address
        self.employees = employees
    }

    static func == (_ lhs: Company, _ rhs: Company) -> Bool {
        lhs.address == rhs.address && lhs.employees == rhs.employees
    }

    static var testValue: Company {
        Company(address: Address.testValue, employees: [Person.testValue])
    }
}

// MARK: - Helper Types

/// A key type which can take on any string or integer value.
/// This needs to mirror _YAMLKey.
private struct _TestKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }
}

/// Wraps a type T so that it can be encoded at the top level of a payload.
private struct TopLevelArrayWrapper<T>: Codable, Equatable where T: Codable, T: Equatable {
    let value: T

    init(_ value: T) {
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(self.value)
    }

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.value = try container.decode(T.self)
        assert(container.isAtEnd)
    }

    static func == (_ lhs: TopLevelArrayWrapper<T>, _ rhs: TopLevelArrayWrapper<T>) -> Bool {
        lhs.value == rhs.value
    }
}

private struct FloatNaNPlaceholder: Codable, Equatable {
    init() {}

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Float.nan)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let float = try container.decode(Float.self)
        if !float.isNaN {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath, debugDescription: "Couldn't decode NaN."
                ))
        }
    }

    static func == (_: FloatNaNPlaceholder, _: FloatNaNPlaceholder) -> Bool {
        true
    }
}

private struct DoubleNaNPlaceholder: Codable, Equatable {
    init() {}

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Double.nan)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let double = try container.decode(Double.self)
        if !double.isNaN {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath, debugDescription: "Couldn't decode NaN."
                ))
        }
    }

    static func == (_: DoubleNaNPlaceholder, _: DoubleNaNPlaceholder) -> Bool {
        true
    }
}

/// A type which encodes as an array directly through a single value container.
struct Numbers: Codable, Equatable {
    let values = [4, 8, 15, 16, 23, 42]

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedValues = try container.decode([Int].self)
        guard decodedValues == self.values else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath, debugDescription: "The Numbers are wrong!"
                ))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.values)
    }

    static func == (_ lhs: Numbers, _ rhs: Numbers) -> Bool {
        lhs.values == rhs.values
    }

    static var testValue: Numbers {
        Numbers()
    }
}

/// A type which encodes as a dictionary directly through a single value container.
private final class Mapping: Codable, Equatable {
    let values: [String: URL]

    init(values: [String: URL]) {
        self.values = values
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.values = try container.decode([String: URL].self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.values)
    }

    static func == (_ lhs: Mapping, _ rhs: Mapping) -> Bool {
        lhs === rhs || lhs.values == rhs.values
    }

    static var testValue: Mapping {
        Mapping(values: [
            "Apple": URL(string: "http://apple.com")!,
            "localhost": URL(string: "http://127.0.0.1")!,
        ])
    }
}

struct NestedContainersTestType: Encodable {
    let testSuperEncoder: Bool

    init(testSuperEncoder: Bool = false) {
        self.testSuperEncoder = testSuperEncoder
    }

    enum TopLevelCodingKeys: Int, CodingKey {
        case a
        case b
        case c
    }

    enum IntermediateCodingKeys: Int, CodingKey {
        case one
        case two
    }

    func encode(to encoder: Encoder) throws {
        if self.testSuperEncoder {
            var topLevelContainer = encoder.container(keyedBy: TopLevelCodingKeys.self)
            expectEqualPaths(encoder.codingPath, [], "Top-level Encoder's codingPath changed.")
            expectEqualPaths(
                topLevelContainer.codingPath, [],
                "New first-level keyed container has non-empty codingPath."
            )

            let superEncoder = topLevelContainer.superEncoder(forKey: .a)
            expectEqualPaths(encoder.codingPath, [], "Top-level Encoder's codingPath changed.")
            expectEqualPaths(
                topLevelContainer.codingPath, [], "First-level keyed container's codingPath changed."
            )
            expectEqualPaths(
                superEncoder.codingPath, [TopLevelCodingKeys.a],
                "New superEncoder had unexpected codingPath."
            )
            self._testNestedContainers(in: superEncoder, baseCodingPath: [TopLevelCodingKeys.a])
        } else {
            self._testNestedContainers(in: encoder, baseCodingPath: [])
        }
    }

    func _testNestedContainers(in encoder: Encoder, baseCodingPath: [CodingKey?]) {
        expectEqualPaths(encoder.codingPath, baseCodingPath, "New encoder has non-empty codingPath.")

        // codingPath should not change upon fetching a non-nested container.
        var firstLevelContainer = encoder.container(keyedBy: TopLevelCodingKeys.self)
        expectEqualPaths(encoder.codingPath, baseCodingPath, "Top-level Encoder's codingPath changed.")
        expectEqualPaths(
            firstLevelContainer.codingPath, baseCodingPath,
            "New first-level keyed container has non-empty codingPath."
        )

        // Nested Keyed Container
        do {
            // Nested container for key should have a new key pushed on.
            var secondLevelContainer = firstLevelContainer.nestedContainer(
                keyedBy: IntermediateCodingKeys.self, forKey: .a
            )
            expectEqualPaths(
                encoder.codingPath, baseCodingPath, "Top-level Encoder's codingPath changed."
            )
            expectEqualPaths(
                firstLevelContainer.codingPath, baseCodingPath,
                "First-level keyed container's codingPath changed."
            )
            expectEqualPaths(
                secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.a],
                "New second-level keyed container had unexpected codingPath."
            )

            // Inserting a keyed container should not change existing coding paths.
            let thirdLevelContainerKeyed = secondLevelContainer.nestedContainer(
                keyedBy: IntermediateCodingKeys.self, forKey: .one
            )
            expectEqualPaths(
                encoder.codingPath, baseCodingPath, "Top-level Encoder's codingPath changed."
            )
            expectEqualPaths(
                firstLevelContainer.codingPath, baseCodingPath,
                "First-level keyed container's codingPath changed."
            )
            expectEqualPaths(
                secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.a],
                "Second-level keyed container's codingPath changed."
            )
            expectEqualPaths(
                thirdLevelContainerKeyed.codingPath,
                baseCodingPath + [TopLevelCodingKeys.a, IntermediateCodingKeys.one],
                "New third-level keyed container had unexpected codingPath."
            )

            // Inserting an unkeyed container should not change existing coding paths.
            let thirdLevelContainerUnkeyed = secondLevelContainer.nestedUnkeyedContainer(forKey: .two)
            expectEqualPaths(
                encoder.codingPath, baseCodingPath + [], "Top-level Encoder's codingPath changed."
            )
            expectEqualPaths(
                firstLevelContainer.codingPath, baseCodingPath + [],
                "First-level keyed container's codingPath changed."
            )
            expectEqualPaths(
                secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.a],
                "Second-level keyed container's codingPath changed."
            )
            expectEqualPaths(
                thirdLevelContainerUnkeyed.codingPath,
                baseCodingPath + [TopLevelCodingKeys.a, IntermediateCodingKeys.two],
                "New third-level unkeyed container had unexpected codingPath."
            )
        }

        // Nested Unkeyed Container
        do {
            // Nested container for key should have a new key pushed on.
            var secondLevelContainer = firstLevelContainer.nestedUnkeyedContainer(forKey: .b)
            expectEqualPaths(
                encoder.codingPath, baseCodingPath, "Top-level Encoder's codingPath changed."
            )
            expectEqualPaths(
                firstLevelContainer.codingPath, baseCodingPath,
                "First-level keyed container's codingPath changed."
            )
            expectEqualPaths(
                secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.b],
                "New second-level keyed container had unexpected codingPath."
            )

            // Appending a keyed container should not change existing coding paths.
            let thirdLevelContainerKeyed = secondLevelContainer.nestedContainer(
                keyedBy: IntermediateCodingKeys.self)
            expectEqualPaths(
                encoder.codingPath, baseCodingPath, "Top-level Encoder's codingPath changed."
            )
            expectEqualPaths(
                firstLevelContainer.codingPath, baseCodingPath,
                "First-level keyed container's codingPath changed."
            )
            expectEqualPaths(
                secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.b],
                "Second-level unkeyed container's codingPath changed."
            )
            expectEqualPaths(
                thirdLevelContainerKeyed.codingPath,
                baseCodingPath + [TopLevelCodingKeys.b, _TestKey(index: 0)],
                "New third-level keyed container had unexpected codingPath."
            )

            // Appending an unkeyed container should not change existing coding paths.
            let thirdLevelContainerUnkeyed = secondLevelContainer.nestedUnkeyedContainer()
            expectEqualPaths(
                encoder.codingPath, baseCodingPath, "Top-level Encoder's codingPath changed."
            )
            expectEqualPaths(
                firstLevelContainer.codingPath, baseCodingPath,
                "First-level keyed container's codingPath changed."
            )
            expectEqualPaths(
                secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.b],
                "Second-level unkeyed container's codingPath changed."
            )
            expectEqualPaths(
                thirdLevelContainerUnkeyed.codingPath,
                baseCodingPath + [TopLevelCodingKeys.b, _TestKey(index: 1)],
                "New third-level unkeyed container had unexpected codingPath."
            )
        }
    }
}

// MARK: - Helpers

private struct YAML: Equatable {
    private var jsonObject: Any

    fileprivate init(data: Data) throws {
        self.jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
    }

    static func == (lhs: YAML, rhs: YAML) -> Bool {
        switch (lhs.jsonObject, rhs.jsonObject) {
        case (let lhs, let rhs) as ([AnyHashable: Any], [AnyHashable: Any]):
            return NSDictionary(dictionary: lhs) == NSDictionary(dictionary: rhs)
        case (let lhs, let rhs) as ([Any], [Any]):
            return NSArray(array: lhs) == NSArray(array: rhs)
        default:
            return false
        }
    }
}

// MARK: - Run Tests

extension TestYAMLEncoder {
    static var allTests: [(String, (TestYAMLEncoder) -> () throws -> Void)] {
        [
            ("test_encodingTopLevelFragments", test_encodingTopLevelFragments),
            ("test_encodingTopLevelEmptyStruct", test_encodingTopLevelEmptyStruct),
            ("test_encodingTopLevelEmptyClass", test_encodingTopLevelEmptyClass),
            ("test_encodingTopLevelSingleValueEnum", test_encodingTopLevelSingleValueEnum),
            ("test_encodingTopLevelSingleValueStruct", test_encodingTopLevelSingleValueStruct),
            ("test_encodingTopLevelSingleValueClass", test_encodingTopLevelSingleValueClass),
            ("test_encodingTopLevelStructuredStruct", test_encodingTopLevelStructuredStruct),
            ("test_encodingTopLevelStructuredClass", test_encodingTopLevelStructuredClass),
            ("test_encodingTopLevelStructuredSingleStruct", test_encodingTopLevelStructuredSingleStruct),
            ("test_encodingTopLevelStructuredSingleClass", test_encodingTopLevelStructuredSingleClass),
            ("test_encodingTopLevelDeepStructuredType", test_encodingTopLevelDeepStructuredType),
            ("test_encodingOutputFormattingDefault", test_encodingOutputFormattingDefault),
            ("test_encodingOutputFormattingPrettyPrinted", test_encodingOutputFormattingPrettyPrinted),
            ("test_encodingOutputFormattingSortedKeys", test_encodingOutputFormattingSortedKeys),
            (
                "test_encodingOutputFormattingPrettyPrintedSortedKeys",
                test_encodingOutputFormattingPrettyPrintedSortedKeys
            ),
            ("test_encodingDate", test_encodingDate),
            ("test_encodingDateSecondsSince1970", test_encodingDateSecondsSince1970),
            ("test_encodingDateMillisecondsSince1970", test_encodingDateMillisecondsSince1970),
            ("test_encodingDateISO8601", test_encodingDateISO8601),
            ("test_encodingDateFormatted", test_encodingDateFormatted),
            ("test_encodingDateCustom", test_encodingDateCustom),
            ("test_encodingDateCustomEmpty", test_encodingDateCustomEmpty),
            ("test_encodingBase64Data", test_encodingBase64Data),
            ("test_encodingCustomData", test_encodingCustomData),
            ("test_encodingCustomDataEmpty", test_encodingCustomDataEmpty),
            ("test_encodingNonConformingFloats", test_encodingNonConformingFloats),
            ("test_encodingNonConformingFloatStrings", test_encodingNonConformingFloatStrings),
            // ("test_encodeDecodeNumericTypesBaseline", test_encodeDecodeNumericTypesBaseline),
            ("test_nestedContainerCodingPaths", test_nestedContainerCodingPaths),
            ("test_superEncoderCodingPaths", test_superEncoderCodingPaths),
            ("test_notFoundSuperDecoder", test_notFoundSuperDecoder),
            ("test_codingOfBool", test_codingOfBool),
            ("test_codingOfNil", test_codingOfNil),
            ("test_codingOfInt8", test_codingOfInt8),
            ("test_codingOfUInt8", test_codingOfUInt8),
            ("test_codingOfInt16", test_codingOfInt16),
            ("test_codingOfUInt16", test_codingOfUInt16),
            ("test_codingOfInt32", test_codingOfInt32),
            ("test_codingOfUInt32", test_codingOfUInt32),
            ("test_codingOfInt64", test_codingOfInt64),
            ("test_codingOfUInt64", test_codingOfUInt64),
            ("test_codingOfInt", test_codingOfInt),
            ("test_codingOfUInt", test_codingOfUInt),
            ("test_codingOfFloat", test_codingOfFloat),
            ("test_codingOfDouble", test_codingOfDouble),
            ("test_codingOfDecimal", test_codingOfDecimal),
            ("test_codingOfString", test_codingOfString),
            ("test_codingOfURL", test_codingOfURL),
            ("test_codingOfUIntMinMax", test_codingOfUIntMinMax),
            ("test_snake_case_encoding", test_CamelCaseEncoding),
            ("test_dictionary_snake_case_encoding", test_DictionaryCamelCaseEncoding),
            ("test_OutputFormattingValues", test_OutputFormattingValues),
            (
                "test_SR17581_codingEmptyDictionaryWithNonstringKeyDoesRoundtrip",
                test_SR17581_codingEmptyDictionaryWithNonstringKeyDoesRoundtrip
            ),
        ]
    }
}
