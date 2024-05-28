import Foundation

//MARK: - JSONSchema ..

struct JSONSchema: Decodable {
    let id: String?
    let schema: String
    let additionalProperties: Bool?
    let required: [String]?
    let description: String?
    let type: [JSONPrimitiveType]?
    let properties: [String: JSONUnionType]?
    let definitions: [String: JSONUnionType]?
    
    
    enum SchemaVersion: String, Decodable {
        case draft4 = "http://json-schema.org/draft-04/schema#"
        case draft6 = "http://json-schema.org/draft-06/schema#"
        case draft7 = "http://json-schema.org/draft-07/schema#"
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
        self.schema = try container.decode(String.self, forKey: .schema)
        guard schema == SchemaVersion.draft4.rawValue else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unsupported schema version: \(schema). Expected \(SchemaVersion.draft4.rawValue)"))
        }
        
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

//MARK: - JSONPrimitiveType ..

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
            throw DecodingError.typeMismatch(JSONPrimitiveType.self, DecodingError.Context.init(codingPath: container.codingPath, debugDescription: "➡️ Unknown value (\(value)) for type property. Please make sure the schema refers to https://json-schema.org/understanding-json-schema/reference/type", underlyingError: nil))
        }
        
    }
}



//MARK: - JSONUnionType ..

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
            do {
                let container = try decoder.singleValueContainer()
                let jsonType = try container.decode(JSONType.self)
                self = .type(jsonType)
            }
        }
    }
    
    
    func jsonType() -> JSONType {
        guard case .type(let jsonType) = self else {
            fatalError("Not a JSONType")
        }
        
        return jsonType
    }
    
    
}

//MARK: - JSONType ..

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
            properties = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .properties)
            minProperties = try container.decodeIfPresent(Int.self, forKey: .minProperties)
            maxProperties = try container.decodeIfPresent(Int.self, forKey: .maxProperties)
            patternProperties = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .patternProperties)
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
            pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
            minLength = try container.decodeIfPresent(Int.self, forKey: .minLength)
            maxLength = try container.decodeIfPresent(Int.self, forKey: .maxLength)
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
            multipleOf = try container.decodeIfPresent(Double.self, forKey: .multipleOf)
            minimum = try container.decodeIfPresent(Double.self, forKey: .minimum)
            exclusiveMinimum = try container.decodeIfPresent(Bool.self, forKey: .exclusiveMinimum)
            maximum = try container.decodeIfPresent(Double.self, forKey: .maximum)
            exclusiveMaximum = try container.decodeIfPresent(Bool.self, forKey: .exclusiveMaximum)
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
                self.subSchema = .string(try StringSchema(from: decoder))
            case .object:
                self.subSchema = .object(try ObjectSchema(from: decoder))
            case .boolean:
                self.subSchema = .boolean
            case .array:
                self.subSchema = .array(try ArraySchema(from: decoder))
            case .integer, .number:
                self.subSchema = .number(try NumberSchema(from: decoder))
            case .null:
                self.subSchema = .null
            }
        } else {
            self.subSchema = nil
        }
        
        
    }
    
    
    
    
    //Methods..
    func getProperties() -> [String: JSONUnionType]? {
        if case let .object(schema) = subSchema {
            return schema.properties
        }
        return nil
    }
    
    func object() -> ObjectSchema? {
        if case let .object(schema) = self.subSchema {
            return schema
        }
        return nil
    }
    
    func object(for property:String) -> JSONUnionType? {
        if case let .object(schema) = self.subSchema {
            return schema.properties?[property]
        }
        return nil
    }
    
    func stringSchema() -> StringSchema? {
        if case let .string(schema) = self.subSchema {
            return schema
        }
        return nil
    }
    
    func arraySchema() -> ArraySchema? {
        if case let .array(schema) = self.subSchema {
            return schema
        }
        return nil
    }
    
    func items() -> JSONType? {
        if case let .array(schema) = self.subSchema {
            return schema.items
        }
        return nil
    }
    
    
}



