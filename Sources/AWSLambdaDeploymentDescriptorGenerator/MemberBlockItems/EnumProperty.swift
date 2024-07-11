//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateEnumPropertyDeclaration(for name: String, with jsonType: JSONType, isRequired: Bool) -> MemberBlockItemListSyntax {
        let propertyName = name.toSwiftLabelCase()
        let enumName = name.toSwiftClassCase()
        let enumRawValue = jsonType.enumValues()?.first ?? ""
        let enumCaseName = (enumRawValue.allLetterIsNumeric() ? ("v" + enumRawValue.toSwiftEnumCase()) : enumRawValue.toSwiftEnumCase())
        
        let typeAnnotation: TypeSyntaxProtocol
         if isRequired {
             typeAnnotation = TypeSyntax(stringLiteral: enumName)
         } else {
             typeAnnotation = OptionalTypeSyntax(wrappedType: TypeSyntax(stringLiteral: enumName))
         }
        
        let enumPropertyDecl = MemberBlockItemSyntax(decl:
            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                PatternBindingSyntax(
                    pattern: PatternSyntax(stringLiteral: propertyName),
                    typeAnnotation: TypeAnnotationSyntax(type: typeAnnotation),
                    initializer: InitializerClauseSyntax(value: ExprSyntax(".\(raw: enumCaseName)"))
                )
            }
        )
        return MemberBlockItemListSyntax { enumPropertyDecl }
    }
}
