//
//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateEnumDeclaration(for key: String, with values: [String]) -> MemberBlockItemListSyntax {
        let enumName = key.toSwiftClassCase()
        let enumInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("String"))
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
        let enumDecl = EnumDeclSyntax(modifiers: DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.public)) },
                                      name: .identifier(enumName),
                                      inheritanceClause: enumInheritance) {
            MemberBlockItemListSyntax {
                
                    for value in values {
                        let caseName = (value.allLetterIsNumeric() ? ("v" + value.toSwiftEnumCase()) : value.toSwiftEnumCase())
                        EnumCaseDeclSyntax {
                        EnumCaseElementListSyntax {
                            EnumCaseElementSyntax(
                                name: .identifier(caseName),
                                rawValue: InitializerClauseSyntax(
                                    equal: .equalToken(trailingTrivia: .space),
                                    value: ExprSyntax(StringLiteralExprSyntax(content: value))
                                )
                            )
                        }
                    }.with(\.leadingTrivia, .newlines(1))
                }
            }
        }.with(\.leadingTrivia, .newlines(2))

        return MemberBlockItemListSyntax { enumDecl }
    }
}
