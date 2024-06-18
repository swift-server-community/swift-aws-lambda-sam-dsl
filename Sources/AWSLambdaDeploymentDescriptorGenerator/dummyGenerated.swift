
public struct Example: Decodable, Equatable {
    let typeName: String
    let properties: [Property]
    let subTypes: [Example]
    init(typeName: String, properties: [Property], subTypes: [Example]) {
        self.typeName = typeName
        self.properties = properties
        self.subTypes = subTypes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.typeName = try container.decode(String.self, forKey: .typeName)
        self.properties = try container.decode([Property].self, forKey: .properties)
        self.subTypes = try container.decode([Example].self, forKey: .subTypes)
    }

    public struct Property: Decodable, Equatable {
        let name: String?
        let type: String
    }

    private enum CodingKeys: String, CodingKey {
        case typeName
        case properties
        case subTypes
    }
}
