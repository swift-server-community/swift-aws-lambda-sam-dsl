import Foundation

//MARK: - JSONSchema ..

struct JSONSchema: Decodable {
    let id: String?
    let schema: String
    let additionalProperties: Bool?
    let required: [String]?
    let description: String?
    let type: JSONSchemaType?
    let properties: [String: JSONUnionType]?
    let definitions: [String: JSONUnionType]?
    
    
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
        self.additionalProperties = try container.decodeIfPresent(Bool.self, forKey: .additionalProperties)
        
        
        required = try container.decodeIfPresent([String].self, forKey: .required)
        if let required = required {
            for item in required {
                guard item.isValidStringKey else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "➡️ Invalid key found in 'required' array: \(item)"))
                }
            }
        }
        
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        
        let schemaType = try JSONSchemaType(from: decoder)
        self.type = schemaType
        
        
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

//MARK: - JSONSchemaType ..


enum JSONSchemaType: Decodable, Equatable {
    case array([JSONPrimitiveType])
    case single(JSONPrimitiveType)
    
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let type = try? container.decode([JSONPrimitiveType].self, forKey: .type) {
            self = .array(type)
        } else {
            if let singleType = try? container.decode(JSONPrimitiveType.self, forKey: .type) {
                self = .single(singleType)
            } else {
                throw DecodingError.typeMismatch(JSONSchema.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "➡️ Could not decode 'type' property. Expected either an array of primitive types or a single primitive type", underlyingError: nil))
                
            }
        }
    }
}


//MARK: - JSONUnionType ..

enum JSONUnionType: Decodable {
    case anyOf([JSONType])
    case allOf([JSONType])
    case type(JSONType)
    case reference(String)
    
    
    enum CodingKeys: String, CodingKey {
        case anyOf = "anyOf"
        case allOf = "allOf"
        case ref = "$ref"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
           
            var allKeys = ArraySlice(container.allKeys)
            
            
            if let onlyKey = allKeys.popFirst(), allKeys.isEmpty {
                
                switch onlyKey {
                case .anyOf:
                    let value = try container.decode([JSONType].self, forKey: .anyOf)
                    self = .anyOf(value)
                    
                case .allOf:
                    let values = try container.decode([JSONType].self, forKey: .allOf)
                    for value in values {
                        if !(value is JSONType) {
                            throw DecodingError.typeMismatch(JSONUnionType.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "➡️ Unexpected element type in allOf", underlyingError: nil))
                        }
                    }
                    
                    self = .allOf(values)
                case .ref:
                    let refString = try container.decode(String.self, forKey: .ref)
                    self = .reference(refString)
                }
            } else {
                do {
                    let container = try decoder.singleValueContainer()
                    let jsonType = try container.decode(JSONType.self)
                    self = .type(jsonType)
                } catch DecodingError.typeMismatch {
                    let container = try decoder.singleValueContainer()
                    let stringArray = try container.decode([String].self)
                    
                    guard let firstString = stringArray.first else {
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "➡️ Empty array encountered where string was expected")
                    }
                    self = .reference(firstString)
                }
            }
        } catch {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "➡️ Failed to decode JSONUnionType: \(error.localizedDescription)"))
            
        }
    }
    
    
    func jsonType() -> JSONType {
        guard case .type(let jsonType) = self else {
            fatalError("not yet a JSONType")
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
    let schemaType: SchemaType?
    
    
    
    // Nested enums for specific schema types
    indirect enum SchemaType {
        case string(StringSchema)
        case object(ObjectSchema)
        case array(ArraySchema)
        case number(NumberSchema)
        case boolean
        case enumeration([String])
        case null
    }
    
    
    // for Object
    // https://json-schema.org/understanding-json-schema/reference/object
    struct ObjectSchema: Decodable {
        let properties: [String: JSONUnionType]?
        let minProperties: Int?
        let maxProperties: Int?
        
        
        // Validate required within string array if present
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            properties = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .properties)
            minProperties = try container.decodeIfPresent(Int.self, forKey: .minProperties)
            maxProperties = try container.decodeIfPresent(Int.self, forKey: .maxProperties)
        }
    }
    
    
    // for String
    // https://json-schema.org/understanding-json-schema/reference/string
    struct StringSchema: Decodable {
        let pattern: String?
        //minLength
        //maxLength
        
        init(pattern: String?){
            self.pattern = pattern
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
        }
    }
    
    // for Array type
    // https://json-schema.org/understanding-json-schema/reference/array
    struct ArraySchema: Decodable {
        let items: JSONType?
        
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            do {
                self.items = try container.decodeIfPresent(JSONType.self, forKey: .items)
                
            } catch {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "➡️ Failed to decode ArraySchema: \(error.localizedDescription)"))
            }
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
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            
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
            
            if self.type == nil && self.ref == nil {
                throw DecodingError.typeMismatch(JSONType.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Either 'type' or '$ref' must be present"))
            }
            
            if let type = self.type, type.count == 1 {
                switch type[0] {
                case .string:
                    self.schemaType = .string(try StringSchema(from: decoder))
                case .object:
                    self.schemaType = .object(try ObjectSchema(from: decoder))
                case .boolean:
                    self.schemaType = .boolean
                case .array:
                    self.schemaType = .array(try ArraySchema(from: decoder))
                case .integer, .number:
                    self.schemaType = .number(try NumberSchema(from: decoder))
                case .null:
                    self.schemaType = .null
                }
            } else {
                self.schemaType = nil
            }
            
        } catch {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "➡️ Failed to decode JSONType: \(error.localizedDescription)"))
        }
        
        
    }
    
    
    
    
    //Methods..
    func getProperties() -> [String: JSONUnionType]? {
        if case let .object(schema) = schemaType {
            return schema.properties
        }
        return nil
    }
    
    
    
    func getPattern() -> String? {
        if case let .string(schema) = schemaType {
            return schema.pattern
        }
        return nil
    }
    
    func getItems() -> JSONType? {
        if case let .array(schema) = schemaType {
            return schema.items
        }
        return nil
    }
    
    static func decodeObject(from dictionary: [String: Any]) throws -> JSONType {
        let decoder = JSONDecoder()
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decoder.decode(JSONType.self, from: data)
    }
    
    
    
}



//MARK: - Extensions ..


// Helper function to check for valid string key format
extension String {
    var isValidStringKey: Bool {
        let regex = #"^[a-zA-Z0-9_]+$"#  // Allow alphanumeric and underscore
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}


