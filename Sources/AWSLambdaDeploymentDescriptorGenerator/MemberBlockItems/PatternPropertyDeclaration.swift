//
//  
//
//
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
     func generatePatternPropertyDeclaration(for key: String, with pattern: String, jsonTypes: [JSONType]) -> MemberBlockItemListSyntax {
        let propertyDecl = VariableDeclSyntax(modifiers: DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.public)) },
                                              bindingSpecifier: .keyword(.let)) {
            PatternBindingSyntax(
                pattern: PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("\(key)_\(pattern.toSwiftVariableCase())"))),
                typeAnnotation: TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: buildAnyOfType(for: key, with: jsonTypes)))
            )
        }
        return MemberBlockItemListSyntax { propertyDecl }
    }
}
