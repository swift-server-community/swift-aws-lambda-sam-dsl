extension Templates {
    static let structTemplate = #"""
    {{%CONTENT_TYPE:TEXT}}

    {{scope}} struct {{name}}: {{shapeProtocol}} {
        {{scope}} let typeName: String
        {{#properties}}
        {{scope}} let {{variable}}: {{type}}
        {{/properties}}
        {{#subTypes}}
        {{scope}} let subTypes: [{{name}}]
        {{/subTypes}}

        {{scope}} let properties: [Property]

        {{scope}} init(typeName: String, {{#properties}}{{variable}}: {{type}}{{#isOptional}}?{{/isOptional}}{{^last}}, {{/last}}{{/properties}}{{#subTypes}}, subTypes: [{{name}}]{{/subTypes}}, properties: [Property]) {
            self.typeName = typeName
            {{#properties}}
            self.{{variable}} = {{variable}}
            {{/properties}}
            {{#subTypes}}
            self.subTypes = subTypes
            {{/subTypes}}
            self.properties = properties
        }

        {{scope}} init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.typeName = try container.decode(String.self, forKey: .typeName)
            {{#properties}}
            self.{{variable}} = try container.decode({{type}}.self, forKey: .{{variable}})
            {{/properties}}
            {{#subTypes}}
            self.subTypes = try container.decode([{{name}}].self, forKey: .subTypes)
            {{/subTypes}}
            self.properties = try container.decode([Property].self, forKey: .properties)
        }

        private enum CodingKeys: String, CodingKey {
            case typeName
            {{#properties}}
            case {{variable}}
            {{/properties}}
            {{#subTypes}}
            case subTypes
            {{/subTypes}}
            case properties
        }

        {{scope}} struct Property: Codable {
            {{scope}} let name: String
            {{scope}} let type: String

            {{scope}} init(name: String, type: String) {
                self.name = name
                self.type = type
            }

            {{scope}} init(from decoder: Decoder) throws {
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

    {{#subTypes}}
    {{>structTemplate}}
    {{/subTypes}}
    """#
}
