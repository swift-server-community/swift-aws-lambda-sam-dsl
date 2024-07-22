import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateArrayOfTypesDeclaration(for name: String, with types: [JSONPrimitiveType], isRequired: Bool) -> MemberBlockItemListSyntax {
        let enumInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }

        var memberDecls = [MemberBlockItemListSyntax]()
        var structDecls = [StructDeclSyntax]()

        let enumDecl = EnumDeclSyntax(modifiers: DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.public)) },
                                      name: .identifier(name.toSwiftAWSClassCase().toSwiftClassCase()),
                                      inheritanceClause: enumInheritance) {
            MemberBlockItemListSyntax {
                for type in types {
                    switch type {
                    case .string:
                        generateEnumCaseDecl(name: "string", type: "String")
                    case .boolean:
                        generateEnumCaseDecl(name: "boolean", type: "Bool")
                    default:
                        generateEnumCaseDecl(name: "string", type: "String")
                    }
                }
            }.with(\.leadingTrivia, .newlines(1))
        }.with(\.leadingTrivia, .newlines(2))

        let variableDecl = generateVariableDecl(for: name, with: name, isRequired: isRequired)

        memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        memberDecls.append(MemberBlockItemListSyntax { enumDecl })
        for structDecl in structDecls {
            memberDecls.append(MemberBlockItemListSyntax { structDecl })
        }

        // Return the combined declarations
        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
}
