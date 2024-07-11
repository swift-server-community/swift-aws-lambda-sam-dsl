//
//
//
//
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateRegularPropertyDeclaration(for name: String, with swiftType: String, isRequired: Bool) -> MemberBlockItemListSyntax {
       
        let propertyName = name.toSwiftLabelCase()
        
        
        let typeAnnotation: TypeSyntaxProtocol
         if isRequired {
             typeAnnotation = TypeSyntax(stringLiteral: swiftType)
         } else {
             typeAnnotation = OptionalTypeSyntax(wrappedType: TypeSyntax(stringLiteral: swiftType))
         }
        
        let propertyDecl = MemberBlockItemSyntax(decl:
            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                PatternBindingSyntax(
                    pattern: PatternSyntax(stringLiteral: propertyName),
                    typeAnnotation: TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space),
                                                         type: typeAnnotation)
                                                        
                )
            }
        )
        return MemberBlockItemListSyntax { propertyDecl }
    }
    
    
}
