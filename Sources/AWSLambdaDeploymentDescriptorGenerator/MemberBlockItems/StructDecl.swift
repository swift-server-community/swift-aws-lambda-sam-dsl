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
            }
            MemberBlockItemListSyntax {
                for enumDecl in enumDecls {
                    enumDecl
                }
            }
        }
    }
}
