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
        
        // the key name changed between JSON Schema version
        case definitions_draft4 = "definitions"
        case definition = "$defs"
    }
    
    // implement a custom init(from:) method to support different schema version
    init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.schema = try container.decode(String.self, forKey: .schema)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.type = try container.decode(JSONPrimitiveType.self, forKey: .type)
        self.properties = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .properties)
        
        // support multiple version of the "definition" key, depending on JSON Schema version
        if self.schema.contains("2020-12") {
            self.definitions = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .definition)
        } else if self.schema.contains("draft-04") {
            self.definitions = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .definitions_draft4)
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context.init(
                    codingPath: container.codingPath,
                    debugDescription: "Unspported schema version: \(self.schema)"))
        }
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

enum JSONUnionType: Decodable {
    case anyOf([JSONType])
    case anyOfArrayItem([ArrayItem])
    case allOf([JSONUnionType])
    case type(JSONType)
    case ref(String)
    
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
            case .allOf:
                let value = try container.decode(Array<JSONUnionType>.self, forKey: .allOf)
                self = .allOf(value)
            case .anyOf:
                if let value = try? container.decode(Array<JSONType>.self, forKey: .anyOf) {
                    self = .anyOf(value)
                } else {
                    let value = try container.decode(Array<ArrayItem>.self, forKey: .anyOf)
                    self = .anyOfArrayItem(value)
                }
            }
        } else {
            // there is no anyOf or allOf key, the entry has no key and is either
            // - a raw JSONType
            // - a ref to another type : "$ref" : "path/to/other/path" (which is decoded as `ArrayItem`
            let container = try decoder.singleValueContainer()
            if let jsonType = try? container.decode(JSONType.self) {
                self = .type(jsonType)
            } else {
                let ref = try container.decode(ArrayItem.self)
                guard case .ref(let s) = ref else {
                    throw DecodingError.typeMismatch(ArrayItem.self, DecodingError.Context.init(codingPath: container.codingPath, debugDescription: "This key has no JSONType no Ref. Expecting an ArrayItem for: \(ref)", underlyingError: nil))
                }
                self = .ref(s)
            }
            
        }
    }
    
    // convenience function to extract a JSONType from this enum
    func jsonType() -> JSONType {
        guard case .type(let jsonType) = self else {
            fatalError("not a JSONType")
        }
        
        return jsonType
    }
}

struct JSONType: Decodable {
    // most type are single value, but sometimes it's an array
    /*
     "type": "string"
     
     "type": [
       "string",
       "boolean"
     ]
     */
    let type: [JSONPrimitiveType]?
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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // check if this is a single value or an array
        self.type = try singleorMultipleValueArray(in: container, forKey: .type)
        
        self.items = try container.decodeIfPresent(ArrayItem.self, forKey: .items)
        self.pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
        self.required = try container.decodeIfPresent([String].self, forKey: .required)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.properties = try container.decodeIfPresent([String : JSONUnionType].self, forKey: .properties)
        self.additionalProperties = try container.decodeIfPresent(Bool.self, forKey: .additionalProperties)
    }
}

/*
 Represents an `items` type that is present when the JSON primitive type is "array"
 Note: I tried to just add `ref` to `JSONType` to suppress this struct entirely
 but that causes a recursive usage of JSONtype inside JSONtype (because of JSONType.items: JSONType)
 */
// TODO change to a struct to support pattern ?
enum ArrayItem: Decodable, Equatable {
    case type([JSONPrimitiveType])
    case ref(String)
    
    enum CodingKeys: String, CodingKey {
        case type
        case ref = "$ref"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // extract the one and only key in this containers (either type or ref)
        var allKeys = ArraySlice(container.allKeys)
        guard let onlyKey = allKeys.popFirst(), allKeys.isEmpty else {
            throw DecodingError.typeMismatch(ArrayItem.self, DecodingError.Context.init(codingPath: container.codingPath, debugDescription: "Invalid number of keys found, expected one, found \(allKeys.count).", underlyingError: nil))
        }
        
        switch onlyKey {
        case .type:
            self = .type(try singleorMultipleValueArray(in: container, forKey: .type))
        case .ref:
            let ref = try container.decode(String.self, forKey: .ref)
            self = .ref(ref)
        }
    }
}

// to avoid having to code this at two different places
fileprivate func singleorMultipleValueArray<T: CodingKey>(in container: KeyedDecodingContainer<T>, forKey key: T) throws -> [JSONPrimitiveType] {
    let result: [JSONPrimitiveType]

    // first try to decode a single value
    if let primitiveType = try? container.decode(JSONPrimitiveType.self, forKey: key) {
        // and store it as an array of one element
        result = [primitiveType]
    } else {
        // if it doesn't work, try to decode an array
        // if it doesn't work neither, this is a programming error, raise an exception
        let arrayOfPrimitiveType = try container.decode([JSONPrimitiveType].self, forKey: key)
        result = arrayOfPrimitiveType
    }
    return result
}
