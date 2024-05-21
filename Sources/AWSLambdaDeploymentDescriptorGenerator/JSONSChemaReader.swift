import Foundation


struct JSONSchema: Decodable {
    let id: String?
    let schema: String
    let additionalProperties: Bool? //
    let required: [String]? //
    let description: String?
    let title: String? //
    let type: JSONPrimitiveType //make this an array
    let properties: [String: JSONUnionType]?
    let definitions: [String: JSONUnionType]?
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case schema = "$schema"
        case additionalProperties
        case required
        case description
        case title
        case type
        case properties
        case definitions
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.schema = try container.decode(String.self, forKey: .schema)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.additionalProperties = try container.decodeIfPresent(Bool.self, forKey: .additionalProperties)
        
        // Validate required within string array if present
        required = try container.decodeIfPresent([String].self, forKey: .required)
        if let required = required {
            for item in required {
                guard item.isValidStringKey else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid key found in 'required' array: \(item)"))
                }
            }
        }
        
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.type = try container.decode(JSONPrimitiveType.self, forKey: .type) // array first or singleValue
        self.properties = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .properties)
        self.definitions = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .definitions)
                
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
    case allOf([JSONType])
    case type(JSONType)
    indirect case reference(String) //
    
    enum CodingKeys: String, CodingKey {
      case anyOf
      case allOf = "allOf"
      case ref = "$ref"
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
          let values = try container.decode([JSONType].self, forKey: .allOf)
          for value in values {
            if !(value is JSONType) {
                throw DecodingError.typeMismatch(JSONUnionType.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unexpected element type in allOf", underlyingError: nil))
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
              // Handle the case where a string is expected but an array is encountered
              let container = try decoder.singleValueContainer()
              let stringArray = try container.decode([String].self)
              guard let firstString = stringArray.first else {
                  throw DecodingError.dataCorruptedError(in: container, debugDescription: "Empty array encountered where string was expected")
              }
              self = .reference(firstString)
          }
      }
    }
    

    
    func jsonType() -> JSONType {
        guard case .type(let jsonType) = self else {
          fatalError("not yet a JSONType")
        }

        return jsonType
      }
}

// TODO change to a struct to support pattern  ?

struct ArrayItem: Decodable, Equatable {
    let type: JSONPrimitiveType?
    let reference: String?
    let pattern: String? //

  enum CodingKeys: String, CodingKey {
    case type
    case reference = "$ref"
    case pattern
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    var allKeys = Set(container.allKeys)
      

    if allKeys.contains(.type) {
      self.type = try container.decodeIfPresent(JSONPrimitiveType.self, forKey: .type) //
      allKeys.remove(.type)
    } else {
      self.type = nil
    }

    if allKeys.contains(.reference) {
      self.reference = try container.decodeIfPresent(String.self, forKey: .reference)
      allKeys.remove(.reference)
    } else {
      self.reference = nil
    }

    if allKeys.contains(.pattern) {
      self.pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
      allKeys.remove(.pattern)
    } else {
      self.pattern = nil
    }

      if !allKeys.isEmpty { //should be at the start of the decoder?
          throw DecodingError.typeMismatch(ArrayItem.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unexpected keys found: \(allKeys)", underlyingError: nil))
      }

  }

}

// TODO maybe convert this in an enum to cover all possible values of JSONPrimitiveType extensions: Done ✅ ?

struct JSONType: Decodable {
    let type: JSONPrimitiveType
    let items: ArrayItem? //
    let required: [String]?
    let description: String?
    let additionalProperties: Bool?
    let enumeration: [String]? //
    
    
    // Nested enums for specific schema types
    enum SchemaType {
        case string(StringSchema)
        case object(ObjectSchema)
        case array(ArraySchema)
        case number(NumberSchema)
        case boolean(Bool)
        case enumeration([String])
        case null
    }
    
    
    // for Object
    // https://json-schema.org/understanding-json-schema/reference/object
    struct ObjectSchema: Decodable {
        let required: [String]?
        let description: String?
        let additionalProperties: Bool? //
        let properties: [String: JSONUnionType]?
        let enumeration: [String]?
        
        
        // Validate required within string array if present
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            required = try container.decodeIfPresent([String].self, forKey: .required)
            if let required = required {
                for item in required {
                    guard item.isValidStringKey else {
                        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid key found in 'required' array: \(item)"))
                    }
                }
            }
            description = try container.decodeIfPresent(String.self, forKey: .description)
            additionalProperties = try container.decodeIfPresent(Bool.self, forKey: .additionalProperties)
            properties = try container.decodeIfPresent([String: JSONUnionType].self, forKey: .properties)
            enumeration = try container.decodeIfPresent([String].self, forKey: .enumeration)
        }
    }
    
    
    // for String
    // https://json-schema.org/understanding-json-schema/reference/string
    struct StringSchema: Decodable {
        let pattern: String?
        //     let minLength
        //     let maxLength
        //     let format: String // should be an enum to match specification
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            pattern = try container.decodeIfPresent(String.self, forKey: .pattern)
            
        }
    }
    
    // for Array type
    // https://json-schema.org/understanding-json-schema/reference/array
    struct ArraySchema: Decodable {
        let items: ArrayItem?
        let minItems: Int?

           init(from decoder: Decoder) throws {
             let container = try decoder.container(keyedBy: CodingKeys.self)
             items = try container.decodeIfPresent(ArrayItem.self, forKey: .items)
             minItems = try container.decodeIfPresent(Int.self, forKey: .minItems)
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
    }
    
    //print(container.codingPath)
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
            self.type = try container.decode(JSONPrimitiveType.self, forKey: .type)
            self.required = try container.decodeIfPresent([String].self, forKey: .required)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.additionalProperties = try container.decodeIfPresent(Bool.self, forKey: .additionalProperties)
            self.items = try container.decodeIfPresent(ArrayItem.self, forKey: .items)
            self.enumeration = try container.decodeIfPresent([String].self, forKey: .enumeration)
    
            
            switch self.type {
            case .string:
                self.schemaType = .string(try StringSchema(from: decoder))
            case .object:
                self.schemaType = .object(try ObjectSchema(from: decoder))
            case .array:
                self.schemaType = .array(try ArraySchema(from: decoder))
            case .number:
                self.schemaType = .number(try NumberSchema(from: decoder))
            case .boolean:
                self.schemaType = .boolean(false) // Set a default value
            case .null:
                self.schemaType = .null
            case .integer:
                self.schemaType = .number(try NumberSchema(from: decoder))
            }
        

    }
    
    // Access the specific schema type
    var schemaType: SchemaType
    
    
    //Methods..
    func getProperties() -> [String: JSONUnionType]? {
        if case let .object(schema) = schemaType {
            return schema.properties
        }
        return nil
    }
    
    func getEnumerations() -> [String]? {
        if case let .object(schema) = schemaType {
            return schema.enumeration
        }
        return nil
    }
    
    func getPattern() -> String? {
        if case let .string(schema) = schemaType {
            return schema.pattern
        }
        return nil
    }
    
    func getItems() -> ArrayItem? {
        if case let .array(schema) = schemaType {
            return schema.items
        }
        return nil
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


extension Decoder {
    func currentlyDecodingJSON() -> Any? {
        guard let json = userInfo[CodingUserInfoKey(rawValue: "jsonDictionary")!] else {
            return nil
        }

        return jsonAtPath(codingPath, in: json)
    }

    func jsonAtPath<T: Sequence>(_ path: T, in otherJSON: Any?) -> Any? where T.Element == CodingKey {
        guard let key = path.first(where: {_ in true}) else { return otherJSON }

        if let index = key.intValue {
            guard let array = otherJSON as? [Any] else { return otherJSON }
            return jsonAtPath(codingPath.dropFirst(), in: array[index])
        }
        guard let dictionary = otherJSON as? [String: Any] else { return otherJSON }
        return jsonAtPath(codingPath.dropFirst(), in: dictionary[key.stringValue])

    }
}
