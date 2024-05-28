// MARK: - JSONSchema ..

struct JSONSchema: Decodable {
    let id: String?
    let schema: SchemaVersion
    let additionalProperties: Bool?
    let required: [String]?
    let description: String?
    let type: [JSONPrimitiveType]?
    let properties: [String: JSONUnionType]?
    let definitions: [String: JSONUnionType]?

    enum SchemaVersion: String, Decodable {
        case draft4 = "http://json-schema.org/draft-04/schema#"

        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            let value = try container.decode(String.self)
            if value == SchemaVersion.draft4.rawValue {
                self = .draft4
            } else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "➡️ Unsupported schema version: \(value). Expected \(SchemaVersion.draft4.rawValue)"))
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case schema = "$schema"
        case additionalProperties
        case required
        case description
        case type
        case properties
        case definitions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.schema = try container.decode(SchemaVersion.self, forKey: .schema)
        self.additionalProperties = try container.decodeIfPresent(Bool.self, forKey: .additionalProperties)
        self.required = try container.decodeIfPresent([String].self, forKey: .required)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)

        if let types = try? container.decode([JSONPrimitiveType].self, forKey: .type) {
            self.type = types
        } else if let type = try? container.decode(JSONPrimitiveType.self, forKey: .type) {
            self.type = [type]
        } else {
            self.type = nil
        }

        self.properties = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .properties)
        self.definitions = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .definitions)
    }
}

// MARK: - JSONPrimitiveType ..

// https://json-schema.org/understanding-json-schema/reference/type
enum JSONPrimitiveType: Decodable, Equatable {
    case string
    case object
    case boolean
    case array
    case integer
    case number
    case null

    init(from decoder: any Decoder) throws {
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
            throw DecodingError.typeMismatch(JSONPrimitiveType.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "➡️ Unknown value (\(value)) for type property. Please make sure the schema refers to https://json-schema.org/understanding-json-schema/reference/type", underlyingError: nil))
        }
    }
}

// MARK: - JSONUnionType ..

enum JSONUnionType: Decodable {
    case anyOf([JSONType])
    case allOf([JSONUnionType])
    case type(JSONType)

    enum CodingKeys: String, CodingKey {
        case anyOf
        case allOf
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        var allKeys = ArraySlice(container.allKeys)

        if let onlyKey = allKeys.popFirst(), allKeys.isEmpty {
            switch onlyKey {
            case .anyOf:
                let value = try container.decode([JSONType].self, forKey: .anyOf)
                self = .anyOf(value)

            case .allOf:
                let values = try container.decode([JSONUnionType].self, forKey: .allOf)
                self = .allOf(values)
            }
        } else {
            let container = try decoder.singleValueContainer()
            let jsonType = try container.decode(JSONType.self)
            self = .type(jsonType)
        }
    }

    func jsonType() -> JSONType {
        guard case .type(let jsonType) = self else {
            fatalError("Not a JSONType")
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
}

// MARK: - JSONType ..

struct JSONType: Decodable {
    let type: [JSONPrimitiveType]?
    let required: [String]?
    let description: String?
    let additionalProperties: Bool?
    let enumeration: [String]?
    let ref: String?
    let subSchema: SubSchema?

    // Nested enums for specific schema types
    indirect enum SubSchema {
        case string(StringSchema)
        case object(ObjectSchema)
        case array(ArraySchema)
        case number(NumberSchema)
        case boolean
        case null
    }

    // for Object
    // https://json-schema.org/understanding-json-schema/reference/object
    struct ObjectSchema: Decodable {
        let properties: [String: JSONUnionType]?
        let minProperties: Int?
        let maxProperties: Int?
        let patternProperties: [String: JSONUnionType]?

        // Validate required within string array if present
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.properties = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .properties)
            self.minProperties = try container.decodeIfPresent(Int.self, forKey: .minProperties)
            self.maxProperties = try container.decodeIfPresent(Int.self, forKey: .maxProperties)
            self.patternProperties = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .patternProperties)
        }
    }

    // for String
    // https://json-schema.org/understanding-json-schema/reference/string
    struct StringSchema: Decodable {
        let pattern: String?
        let minLength: Int?
        let maxLength: Int?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
            self.minLength = try container.decodeIfPresent(Int.self, forKey: .minLength)
            self.maxLength = try container.decodeIfPresent(Int.self, forKey: .maxLength)
        }
    }

    // for Array type
    // https://json-schema.org/understanding-json-schema/reference/array
    struct ArraySchema: Decodable {
        let items: JSONType?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.items = try container.decodeIfPresent(JSONType.self, forKey: .items)
        }
    }

    // for Number
    // https://json-schema.org/understanding-json-schema/reference/numeric
    struct NumberSchema: Decodable {
        let multipleOf: Double?
        let minimum: Double?
        let exclusiveMinimum: Bool?
        let maximum: Double?
        let exclusiveMaximum: Bool?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.multipleOf = try container.decodeIfPresent(Double.self, forKey: .multipleOf)
            self.minimum = try container.decodeIfPresent(Double.self, forKey: .minimum)
            self.exclusiveMinimum = try container.decodeIfPresent(Bool.self, forKey: .exclusiveMinimum)
            self.maximum = try container.decodeIfPresent(Double.self, forKey: .maximum)
            self.exclusiveMaximum = try container.decodeIfPresent(Bool.self, forKey: .exclusiveMaximum)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case items
        case pattern
        case required
        case description
        case properties
        case additionalProperties
        case minItems
        case exclusiveMinimum, exclusiveMaximum
        case multipleOf, minimum, maximum
        case enumeration = "enum"
        case minProperties
        case maxProperties
        case ref = "$ref"
        case minLength, maxLength
        case patternProperties
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let types = try? container.decode([JSONPrimitiveType].self, forKey: .type) {
            self.type = types
        } else if let type = try? container.decode(JSONPrimitiveType.self, forKey: .type) {
            self.type = [type]
        } else {
            self.type = nil
        }

        self.required = try container.decodeIfPresent([String].self, forKey: .required)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.additionalProperties = try container.decodeIfPresent(Bool.self, forKey: .additionalProperties)
        self.enumeration = try container.decodeIfPresent([String].self, forKey: .enumeration)
        self.ref = try container.decodeIfPresent(String.self, forKey: .ref)

        if let type = self.type, type.count == 1 {
            switch type[0] {
            case .string:
                self.subSchema = try .string(StringSchema(from: decoder))
            case .object:
                self.subSchema = try .object(ObjectSchema(from: decoder))
            case .boolean:
                self.subSchema = .boolean
            case .array:
                self.subSchema = try .array(ArraySchema(from: decoder))
            case .integer, .number:
                self.subSchema = try .number(NumberSchema(from: decoder))
            case .null:
                self.subSchema = .null
            }
        } else {
            self.subSchema = nil
        }
    }

    // Methods..
    func getProperties() -> [String: JSONUnionType]? {
        if case .object(let schema) = subSchema {
            return schema.properties
        }
        return nil
    }

    func object() -> ObjectSchema? {
        if case .object(let schema) = self.subSchema {
            return schema
        }
        return nil
    }

    func object(for property: String) -> JSONUnionType? {
        if case .object(let schema) = self.subSchema {
            return schema.properties?[property]
        }
        return nil
    }

    func stringSchema() -> StringSchema? {
        if case .string(let schema) = self.subSchema {
            return schema
        }
        return nil
    }

    func arraySchema() -> ArraySchema? {
        if case .array(let schema) = self.subSchema {
            return schema
        }
        return nil
    }

    func items() -> JSONType? {
        if case .array(let schema) = self.subSchema {
            return schema.items
        }
        return nil
    }
}
