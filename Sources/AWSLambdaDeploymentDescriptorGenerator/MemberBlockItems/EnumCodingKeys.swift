//
//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateEnumCodingKeys(with values: [String]) -> MemberBlockItemListSyntax {
        let enumInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("String"))
            InheritedTypeSyntax(type: TypeSyntax("CodingKey"))
        }
        let enumDecl = EnumDeclSyntax(modifiers: DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.private)) },
                                      name: .identifier("CodingKeys"),
                                      inheritanceClause: enumInheritance) {
            MemberBlockItemListSyntax {
                for value in values {
                    let caseName = value.toSwiftLabelCase()
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
                    }
                }
            }.with(\.leadingTrivia, .newlines(1))
        }.with(\.leadingTrivia, .newlines(2)) // end of enum

        return MemberBlockItemListSyntax { enumDecl }
    }
}
