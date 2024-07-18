//
//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    
   
    func generatePatternPropertyDeclaration(for name: String, with type: JSONType, isRequired: Bool) -> MemberBlockItemListSyntax {
        var memberDecls = [MemberBlockItemListSyntax]()
        var propertyDecls = [VariableDeclSyntax]()
        var swiftType = type.swiftType(for: name)
    
        //TODO: handle regex pattern with function
        //TODO: handle min,max Properties
        if let objectSchema = type.object() {
            if let patternProperties = objectSchema.patternProperties {
                for (pattern, patternValue) in patternProperties {
                    if case .anyOf(let jsonTypes) = patternValue {
                        print("🏓 I am Generate Declaration with 'patternProperties' and 'hasAnyOf' for: \(name)")
                        memberDecls.append(generateDependsPropertyDeclaration(for: name, with: jsonTypes, isRequired: isRequired))
                    } else if case .type(let jsonType) = patternValue {
                        if let stringSchema = jsonType.stringSchema() {
                           swiftType = "String"
                            propertyDecls.append(generateDictionaryProperty(for: name, with: swiftType, isRequired: isRequired))
                            print("🏓 I am Generate Declaration with 'type', 'String' for: \(name)")
                        } else {
                            print("🏓 I am Generate Declaration with not handled type yet for: \(name)")
                        }
                       
                    }  else if case .allOf(let jsonTypes) = patternValue {
                        print("🏓 I am Generate Declaration with 'patternProperties' and 'allOf' for: \(name)")
                    }
                }

            } else {
                let properties = objectSchema.properties ?? [:]
                let structDecl = generateStructDeclaration(for: name.toSwiftAWSClassCase().toSwiftClassCase(), with: properties, isRequired: type.required)
                memberDecls.append(MemberBlockItemListSyntax { structDecl }.with(\.leadingTrivia, .newlines(2)))
                propertyDecls.append(generateDictionaryProperty(for: name, with: swiftType, isRequired: isRequired))
                print("🏓 I am 'object' for: \(name)")
            }
        
        } else  if let stringSchema = type.stringSchema() {
            swiftType = "String"
            print("🏓 I am 'string' for: \(name)")
        } else  if let reference = type.reference {
            let referenceType = reference.contains(":") ? reference.toSwiftAWSEnumCase() :
            String(reference.split(separator: "/").last ?? "unknown")
            swiftType = referenceType
            propertyDecls.append(generateDictionaryProperty(for: name, with: swiftType, isRequired: isRequired))
            print("🏓 I am 'reference' for: \(swiftType)")
        } else {
            print("🏓 I am TypeCase and my case is not handled for: \(name)")
        }
        print("🏓 I am PatternProperty for: \(name)")
        return MemberBlockItemListSyntax {
            
            for property in propertyDecls {
                DeclSyntax(property)
            }
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
    
    func generateDictionaryProperty(for name: String, with swiftType: String, isRequired: Bool) -> VariableDeclSyntax {
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

        let property = VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
            PatternBindingSyntax(
                pattern: PatternSyntax(stringLiteral: name.toSwiftVariableCase()),
                typeAnnotation: TypeAnnotationSyntax(
                    colon: .colonToken(trailingTrivia: .space),
                    type: typeAnnotation
                )
            )
        }

        return property
    }

    
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
                                    name: .identifier("itemString"),
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
