//
//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    

    func generateDefinitionsDeclaration(from dictionary: [String: JSONUnionType]?, into decls: inout [MemberBlockItemListSyntax], enumDecls: inout [MemberBlockItemListSyntax], codingKeys: inout [String]) -> [StructDeclSyntax] {
        guard let dictionary = dictionary else { return [] }
        var structDecls: [StructDeclSyntax] = []
        
        for (name, value) in dictionary {
            print("🎯 Processing key: \(name)")
            
            if case .type(let jsonType) = value {
                // Check for object schema with properties
                if let objectSchema = value.jsonType().object(), let properties = objectSchema.properties {
                    let structDecl = generateStructDeclaration(for: name.toSwiftAWSClassCase().toSwiftClassCase(),
                                                               with: properties)
                    
                    decls.append(MemberBlockItemListSyntax{ structDecl })
                    structDecls.append(structDecl)
                }
            }
        }
        return structDecls
    }
    
    
    
    
    func generateStructDeclaration(for name: String, with properties: [String: JSONUnionType]) -> StructDeclSyntax {
        var memberDecls = [MemberBlockItemListSyntax]()
        
        for (propertyName, propertyType) in properties {
            print("🏆 🏆", propertyName)
            if case .type(let jSONType) = propertyType {
                let propertyDecl = generateRegularPropertyDeclaration(for: propertyName, with: jSONType)
                memberDecls.append(MemberBlockItemListSyntax{ propertyDecl })
            }
        }
        
        let defaultInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
        
        return StructDeclSyntax(modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
                                name: TokenSyntax(stringLiteral: name),
                                inheritanceClause: defaultInheritance) {
            MemberBlockItemListSyntax {
                for memberDecl in memberDecls {
                    memberDecl
                }
            }
        }
    }
        
}
