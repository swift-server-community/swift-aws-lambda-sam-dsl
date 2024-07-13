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
        
        let propertyName = name.toSwiftVariableCase()
        var swiftType = type.swiftType(for: name)
        
        if let objectSchema = type.object() {
            if let properties = objectSchema.properties {
                
                for (property, propertyValue) in properties {
                    print("property 🧿", property)
                }
                //                let structDecl = generateStructDeclaration(for: name.toSwiftAWSClassCase().toSwiftClassCase(), with: properties, isRequired: type.required)
                //                memberDecls.append(MemberBlockItemListSyntax { structDecl }.with(\.leadingTrivia, .newlines(2)))
                let variableDecl = generateVariableDecl(for: propertyName, with: swiftType, isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })
                
            } else if let patternProperties = objectSchema.patternProperties {
                for (pattern, patternValue) in patternProperties {
                    if let reference = patternValue.jsonType().reference {
                        let referenceType = reference.contains(":") ? reference.toSwiftAWSEnumCase() : String(reference.split(separator: "/").last ?? "unknown")
                        swiftType = referenceType
                        let variableDecl = generateVariableDecl(for: propertyName, with: swiftType, isRequired: isRequired)
                        memberDecls.append(MemberBlockItemListSyntax { variableDecl })
                    } else {
                        let propertyDecl = generateStructForObjectSchema(name: name)
                        memberDecls.append(MemberBlockItemListSyntax { propertyDecl }.with(\.leadingTrivia, .newlines(2)))
                        let variableDecl = generateVariableDecl(for: propertyName, with: swiftType, isRequired: isRequired)
                        memberDecls.append(MemberBlockItemListSyntax { variableDecl })
                    }
                }
            } else {
                let propertyDecl = generateStructForObjectSchema(name: name)
                memberDecls.append(MemberBlockItemListSyntax { propertyDecl }.with(\.leadingTrivia, .newlines(2)))
                let variableDecl = generateVariableDecl(for: propertyName, with: swiftType, isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })
            }
        } else if let reference = type.reference {
            swiftType = reference.toSwiftAWSClassCase()
            let variableDecl = generateVariableDecl(for: propertyName, with: swiftType, isRequired: isRequired)
            memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        }
        
        
        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
    
    func generateVariableDecl(for name: String, with type: String, isRequired: Bool) -> MemberBlockItemSyntax {
        let typeAnnotation: TypeSyntaxProtocol = isRequired ? TypeSyntax(stringLiteral: type) : OptionalTypeSyntax(wrappedType: TypeSyntax(stringLiteral: type))
        
        return MemberBlockItemSyntax(decl: VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
            PatternBindingSyntax(
                pattern: PatternSyntax(stringLiteral: name),
                typeAnnotation: TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space), type: typeAnnotation)
            )
        })
    }
    
    func generateStructForObjectSchema(name: String) -> StructDeclSyntax {
        print("🧖🏽‍♀️: ", name)
        let defaultInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }
        return StructDeclSyntax(
            modifiers: DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.public)) },
            name: TokenSyntax(stringLiteral: name.toSwiftAWSClassCase().toSwiftClassCase()),
            inheritanceClause: defaultInheritance
        ) {
            MemberBlockItemListSyntax {}
        }
    }
}
