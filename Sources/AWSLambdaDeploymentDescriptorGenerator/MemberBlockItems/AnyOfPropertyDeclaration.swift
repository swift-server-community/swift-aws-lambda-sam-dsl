//
//  
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
     func generateAnyOfPropertyDeclaration(for key: String, with jsonTypes: [JSONType], isRequired: Bool) -> MemberBlockItemListSyntax {
         let propertyDecl = VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
            PatternBindingSyntax(
                pattern: PatternSyntax(stringLiteral: key.toSwiftLabelCase()),
                typeAnnotation: TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: buildAnyOfType(for: key, with: jsonTypes)))
            )
        }
        return MemberBlockItemListSyntax { propertyDecl }
    }

     func buildAnyOfType(for key: String, with jsonTypes: [JSONType]) -> String {
        return jsonTypes.map { $0.reference ?? "UnknownType" }.joined(separator: " | ")
    }
    
    func handleAnyOfCase(name: String, value: JSONUnionType, decls: inout [MemberBlockItemListSyntax], isRequired: Bool) {
        if case .anyOf(let jsonTypes) = value {
            if name == "Resources" {
                print("🧞‍♀️ -------------- \((name))")
                decls.append(generateResourcesPropertyDeclaration(for: name, with: jsonTypes, isRequired: isRequired))
            } else {
                print("🦹🏽‍♀️ -------------- \(name)")
                decls.append(generateAnyOfPropertyDeclaration(for: name, with: jsonTypes, isRequired: isRequired))
            }
        }
    }
}
