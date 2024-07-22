//
//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateStructDeclaration(for name: String, with properties: [String: JSONUnionType],
                                   isRequired: [String]?) -> StructDeclSyntax {
        let (memberDecls, codingKeys) = generateProperties(properties: properties, isRequired: isRequired)

        let defaultInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
        let codingKeysEnum = properties.isEmpty ? MemberBlockItemListSyntax {} : generateEnumCodingKeys(with: codingKeys)

        return StructDeclSyntax(modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
                                name: TokenSyntax(stringLiteral: name.toSwiftAWSClassCase().toSwiftClassCase()),
                                inheritanceClause: defaultInheritance) {
            MemberBlockItemListSyntax {
                if !(memberDecls.isEmpty) {
                    for memberDecl in memberDecls {
                        memberDecl
                    }
                }
                codingKeysEnum
            }
        }
    }
}
