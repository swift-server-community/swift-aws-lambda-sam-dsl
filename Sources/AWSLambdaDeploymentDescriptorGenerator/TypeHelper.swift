//
//
//
//

import Foundation

protocol PropertyInfo {
    static var typeDescription: String { get }
}

extension String: PropertyInfo {
    static var typeDescription: String { "String" }
}

extension JSONSchemaDialectVersion: PropertyInfo {
    static var typeDescription: String { "JSONSchemaDialectVersion" }
}

extension JSONPrimitiveType: PropertyInfo {
    static var typeDescription: String { "JSONPrimitiveType" }
}

extension JSONUnionType: PropertyInfo {
    static var typeDescription: String { "JSONUnionType" }
}

extension Bool: PropertyInfo {
    static var typeDescription: String { "Bool" }
}

extension Array: PropertyInfo where Element == String {
    static var typeDescription: String { "Array<String>" }
}

extension Dictionary: PropertyInfo where Key == String, Value == JSONUnionType {
    static var typeDescription: String { "Dictionary<String, JSONUnionType>" }
}

extension JSONSchema {
    func propertiesWithTypes() -> [(name: String, type: String, value: Any?)] {
        return [
            ("id", String.typeDescription, id),
            ("schema", JSONSchemaDialectVersion.typeDescription, schema),
            ("description", String.typeDescription, description),
            ("type", JSONPrimitiveType.typeDescription, type),
            ("properties", Dictionary<String, JSONUnionType>.typeDescription, properties),
            ("additionalProperties", Bool.typeDescription, additionalProperties),
            ("required", Array<String>.typeDescription, required),
            ("definitions", Dictionary<String, JSONUnionType>.typeDescription, definitions)
        ]
    }
}
