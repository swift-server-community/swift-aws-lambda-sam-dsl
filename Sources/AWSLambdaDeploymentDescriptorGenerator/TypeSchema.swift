
public protocol TemplateRendering {
    func render(_ object: Any?) -> String
}

public protocol TemplateLibrary {
    func getTemplate(named name: String) -> TemplateRendering?
}

struct TypeSchema: Decodable, Equatable {
    let typeName: String
    let properties: [Property]
    let subTypes: [TypeSchema]

    init(typeName: String, properties: [Property], subTypes: [TypeSchema]) {
        self.typeName = typeName
        self.properties = properties
        self.subTypes = subTypes
    }

    struct Property: Decodable, Equatable {
        let name: String?
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
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.typeName = try container.decode(String.self, forKey: .typeName)
        self.properties = try container.decode([Property].self, forKey: .properties)
        self.subTypes = try container.decode([TypeSchema].self, forKey: .subTypes)
    }

    private enum CodingKeys: String, CodingKey {
        case typeName
        case properties
        case subTypes
        case name
        case type
    }
}
