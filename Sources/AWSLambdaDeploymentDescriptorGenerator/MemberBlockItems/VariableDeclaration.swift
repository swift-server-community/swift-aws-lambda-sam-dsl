//
//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateVariableDecl(for name: String, with type: String, isRequired: Bool) -> MemberBlockItemSyntax {
        let typeAnnotation: TypeSyntaxProtocol = isRequired ? TypeSyntax(stringLiteral: type.toSwiftClassCase()) : OptionalTypeSyntax(wrappedType: TypeSyntax(stringLiteral: type.toSwiftClassCase()))
        self.logger.info("Generating variable declaration for property: \(name)")

        return MemberBlockItemSyntax(decl: VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
            PatternBindingSyntax(
                pattern: PatternSyntax(stringLiteral: name.toSwiftVariableCase()),
                typeAnnotation: TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space), type: typeAnnotation)
            )
        })
    }

    func generateEnumVariableDecl(for propertyName: String, with enumName: String, isRequired: Bool, enumCaseName: String) -> MemberBlockItemSyntax {
        let typeAnnotation: TypeSyntaxProtocol = isRequired ?
            TypeSyntax(stringLiteral: enumName) :
            OptionalTypeSyntax(wrappedType: TypeSyntax(stringLiteral: enumName))

        self.logger.info("Generating enum variable declaration for property: \(propertyName)")

        return MemberBlockItemSyntax(decl:
            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                PatternBindingSyntax(
                    pattern: PatternSyntax(stringLiteral: propertyName.toSwiftVariableCase()),
                    typeAnnotation: TypeAnnotationSyntax(
                        colon: .colonToken(trailingTrivia: .space),
                        type: typeAnnotation
                    ),
                    initializer: InitializerClauseSyntax(value: ExprSyntax(".\(raw: enumCaseName)"))
                )
            }
        )
    }

    func generateDictionaryVariable(for name: String, with swiftType: String, isRequired: Bool) -> MemberBlockItemSyntax {
        self.logger.info("Generating dictionary variable for: \(name) with type: \(swiftType)")

        let typeAnnotation: TypeSyntaxProtocol = isRequired ? TypeSyntax(DictionaryTypeSyntax(
            leftSquare: .leftSquareToken(),
            key: TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))),
            colon: .colonToken(),
            value: TypeSyntax(stringLiteral: swiftType),
            rightSquare: .rightSquareToken()
        )) : OptionalTypeSyntax(wrappedType: TypeSyntax(DictionaryTypeSyntax(
            leftSquare: .leftSquareToken(),
            key: TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))),
            colon: .colonToken(),
            value: TypeSyntax(stringLiteral: swiftType),
            rightSquare: .rightSquareToken()
        )))

        return MemberBlockItemSyntax(decl: VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
            PatternBindingSyntax(
                pattern: PatternSyntax(stringLiteral: name.toSwiftVariableCase()),
                typeAnnotation: TypeAnnotationSyntax(
                    colon: .colonToken(trailingTrivia: .space),
                    type: typeAnnotation
                )
            )
        })
    }
}
