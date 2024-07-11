//
//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateStructDecl(name: String, decls: [MemberBlockItemListSyntax], enumDecls: [MemberBlockItemListSyntax]) -> StructDeclSyntax {
        
        let defaultInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
        return StructDeclSyntax(modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
                                name: TokenSyntax(stringLiteral: name),
                                inheritanceClause: defaultInheritance) {
            MemberBlockItemListSyntax {
                for decl in decls {
                    decl
                }
                for enumDecl in enumDecls {
                    enumDecl
                }
            }
        }
    }
    
    
    
    func generateSchemaStructDeclaration(from schema: JSONSchema, required: [String]?) -> StructDeclSyntax {
        var decls: [MemberBlockItemListSyntax] = []
        
        let defaultInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
        
        if let description = schema.description {
            let isRequired = required?.contains(description) ?? false
            let propertyDecl =  generateRegularPropertyDeclaration(for: description, with: "String", isRequired: isRequired)
            decls.append(propertyDecl)
        }
        
        if let id = schema.id {
            let isRequired = required?.contains(id) ?? false
            let propertyDecl = generateRegularPropertyDeclaration(for: id, with: "String", isRequired: isRequired)
            decls.append(propertyDecl)
        }
        
        let isRequired = required?.contains(schema.schema.rawValue) ?? false
        let propertyDecl = generateRegularPropertyDeclaration(for: schema.schema.rawValue, with: "String", isRequired: isRequired)
        decls.append(propertyDecl)
        
        return StructDeclSyntax(modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
                                name: TokenSyntax(stringLiteral: "JSONSchema"),
                                inheritanceClause: defaultInheritance) {
            MemberBlockItemListSyntax {
                for memberDecl in decls {
                    memberDecl
                }
            }
        }
    }
}
