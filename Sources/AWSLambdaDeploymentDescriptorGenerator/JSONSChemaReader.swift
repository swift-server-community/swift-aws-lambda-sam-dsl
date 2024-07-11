/*
 This struct represent a subset of a JSONSchema
 We focus implementation to specifically decode the SAM Template JSON Schema,
 as defined at https://github.com/aws/serverless-application-model/blob/develop/samtranslator/validator/sam_schema/schema.json

 We do not intent to create a generic JSON SChema decoder.
 */
public struct JSONSchema: Decodable, Sendable {
    public let id: String?
    public let schema: JSONSchemaDialectVersion
    public let description: String?
    public let type: JSONPrimitiveType
    public let properties: [String: JSONUnionType]?
    public let additionalProperties: Bool?
    public let required: [String]?
    public let definitions: [String: JSONUnionType]?

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case schema = "$schema"
        case definitions = "$defs"
        case description
        case type
        case properties
        case additionalProperties
        case required
    }

    enum CodingKeys_draft4: String, CodingKey {
        case definitions
    }

    // implement a custom init(from:) method to support different schema version
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.schema = try container.decode(JSONSchemaDialectVersion.self, forKey: .schema)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.type = try container.decode(JSONPrimitiveType.self, forKey: .type)
        self.properties = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .properties)
        self.additionalProperties = try container.decodeIfPresent(Bool.self, forKey: .additionalProperties)
        self.required = try container.decodeIfPresent([String].self, forKey: .required)

        // support multiple version of the "definition" key, depending on JSON Schema version
        // introduced by version 2019-09
        // https://json-schema.org/draft/2019-09/release-notes#semi-incompatible-changes
        switch self.schema {
        case .v2019_09, .v2020_12:
            self.definitions = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .definitions)
        case .draft4:
            let container = try decoder.container(keyedBy: CodingKeys_draft4.self)
            self.definitions = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .definitions)
        }
    }
}

// This represents the multiple versions of a JSON Schema
// https://json-schema.org/specification-links
public enum JSONSchemaDialectVersion: String, Equatable, Decodable, Sendable {
    // the versions we support
    case draft4 = "http://json-schema.org/draft-04/schema#"
    case v2019_09 = "https://json-schema.org/draft/2019-09/schema"
    case v2020_12 = "https://json-schema.org/draft/2020-12/schema"

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let schemaString = try container.decode(String.self)

        if schemaString.contains("2020-12") {
            self = .v2020_12
        } else if schemaString.contains("2019-09") {
            self = .v2019_09
        } else if schemaString.contains("draft-04") {
            self = .draft4
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unspported schema version: \(schemaString)"
                ))
        }
    }
}

// A JSON primitive type
// https://json-schema.org/understanding-json-schema/reference/type
public enum JSONPrimitiveType: Decodable, Equatable, Sendable {
    case string
    case object
    case boolean
    case array
    case integer
    case number
    case null

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        if value == "string" {
            self = .string
        } else if value == "object" {
            self = .object
        } else if value == "boolean" {
            self = .boolean
        } else if value == "object" {
            self = .object
        } else if value == "array" {
            self = .array
        } else if value == "integer" {
            self = .integer
        } else if value == "number" {
            self = .number
        } else {
            throw DecodingError.typeMismatch(JSONPrimitiveType.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unknown value (\(value)) for type property. Please make sure the schema refers to https://json-schema.org/understanding-json-schema/reference/type", underlyingError: nil))
        }
    }
}

// a JSON Union Type
public enum JSONUnionType: Decodable, Sendable {
    case anyOf([JSONType])
    case allOf([JSONUnionType])
    case type(JSONType)

    enum CodingKeys: String, CodingKey {
        case anyOf
        case allOf
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var allKeys = ArraySlice(container.allKeys)
        if let onlyKey = allKeys.popFirst(), allKeys.isEmpty {
            // there is an anyOf or allOf key
            switch onlyKey {
            case .allOf:
                let value = try container.decode(Array<JSONUnionType>.self, forKey: .allOf)
                self = .allOf(value)
            case .anyOf:
                let value = try container.decode(Array<JSONType>.self, forKey: .anyOf)
                self = .anyOf(value)
            }
        } else {
            // there is no anyOf or allOf key, the entry is a JSONType
            let container = try decoder.singleValueContainer()
            let value = try container.decode(JSONType.self)
            self = .type(value)
        }
    }

    // convenience function to extract a JSONType from this enum
    public func jsonType() -> JSONType {
        guard case .type(let jsonType) = self else {
            fatalError("not a JSONType")
        }

        return jsonType
    }

    public func any() -> [JSONType]? {
        guard case .anyOf(let anyOf) = self else {
            fatalError("not an anyOf")
        }

        return anyOf
    }

    public func all() -> [JSONUnionType]? {
        guard case .allOf(let allOf) = self else {
            fatalError("not an allOf")
        }

        return allOf
    }
    
    public func hasAnyOf() -> Bool {
           if case .anyOf = self {
               return true
           }
           return false
       }
    
}

// a JSON type
public struct JSONType: Decodable, Sendable {
    public let type: [JSONPrimitiveType]?
    public let reference: String?
    public let required: [String]?
    public let description: String?
    public let additionalProperties: Bool?
    public let enumeration: [String]? //TODO: should be JSONPrimitiveType to match all schema types

    public let subType: SubTypeSchema?

    // Nested enums for specific schema types
    public indirect enum SubTypeSchema: Sendable {
        case string(StringSchema)
        case object(ObjectSchema)
        case array(ArraySchema)
        case number(NumberSchema)
        case boolean
        case null
    }

    // for Object
    // https://json-schema.org/understanding-json-schema/reference/object
    public struct ObjectSchema: Decodable, Sendable {
        enum CodingKeys: String, CodingKey {
            case properties
            case patternProperties
            case minProperties
            case maxProperties
        }

        public let properties: [String: JSONUnionType]?
        public let patternProperties: [String: JSONUnionType]?
        public let minProperties: Int?
        public let maxProperties: Int?

        // Validate required within string array if present
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.properties = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .properties)
            self.patternProperties = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .patternProperties)
            self.minProperties = try container.decodeIfPresent(Int.self, forKey: .minProperties)
            self.maxProperties = try container.decodeIfPresent(Int.self, forKey: .maxProperties)
        }
    }

    // for String
    // https://json-schema.org/understanding-json-schema/reference/string
    public struct StringSchema: Decodable, Sendable {
        public let pattern: String?
        public let minLength: Int?
        public let maxLength: Int?

        // not used in SAM Schema
//        let format: String

        enum CodingKeys: String, CodingKey {
            case pattern
            case minLength
            case maxLength
            case enumeration = "enum"
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
            self.minLength = try container.decodeIfPresent(Int.self, forKey: .minLength)
            self.maxLength = try container.decodeIfPresent(Int.self, forKey: .maxLength)
        }
    }

    // for Array type
    // https://json-schema.org/understanding-json-schema/reference/array
    public struct ArraySchema: Decodable, Sendable {
        public let items: JSONType?
        public let minItems: Int?

        enum CodingKeys: String, CodingKey {
            case items
            case minItems
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.items = try container.decodeIfPresent(JSONType.self, forKey: .items)
            self.minItems = try container.decodeIfPresent(Int.self, forKey: .minItems)
        }

        // let prefixItems
        // let unevaluatedItems
        // let contains
        // let minContains
        // let maxContains
        // let maxItems
        // let uniqueItems
    }

    // for Number
    // https://json-schema.org/understanding-json-schema/reference/numeric
    public struct NumberSchema: Decodable, Sendable {
        public let multipleOf: Double?
        public let minimum: Double?
        public let exclusiveMinimum: Bool?
        public let maximum: Double?
        public let exclusiveMaximum: Bool?

        enum CodingKeys: String, CodingKey {
            case multipleOf
            case minimum
            case exclusiveMinimum
            case maximum
            case exclusiveMaximum
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.multipleOf = try container.decodeIfPresent(Double.self, forKey: .multipleOf)
            self.minimum = try container.decodeIfPresent(Double.self, forKey: .minimum)
            self.exclusiveMinimum = try container.decodeIfPresent(Bool.self, forKey: .exclusiveMinimum)
            self.maximum = try container.decodeIfPresent(Double.self, forKey: .maximum)
            self.exclusiveMaximum = try container.decodeIfPresent(Bool.self, forKey: .exclusiveMaximum)
        }
    }

    enum CodingKeys: String, CodingKey {
        case type
        case reference = "$ref"
        case enumeration = "enum"
        case required
        case description
        case additionalProperties
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // check if this is a single value or an array
        if let primitiveType = try? container.decodeIfPresent(JSONPrimitiveType.self, forKey: .type) {
            // and store it as an array of one element
            self.type = [primitiveType]
        } else {
            // if it doesn't work, try to decode an array
            let arrayOfPrimitiveType = try? container.decodeIfPresent([JSONPrimitiveType].self, forKey: .type)

            // if it doesn't work, type is nil
            self.type = arrayOfPrimitiveType
        }

        // if there is only one type, check the subtype
        if let type = self.type, type.count == 1 {
            switch type[0] {
            case .string:
                self.subType = try .string(StringSchema(from: decoder))
            case .object:
                self.subType = try .object(ObjectSchema(from: decoder))
            case .array:
                self.subType = try .array(ArraySchema(from: decoder))
            case .number:
                self.subType = try .number(NumberSchema(from: decoder))
            case .boolean:
                self.subType = .boolean
            case .integer:
                self.subType = try .number(NumberSchema(from: decoder))
            case .null:
                self.subType = .null
            }
        } else {
            self.subType = nil
        }

        self.enumeration = try container.decodeIfPresent([String].self, forKey: .enumeration)
        self.required = try container.decodeIfPresent([String].self, forKey: .required)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.additionalProperties = try container.decodeIfPresent(Bool.self, forKey: .additionalProperties)
        self.reference = try container.decodeIfPresent(String.self, forKey: .reference)
    }

    // MARK: accessor methods to easily access associated value of TypeSchema

    // question, instead of return nil, should we raise a fatalerror() ?
    // TODO: we should have one method for each TypeSchema

    public func object() -> ObjectSchema? {
        if case .object(let schema) = self.subType {
            return schema
        }
        return nil
    }

    public func object(for property: String) -> JSONUnionType? {
        if case .object(let schema) = self.subType {
            return schema.properties?[property]
        }
        return nil
    }

    public func stringSchema() -> StringSchema? {
        if case .string(let schema) = self.subType {
            return schema
        }
        return nil
    }

    public func arraySchema() -> ArraySchema? {
        if case .array(let schema) = self.subType {
            return schema
        }
        return nil
    }

    public func items() -> JSONType? {
        if case .array(let schema) = self.subType {
            return schema.items
        }
        return nil
    }

    public func enumValues() -> [String]? {
        return self.enumeration
    }
    
    public func hasEnum() -> Bool {
        if let enumValues = self.enumValues(), !enumValues.isEmpty {
            return true
        }
        return false
    }
    
    public func hasRequired() -> Bool {
          if let required = self.required, !required.isEmpty {
              return true
          }
          return false
      }
}
