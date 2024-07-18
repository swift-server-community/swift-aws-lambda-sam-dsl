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
            print("🎯 I am Definitions Declaration and Processing key: \(name)")
            
            if case .type(let jsonType) = value {
                // Check for object schema with properties
                print("🎯 I am Definitions Declaration inside type of value: \(name)")
                if let objectSchema = value.jsonType().object(), let properties = objectSchema.properties {
                    let structDecl = generateStructDeclaration(for: name.toSwiftAWSClassCase().toSwiftClassCase(), with: properties, isRequired: jsonType.required)
                    structDecls.append(structDecl)
                    print("🎯 I am Definitions Declaration inside properties for object and will appedna struct for that object: \(name)")
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
            print("🐝 I am Struct Declaration looping properties for \(name)")
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
                } else  if let objectSchema = jSONType.object(), let patternProperties = objectSchema.patternProperties {
                    print("🐝 I am Struct Declaration inside 'type' object: \(propertyName)")
                    memberDecls.append(generatePatternPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required))
                    
                } else if let objectSchema = jSONType.object(), let properties = objectSchema.properties {
                    print("🐝 I am Struct Declaration inside properties for object and will appemd struct for that object: \(propertyName)")
                    let swiftType = jSONType.swiftType(for: propertyName)
                    let propertyDecl = generateRegularPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required)
                    memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                    } else {
                    print("🐝 I am Struct Declaration inside 'type' not enum nor refrence: \(propertyName) \n And Has subType: \(jSONType.subType ?? .null)")
                    let swiftType = jSONType.swiftType(for: propertyName)
                    let propertyDecl = generateRegularPropertyDeclaration(for: propertyName, with: jSONType, isRequired: required)
                    memberDecls.append(MemberBlockItemListSyntax { propertyDecl })
                }
                    
                     
                
                codingKeys.append(propertyName)
            } else if case .anyOf(let jSONTypes) = propertyType {
                print("🐝 I am Struct Declaration inside 'anyOf' for: \(propertyName)")
                memberDecls.append(generateDependsPropertyDeclaration(for: propertyName, with: jSONTypes, isRequired: required))
                codingKeys.append(propertyName)
            }
        }
        
        let defaultInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
        let codingKeysEnum = properties.isEmpty ?  MemberBlockItemListSyntax{} : generateEnumCodingKeys(with: codingKeys)
        
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
