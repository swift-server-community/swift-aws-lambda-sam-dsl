//
//
//
//
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateRegularPropertyDeclaration(for name: String, with type: JSONType, isRequired: Bool) -> MemberBlockItemListSyntax {
        
        var memberDecls = [MemberBlockItemListSyntax]()
        
        let propertyName = name.toSwiftLabelCase()
        var swiftType = type.swiftType(for: name)
        
        if let objectSchema = type.object() {
            if let properties = objectSchema.properties {
                let structDecl = generateStructDeclaration(for: name.toSwiftAWSClassCase().toSwiftClassCase(),
                                                           with: properties, isRequired: type.required)
                let member = MemberBlockItemListSyntax{structDecl}.with(\.leadingTrivia, .newlines(2))
                memberDecls.append(member)
            }  else if let reference = type.reference {
                print("refrence: 🐸", name)
                swiftType = reference.toSwiftAWSClassCase()
           } else {
                let propertyDecl = MemberBlockItemListSyntax {
                    let defaultInheritance = InheritanceClauseSyntax {
                        InheritedTypeSyntax(type: TypeSyntax("Codable"))
                        InheritedTypeSyntax(type: TypeSyntax("Sendable"))
                    }
                    StructDeclSyntax(modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
                                     name: TokenSyntax(stringLiteral: name.toSwiftAWSClassCase().toSwiftClassCase()),
                                     inheritanceClause: defaultInheritance) {
                        MemberBlockItemListSyntax {
                            
                        }
                    }
                    
                }
                let member = MemberBlockItemListSyntax{propertyDecl}.with(\.leadingTrivia, .newlines(2))
                memberDecls.append(member)
            }
        } else if let reference = type.reference {
            print("refrence: 😂", name)
            swiftType = reference.toSwiftAWSClassCase()
        }
       
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
        
        memberDecls.append(MemberBlockItemListSyntax{propertyDecl})
        
        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
    
    
}
