//
//
//
//
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateRegularPropertyDeclaration(for name: String, with jsonType: JSONType) -> MemberBlockItemListSyntax {
        let swiftType = jsonType.swiftType(for: name)
        let propertyName = name.toSwiftLabelCase()
        let propertyDecl = MemberBlockItemSyntax(decl:
            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                PatternBindingSyntax(
                    pattern: PatternSyntax(stringLiteral: propertyName),
                    typeAnnotation: TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space),
                                                         type: TypeSyntax(stringLiteral: swiftType))
                )
            }
        )
        return MemberBlockItemListSyntax { propertyDecl }
    }
}
