
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    
    func generateAllOfDeclaration(for name: String, with unionTypes: [JSONUnionType], isRequired: Bool) -> MemberBlockItemListSyntax {
        var propertyDecls = [MemberBlockItemListSyntax]()
        var memberDecls = [MemberBlockItemListSyntax]()
        var codingKeys = [String]()

        for type in unionTypes {
            if case .anyOf(let jsonTypes) = type {
                print("✈️ I am Generate Allof Declaration with 'anyOf'': \(name)")
                for jsonType in jsonTypes {
                    if let properties = jsonType.properties {
                        print("✈️ I am Generate Allof Declaration with 'properties': \(name)")
                        for (propertyName, propertyType) in properties {
                            if case .type(let jSONType) = propertyType {
                                let swiftType = jSONType.swiftType(for: propertyName)
                                let requiredProperty = jSONType.required?.contains(propertyName) ?? false
                                let propertyDecl = generateRegularPropertyDeclaration(for: propertyName,
                                                                                      with: jSONType,
                                                                                      isRequired: requiredProperty)
                                propertyDecls.append(MemberBlockItemListSyntax { propertyDecl })
                            } else if case .anyOf(let jSONTypes) = propertyType {
                                print("✈️ I am Struct Declaration inside 'anyOf' for: \(propertyName)")
                                let requiredProperty = jSONTypes.compactMap(\.required).flatMap { $0 }.contains(propertyName)
                                propertyDecls.append(self.generateAnyOfDeclaration(for: propertyName, with: jSONTypes, isRequired: requiredProperty))
                            }
                            codingKeys.append(propertyName)
                        }
                    }
                }

            } else if case .type(let jSONType) = type {
                if let objectSchema = jSONType.object(), let properties = objectSchema.properties {
                    let (memberDeclsProperties, codingKeysProperties) = generateProperties(properties: properties, isRequired: jSONType.required)

                    for memberDeclsProperty in memberDeclsProperties {
                        propertyDecls.append(MemberBlockItemListSyntax { memberDeclsProperty })
                    }
                    codingKeys.append(contentsOf: codingKeysProperties)
                    print("✈️ I am Generate Allof Declaration with 'type': \(name)")
                }
            }
        }
        propertyDecls.append(MemberBlockItemListSyntax { generateEnumCodingKeys(with: codingKeys) })

        let defaultInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }

        let structDecl = StructDeclSyntax(modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
                                          name: TokenSyntax(stringLiteral: name),
                                          inheritanceClause: defaultInheritance) {
            MemberBlockItemListSyntax {
                for propertyDecl in propertyDecls {
                    propertyDecl
                }
            }
        }

        // Generate the resources property
        let variableDecl = generateDictionaryVariable(for: name, with: name, isRequired: isRequired)

        // generateDictionaryVariable
        memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        memberDecls.append(MemberBlockItemListSyntax { structDecl })

        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
}
