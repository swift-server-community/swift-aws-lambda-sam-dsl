//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    
    func generateEnumPropertyDeclaration(for name: String, with jsonType: JSONType, isRequired: Bool) -> MemberBlockItemListSyntax {
        let enumName = name.toSwiftClassCase()
        let enumRawValue = jsonType.enumValues()?.first ?? ""
        let enumCaseName = (enumRawValue.allLetterIsNumeric() ? ("v" + enumRawValue.toSwiftEnumCase()) : enumRawValue.toSwiftEnumCase())

        let enumVariableDecl = generateEnumVariableDecl(for: name,
                                                        with: enumName,
                                                        isRequired: isRequired,
                                                        enumCaseName: enumCaseName)

        return MemberBlockItemListSyntax { enumVariableDecl }
    }
    
    
    func generateEnumCaseDecl(name: String, type: String) -> EnumCaseDeclSyntax {
        return EnumCaseDeclSyntax {
            EnumCaseElementListSyntax {
                EnumCaseElementSyntax(
                    name: .identifier(name),
                    parameterClause: EnumCaseParameterClauseSyntax(
                        parameters: EnumCaseParameterListSyntax {
                            EnumCaseParameterSyntax(
                                type: TypeSyntax(IdentifierTypeSyntax(name: .identifier(type)))
                            )
                        }
                    )
                )
            }
        }
    }
    
}
