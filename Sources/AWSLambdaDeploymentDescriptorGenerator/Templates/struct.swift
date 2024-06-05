extension Templates {
    static let structTemplate = #"""
    {{%CONTENT_TYPE:TEXT}}
    {{scope}} {{object}} {{name}}: {{shapeProtocol}} {
    {{#properties}}
      {{scope}} let {{variable}}: {{type}}
    {{/properties}}
    
    {{#subTypes}}
      {{scope}} let subTypes: [{{name}}]
    {{/subTypes}}
    
      {{scope}} init({{#properties}}{{variable}}: {{type}}{{^last}}, {{/last}}{{/properties}}{{#subTypes}}, subTypes: [{{name}}]{{/subTypes}}) {
      {{#properties}}
        self.{{variable}} = {{variable}}
      {{/properties}}
      {{#subTypes}}
        self.subTypes = subTypes
      {{/subTypes}}
    }
    
      {{scope}} init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        {{#properties}}
          self.{{variable}} = try container.decode({{type}}.self, forKey: .{{variable}})
        {{/properties}}
        {{#subTypes}}
          self.subTypes = try container.decode([{{name}}].self, forKey: .subTypes)
        {{/subTypes}}
      }
    
      private enum CodingKeys: String, CodingKey {
        {{#properties}}
        case {{variable}}
        {{/properties}}
        {{#subTypes}}
        case subTypes
        {{/subTypes}}
      }
    }
    
    {{#subTypes}}
    {{>structTemplate}}
    {{/subTypes}}
    """#
}
