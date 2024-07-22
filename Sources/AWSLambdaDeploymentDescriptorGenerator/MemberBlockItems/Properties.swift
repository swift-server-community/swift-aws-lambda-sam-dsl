//
//  Properties.swift
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
            self.logger.info("Processing property: \(propertyName)")

            let required = isRequired?.contains(propertyName) ?? false

            if case .type(let jSONType) = propertyType {
                self.logger.info("Handling 'type' for property: \(propertyName)")

                if propertyType.jsonType().hasEnum() {
                    self.logger.info("Property \(propertyName) has an enum type")

                    memberDecls.append(generateEnumDeclaration(for: propertyName, with: jSONType.enumValues() ?? ["No case found!"]))
                    memberDecls.append(generateEnumPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required))
                } else if let reference = propertyType.jsonType().reference {
                    self.logger.info("Property \(propertyName) has a reference type")

                    let propertyDecl = generateRegularPropertyDeclaration(for: propertyName,
                                                                          with: propertyType.jsonType(), isRequired: required)
                    memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                } else if let objectSchema = jSONType.object(), let patternProperties = objectSchema.patternProperties {
                    self.logger.info("Property \(propertyName) has an object type with pattern properties")

                    memberDecls.append(generatePatternPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required))
                } else if let objectSchema = jSONType.object(), let properties = objectSchema.properties {
                    self.logger.info("Property \(propertyName) has an object type with properties")

                    let swiftType = jSONType.swiftType(for: propertyName)
                    let propertyDecl = generateRegularPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required)
                    memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                } else {
                    self.logger.info("Property \(propertyName) is of a basic type")

                    let swiftType = jSONType.swiftType(for: propertyName)
                    let propertyDecl = generateRegularPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required)
                    memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                }
                codingKeys.append(propertyName)
            } else if case .anyOf(let jSONTypes) = propertyType {
                self.logger.info("Property \(propertyName) has 'anyOf' types")

                memberDecls.append(generateAnyOfDeclaration(for: propertyName, with: jSONTypes, isRequired: required))
                codingKeys.append(propertyName)
            } else if case .allOf(let jSONTypes) = propertyType {
                self.logger.info("Property \(propertyName) has 'allOf' types")
                memberDecls.append(generateAllOfDeclaration(for: propertyName, with: jSONTypes, isRequired: required))
                codingKeys.append(propertyName)
            }
        }

        return (memberDecls, codingKeys)
    }
}
