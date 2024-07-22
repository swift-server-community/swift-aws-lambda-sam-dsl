//
//  Declarations.swift
//
//
//  Created by Esraa Eid on 03/07/2024.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateProperties(properties: [String: JSONUnionType], isRequired: [String]?) -> ([MemberBlockItemListSyntax], [String]) {
        var memberDecls = [MemberBlockItemListSyntax]()
        var codingKeys = [String]()

        for (propertyName, propertyType) in properties {
            print("🐝 I am Struct Declaration looping properties for \(propertyName)")
            let required = isRequired?.contains(propertyName) ?? false

            if case .type(let jSONType) = propertyType {
                print("🐝 I am Struct Declaration inside 'type' of value: \(propertyName)")
                if propertyType.jsonType().hasEnum() {
                    print("🐝 I am Struct Declaration inside 'type' hasEnum: \(propertyName)")
                    memberDecls.append(generateEnumDeclaration(for: propertyName, with: jSONType.enumValues() ?? ["No case found!"]))
                    memberDecls.append(generateEnumPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required))
                } else if let reference = propertyType.jsonType().reference {
                    print("🐝 I am Struct Declaration inside 'type' reference: \(propertyName)")
                    let propertyDecl = generateRegularPropertyDeclaration(for: propertyName,
                                                                          with: propertyType.jsonType(), isRequired: required)
                    memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                } else if let objectSchema = jSONType.object(), let patternProperties = objectSchema.patternProperties {
                    print("🐝 I am Struct Declaration inside 'type' object: \(propertyName)")
                    memberDecls.append(generatePatternPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required))
                } else if let objectSchema = jSONType.object(), let properties = objectSchema.properties {
                    print("🐝 I am Struct Declaration inside properties for object and will append struct for that object: \(propertyName)")
                    let swiftType = jSONType.swiftType(for: propertyName)
                    let propertyDecl = generateRegularPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required)
                    memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                } else {
                    print("🐝 I am Struct Declaration inside 'type' not enum nor reference: \(propertyName) \n And Has subType: \(jSONType.subType ?? .null)")
                    let swiftType = jSONType.swiftType(for: propertyName)
                    let propertyDecl = generateRegularPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required)
                    memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                }
                codingKeys.append(propertyName)
            } else if case .anyOf(let jSONTypes) = propertyType {
                print("🐝 I am Struct Declaration inside 'anyOf' for: \(propertyName)")
                memberDecls.append(generateAnyOfDeclaration(for: propertyName, with: jSONTypes, isRequired: required))
                codingKeys.append(propertyName)
            } else if case .allOf(let jSONTypes) = propertyType {
                print("🐝 I am Struct Declaration inside 'allOf' for: \(propertyName)")
                memberDecls.append(generateAllOfDeclaration(for: propertyName, with: jSONTypes, isRequired: required))
                codingKeys.append(propertyName)
            }
        }

        return (memberDecls, codingKeys)
    }
}
