extension Templates {
    static let structTemplate = #"""
    {{%CONTENT_TYPE:TEXT}}
    {{! Template for a decodable struct }}
    {{scope}} {{object}} {{name}}: {{shapeProtocol}} {
    {{#properties}}
      {{#comment}}
        {{>comment}}
      {{/comment}}
      {{#propertyWrapper}}
        @{{.}}
      {{/propertyWrapper}}
      {{scope}} {{#propertyWrapper}}var{{/propertyWrapper}}{{^propertyWrapper}}let{{/propertyWrapper}} {{variable}}: {{type}}{{#isOptional}}?{{/isOptional}}
    {{/properties}}

      {{! init() function }}
      {{scope}} init({{#properties}}{{variable}}: {{type}}{{#default}} = {{.}}{{/default}}{{^last}}, {{/last}}{{/properties}}) {
      {{#properties}}
        self.{{variable}} = {{variable}}
      {{/properties}}
    }

      {{! Decoding logic (replace existing logic) }}
      {{#shapeCoding.requiresDecodeInit}}
        {{scope}} init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          {{#properties}}
            {{#isCodable}}
              self.{{variable}} = try container.decode{{^required}}IfPresent{{/required}}({{codableType}}.self, forKey: .{{variable}}){{#propertyWrapper}}.wrappedValue{{/propertyWrapper}}
            {{/isCodable}}
            {{#isPrimitive}} // Handle primitive types directly (e.g., Int, String)
              self.{{variable}} = try container.decode({{type}}.self, forKey: .{{variable}})
            {{/isPrimitive}}
            {{^isCodable}}
            {{^isPrimitive}} // Handle non-codable types (e.g., custom structs)
              // Logic for handling custom types (might involve a separate decoder)
            {{/isPrimitive}}
            {{/isCodable}}
          {{/properties}}
        }
      {{/shapeCoding.requiresDecodeInit}}

      {{! CodingKeys enum }}
      {{#properties}}
      private enum CodingKeys: String, CodingKey {
        case {{variable}} = "{{name}}"
      }
      {{/properties}}
      {{^properties}}
        private enum CodingKeys: CodingKey {}
      {{/properties}}
    }
    """#
}
