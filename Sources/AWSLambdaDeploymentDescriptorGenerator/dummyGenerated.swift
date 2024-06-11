
 struct Hello: Codable {
     let typeName: String
     let id: Int
     let name: String

     let properties: [Property]

     init(typeName: String, id: Int, name: String, properties: [Property]) {
        self.typeName = typeName
        self.id = id
        self.name = name
        self.properties = properties
    }

     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.typeName = try container.decode(String.self, forKey: .typeName)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.properties = try container.decode([Property].self, forKey: .properties)
    }

    private enum CodingKeys: String, CodingKey {
        case typeName
        case id
        case name
        case properties
    }
    
     struct Property: Codable {
         let name: String
         let type: String

         init(name: String, type: String) {
            self.name = name
            self.type = type
        }

         init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name)
            self.type = try container.decode(String.self, forKey: .type)
        }

        private enum CodingKeys: String, CodingKey {
            case name
            case type
        }
    }
}

