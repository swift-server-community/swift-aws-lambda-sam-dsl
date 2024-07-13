//
//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    
    func generateDefinitionsDeclaration(from dictionary: [String: JSONUnionType]?) -> [StructDeclSyntax] {
        guard let dictionary = dictionary else { return [] }
        var structDecls: [StructDeclSyntax] = []
        
        for (name, value) in dictionary {
            print("🎯 Processing key: \(name)")
            
            if case .type(let jsonType) = value {
                // Check for object schema with properties
                if let objectSchema = value.jsonType().object(), let properties = objectSchema.properties {
                    let structDecl = generateStructDeclaration(for: name.toSwiftAWSClassCase().toSwiftClassCase(), with: properties, isRequired: jsonType.required)
                    structDecls.append(structDecl)
                }
            }
        }
        return structDecls
    }
    
    func generateStructDeclaration(for name: String, with properties: [String: JSONUnionType],
                                   isRequired: [String]?) -> StructDeclSyntax {
        var memberDecls = [MemberBlockItemListSyntax]()
        var definitionCodingKeys = [String]()
        var codingKeys = [String]()
        
        for (propertyName, propertyType) in properties {
            print("🏆 🏆", propertyName)
            let required = isRequired?.contains(propertyName) ?? false
            
            if case .type(let jSONType) = propertyType {
                if propertyType.jsonType().hasEnum() {
                    memberDecls.append(generateEnumDeclaration(for: propertyName, with: jSONType.enumValues() ?? ["No case found!"]))
                    memberDecls.append(generateEnumPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required)) //
                    
                } else if let reference = propertyType.jsonType().reference {
                    let propertyDecl = generateRegularPropertyDeclaration(for: propertyName,
                                                                          with: propertyType.jsonType(), isRequired: required)
                    memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                } else {
                        let swiftType = jSONType.swiftType(for: propertyName)
                        let propertyDecl = generateRegularPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required)
                        memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                }
                codingKeys.append(propertyName)
            } else if case .anyOf(let jSONTypes) = propertyType {
                print("🎸 Found anyOf within patternProperty for pattern: \(propertyName)")
                memberDecls.append(generateDependsPropertyDeclaration(for: propertyName, with: jSONTypes, isRequired: required))
                codingKeys.append(propertyName)
            }
        }
        
        let defaultInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
        let codingKeysEnum = generateEnumCodingKeys(with: codingKeys)
        
        return StructDeclSyntax(modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
                                name: TokenSyntax(stringLiteral: name),
                                inheritanceClause: defaultInheritance) {
            MemberBlockItemListSyntax {
                for memberDecl in memberDecls {
                    memberDecl
                }
                codingKeysEnum
            }
        }
    }
}
