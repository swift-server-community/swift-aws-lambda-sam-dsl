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
        print("✅ Generating Variable for: \(name)")
        return MemberBlockItemSyntax(decl: VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
            PatternBindingSyntax(
                pattern: PatternSyntax(stringLiteral: name.toSwiftVariableCase()),
                typeAnnotation: TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space), type: typeAnnotation)
            )
        })
    }

    func generateEnumVariableDecl(for propertyName: String, with enumName: String, isRequired: Bool, enumCaseName: String) -> MemberBlockItemSyntax {
        // Determine the type annotation based on the required flag
        let typeAnnotation: TypeSyntaxProtocol = isRequired ?
            TypeSyntax(stringLiteral: enumName) :
            OptionalTypeSyntax(wrappedType: TypeSyntax(stringLiteral: enumName))

        print("✅ Generating Enum Variable for: \(propertyName)")

        // Create the enum property declaration
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
        print("✅ Generating Dictionary Variable for: \(name)", swiftType)

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
