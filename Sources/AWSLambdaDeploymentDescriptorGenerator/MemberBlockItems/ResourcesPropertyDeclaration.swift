//
//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateResourcesPropertyDeclaration(for name: String, with types: [JSONType], isRequired: Bool) -> MemberBlockItemListSyntax {
        // Generate the Resources enum
        let enumInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
        


        let enumDecl = EnumDeclSyntax(modifiers: DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.public)) },
                                      name: .identifier(name),
                                      inheritanceClause: enumInheritance) {
            MemberBlockItemListSyntax {
                for jsonType in types {
                    if let reference = jsonType.reference {
                        let caseName = reference.contains(":") ? reference.toSwiftAWSEnumCase().toSwiftVariableCase() : String(reference.split(separator: "/").last ?? "unknown").toSwiftVariableCase()

                        let caseType = reference.contains(":") ? reference.toSwiftAWSEnumCase() : String(reference.split(separator: "/").last ?? "unknown")
                        
                        let typeAnnotation: TypeSyntaxProtocol = isRequired ? TypeSyntax(IdentifierTypeSyntax(name: .identifier(caseType))) : OptionalTypeSyntax(wrappedType: IdentifierTypeSyntax(name: .identifier(caseType)))
                        
                        EnumCaseDeclSyntax {
                            EnumCaseElementListSyntax {
                                EnumCaseElementSyntax(
                                    name: .identifier(caseName),
                                    parameterClause: EnumCaseParameterClauseSyntax(
                                        parameters: EnumCaseParameterListSyntax{
                                            EnumCaseParameterSyntax(
                                                type: typeAnnotation
                                            )
                                        }
                                    )
                                )
                            }
                        }
                    }
                }
            }.with(\.leadingTrivia, .newlines(1))
        }.with(\.leadingTrivia, .newlines(2))

        
        // Generate the resources property
        let resourcesProperty = VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
            PatternBindingSyntax(
                pattern: PatternSyntax(stringLiteral: name.toSwiftVariableCase()),
                typeAnnotation: TypeAnnotationSyntax(
                    colon: .colonToken(trailingTrivia: .space),
                    type: TypeSyntax(DictionaryTypeSyntax(
                        leftSquare: .leftSquareToken(),
                        key: TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))),
                        colon: .colonToken(),
                        value: TypeSyntax(stringLiteral: name),
                        rightSquare: .rightSquareToken()
                    ))
                )
            )
        }
        
        return MemberBlockItemListSyntax {
            DeclSyntax(resourcesProperty)
            DeclSyntax(enumDecl)
        }
    }
    
    func generateDependsPropertyDeclaration(for name: String, with types: [JSONType], isRequired: Bool) -> MemberBlockItemListSyntax {
        let enumInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
        var memberDecls = [MemberBlockItemListSyntax]()
        var structDecls = [StructDeclSyntax]()
   
        let enumDecl = EnumDeclSyntax(modifiers: DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.public)) },
                                      name: .identifier(name.toSwiftAWSClassCase().toSwiftClassCase()),
                                      inheritanceClause: enumInheritance) {
            MemberBlockItemListSyntax {
                for jsonType in types {
                    if let arrayType = jsonType.arraySchema() {
                        EnumCaseDeclSyntax {
                            EnumCaseElementListSyntax {
                                EnumCaseElementSyntax(
                                    name: .identifier("items"),
                                    parameterClause: EnumCaseParameterClauseSyntax(
                                        parameters: EnumCaseParameterListSyntax {
                                            EnumCaseParameterSyntax(
                                                type: TypeSyntax(IdentifierTypeSyntax(name: .identifier("[String]")))
                                            )
                                        }
                                    )
                                )
                            }
                        }
                    } else if let stringType = jsonType.stringSchema() {
                        EnumCaseDeclSyntax {
                            EnumCaseElementListSyntax {
                                EnumCaseElementSyntax(
                                    name: .identifier("itemsString"),
                                    parameterClause: EnumCaseParameterClauseSyntax(
                                        parameters: EnumCaseParameterListSyntax{
                                            EnumCaseParameterSyntax(
                                                type: TypeSyntax(IdentifierTypeSyntax(name: .identifier("String")))
                                            )
                                        }
                                    )
                                )
                            }
                        }
                        
                    } else if let objectType = jsonType.object() {
                        EnumCaseDeclSyntax {
                            EnumCaseElementListSyntax {
                                EnumCaseElementSyntax(
                                    name: .identifier("itemObject"),
                                    parameterClause: EnumCaseParameterClauseSyntax(
                                        parameters: EnumCaseParameterListSyntax{
                                            EnumCaseParameterSyntax(
                                                type: TypeSyntax(IdentifierTypeSyntax(name: .identifier("\(name.toSwiftAWSClassCase().toSwiftClassCase())Object")))
                                            )
                                        }
                                    )
                                )
                            }
                        }
                        
                    }  else if let reference = jsonType.reference {
                        
                        let caseName = reference.contains(":") ? reference.toSwiftAWSEnumCase().toSwiftVariableCase() : String(reference.split(separator: "/").last ?? "unknown").toSwiftVariableCase()
                        
                        let caseType = reference.contains(":") ? reference.toSwiftAWSEnumCase() : String(reference.split(separator: "/").last ?? "unknown")
                        
                        let typeAnnotation: TypeSyntaxProtocol = isRequired ? TypeSyntax(IdentifierTypeSyntax(name: .identifier(caseType))) : OptionalTypeSyntax(wrappedType: IdentifierTypeSyntax(name: .identifier(caseType)))
                        
                        EnumCaseDeclSyntax {
                            EnumCaseElementListSyntax {
                                EnumCaseElementSyntax(
                                    name: .identifier(caseName),
                                    parameterClause: EnumCaseParameterClauseSyntax(
                                        parameters: EnumCaseParameterListSyntax{
                                            EnumCaseParameterSyntax(
                                                type: typeAnnotation
                                            )
                                        }
                                    )
                                )
                            }
                        }
                    }
                }
            }.with(\.leadingTrivia, .newlines(1))
        }.with(\.leadingTrivia, .newlines(2))

        let typeAnnotation: TypeSyntaxProtocol
         if isRequired {
             typeAnnotation = TypeSyntax(DictionaryTypeSyntax(
                leftSquare: .leftSquareToken(),
                key: TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))),
                colon: .colonToken(),
                value: TypeSyntax(stringLiteral: name),
                rightSquare: .rightSquareToken()
            ))
         } else {
             typeAnnotation = OptionalTypeSyntax(wrappedType: TypeSyntax(DictionaryTypeSyntax(
                leftSquare: .leftSquareToken(),
                key: TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))),
                colon: .colonToken(),
                value: TypeSyntax(stringLiteral: name),
                rightSquare: .rightSquareToken()
            )))
         }
        // Generate the resources property
        let propertyDecl = VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
            PatternBindingSyntax(
                pattern: PatternSyntax(stringLiteral: name.toSwiftVariableCase()),
                typeAnnotation: TypeAnnotationSyntax(
                    colon: .colonToken(trailingTrivia: .space),
                    type: typeAnnotation)
            )
        }
        
       
            for jsonType in types {
                if let objectType = jsonType.object() {
                let propertyDecl = MemberBlockItemListSyntax {
                    let defaultInheritance = InheritanceClauseSyntax {
                        InheritedTypeSyntax(type: TypeSyntax("Codable"))
                        InheritedTypeSyntax(type: TypeSyntax("Sendable"))
                    }
                    StructDeclSyntax(modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
                                     name: TokenSyntax(stringLiteral: "\(name.toSwiftAWSClassCase().toSwiftClassCase())Object"),
                                     inheritanceClause: defaultInheritance) {
                        MemberBlockItemListSyntax {
                            
                        }
                    }
                    
                }
                memberDecls.append(MemberBlockItemListSyntax{propertyDecl})
                    
                } else if let objectSchema = jsonType.object(), let properties = objectSchema.properties { // if it has properties
                    let structDecl = generateStructDeclaration(for: "\(name.toSwiftAWSClassCase().toSwiftClassCase())Object",
                                                               with: properties, isRequired: jsonType.required)
                    memberDecls.append(MemberBlockItemListSyntax{structDecl})
                }

        }

        memberDecls.append(MemberBlockItemListSyntax{ propertyDecl })
        memberDecls.append(MemberBlockItemListSyntax{ enumDecl })
        for structDecl in structDecls {
            memberDecls.append(MemberBlockItemListSyntax{ structDecl })
        }
        
        // Return the combined declarations
        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }

    

    

}
