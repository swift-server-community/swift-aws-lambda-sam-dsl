struct JSONSchema: Decodable {
    let id: String?
    let schema: String
    let description: String?
    let type: JSONPrimitiveType
    let properties: [String: JSONUnionType]?
    let definitions: [String: JSONUnionType]?
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case schema = "$schema"
        case description
        case type
        case properties
        case definitions
    }
}

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
            throw DecodingError.typeMismatch(JSONPrimitiveType.self, DecodingError.Context.init(codingPath: container.codingPath, debugDescription: "Unknown value (\(value)) for type property. Please make sure the schema refers to https://json-schema.org/understanding-json-schema/reference/type", underlyingError: nil))
        }
    }
}

// TODO change to a struct to support pattern ?

enum ArrayItem: Decodable, Equatable {
    case singleType(JSONPrimitiveType)
    case multipleTypes([JSONPrimitiveType])
    case ref(String)
    
    enum CodingKeys: String, CodingKey {
        case type
        case ref = "$ref"
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var allKeys = ArraySlice(container.allKeys)
        guard let onlyKey = allKeys.popFirst(), allKeys.isEmpty else {
            throw DecodingError.typeMismatch(ArrayItem.self, DecodingError.Context.init(codingPath: container.codingPath, debugDescription: "Invalid number of keys found, expected one, found \(allKeys.count).", underlyingError: nil))
        }
        switch onlyKey {
        case .type:
            if let primitiveType = try? container.decode(JSONPrimitiveType.self, forKey: .type) {
                self = .singleType(primitiveType)
            } else {
                let arrayOfPrimitiveType = try container.decode([JSONPrimitiveType].self, forKey: .type)
                self = .multipleTypes(arrayOfPrimitiveType)
            }
            
        case .ref:
            let ref = try container.decode(String.self, forKey: .ref)
            self = .ref(ref)
        }
    }
}

enum JSONUnionType: Decodable {
    case anyOf([JSONType])
    case anyOfArrayItem([ArrayItem])
    case allOf([JSONType])
    case type(JSONType)
    
    enum CodingKeys: String, CodingKey {
        case anyOf
        case allOf
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var allKeys = ArraySlice(container.allKeys)
        if let onlyKey = allKeys.popFirst(), allKeys.isEmpty  {
            // there is an anyOf or allOf key
            switch onlyKey {
            case .allOf: fatalError("not yet implemented")
            case .anyOf:
                if let value = try? container.decode(Array<JSONType>.self, forKey: .anyOf) {
                    self = .anyOf(value)
                } else {
                    let value = try container.decode(Array<ArrayItem>.self, forKey: .anyOf)
                    self = .anyOfArrayItem(value)
                }
            }
        } else {
            // there is no anyOf or allOf key, the entry is a raw JSONType, without key
            let container = try decoder.singleValueContainer()
            let jsonType = try container.decode(JSONType.self)
            self = .type(jsonType)
        }
    }
    
    func jsonType() -> JSONType {
        guard case .type(let jsonType) = self else {
            fatalError("not a JSONType")
        }
        
        return jsonType
    }
}

// TODO maybe convert this in an enum to cover all possible values of JSONPrimitiveType extensions
struct JSONType: Decodable {
    let type: JSONPrimitiveType
    let required: [String]?
    let description: String?
    let additionalProperties: Bool?
    
    // for Object
    // https://json-schema.org/understanding-json-schema/reference/object
    let properties: [String: JSONUnionType]?
    
    // for String
    // https://json-schema.org/understanding-json-schema/reference/string
    let pattern: String? // or RegEx ?
    // not supported at the moment
    // let minLength
    // let maxLength
    // let format: String // should be an enum to match specification
    
    // for Array type
    // https://json-schema.org/understanding-json-schema/reference/array
    let items: ArrayItem?
    // not supported at the moment
    // let prefixItems
    // let unevaluatedItems
    // let contains
    // let minContains
    // let maxContains
    // let minItems
    // let maxItems
    // let uniqueItems


    enum CodingKeys: String, CodingKey {
        case type
        case items
        case pattern
        case required
        case description
        case properties
        case additionalProperties
    }
}
