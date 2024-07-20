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
    var enumDecls =  [MemberBlockItemListSyntax]()
        let propertyName = name.toSwiftVariableCase()
        var swiftType = type.swiftType(for: name)
        
        //var conditions: [String: Condition] = [:]
        //TODO: we need to handle this with function to verify the name matches the pattern
        
        print("🌍 I am Regular Property for: \(name)")
        
        if let objectSchema = type.object() {
            print("🌍 I am Regular Property with 'object' for: \(name)")
            if let properties = objectSchema.properties {
                print("🌍 I am Regular Property object with 'properties' for: \(name)")
                let structDecl = generateStructDeclaration(for: name.toSwiftAWSClassCase().toSwiftClassCase(), with: properties, isRequired: type.required)
                memberDecls.append(MemberBlockItemListSyntax { structDecl }.with(\.leadingTrivia, .newlines(2)))
                
                let variableDecl = generateVariableDecl(for: propertyName, with: name.toSwiftAWSClassCase().toSwiftClassCase(), isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })
                
            } else if let patternProperties = objectSchema.patternProperties {
                print("🌍 I am Regular Property object with 'patternProperties' for: \(name)")                    
                    memberDecls.append(generatePatternPropertyDeclaration(for: name, with: type, isRequired: isRequired))
            } else {
                
                print("🌍 I am Regular Property object not 'properties' nor 'patternProperties' for: \(name)")
                let propertyDecl = generateStructForObjectSchema(name: name)
                memberDecls.append(MemberBlockItemListSyntax { propertyDecl }.with(\.leadingTrivia, .newlines(2)))
                
                let variableDecl = generateVariableDecl(for: propertyName, with: swiftType, isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })
            }
        } else if let reference = type.reference {
            print("🌍 I am Regular Property with 'reference' for: \(name)")
            swiftType = reference.toSwiftAWSClassCase()
            let variableDecl = generateVariableDecl(for: propertyName, with: swiftType, isRequired: isRequired)
            memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        } else if let arrayValue = type.arraySchema() {
            print("🌍 I am Regular Property with 'arraySchema' for: \(name)")
        
            if let jsonType = arrayValue.items {
                if let objectValue = jsonType.object() {
                    print("🌍 I am object with 'arraySchema' for: \(name)")
                    let structDecl = generateStructDeclaration(for: name.toSwiftAWSClassCase().toSwiftClassCase(),
                                                               with: objectValue.properties ?? [:], isRequired: type.required)
                    memberDecls.append(MemberBlockItemListSyntax { structDecl }.with(\.leadingTrivia, .newlines(2)))
                    
                } else if let stringValue = jsonType.stringSchema() {
                    print("🌍 I am stringValue with 'arraySchema' for: \(name))")
                    swiftType = "[\(jsonType.swiftType(for: name))]"
                }
            } else {
                swiftType = "[String]"
                print("🌍 I am 'arraySchema' with no type defined for: \(name)")
            }
            let variableDecl = generateVariableDecl(for: propertyName, with: swiftType, isRequired: isRequired)
            memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        }else {
            print("🌍 I am Regular Property not 'object' nor 'reference' for: \(name)")
            if let arrayOfType = type.type, arrayOfType.count > 1 {
                print("🌍 I am Regular Property and have arrayOfType for: \(name)")
                memberDecls.append(generateArrayOfTypesDeclaration(for: propertyName, with: arrayOfType, isRequired: isRequired))
            } else {
                let variableDecl = generateVariableDecl(for: propertyName, with: swiftType, isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })
            }
            
        }
        
        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
    
    func generateVariableDecl(for name: String, with type: String, isRequired: Bool) -> MemberBlockItemSyntax {
        let typeAnnotation: TypeSyntaxProtocol = isRequired ? TypeSyntax(stringLiteral: type) : OptionalTypeSyntax(wrappedType: TypeSyntax(stringLiteral: type))
        print("✅ I will generate Variable for: \(name)")
        return MemberBlockItemSyntax(decl: VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
            PatternBindingSyntax(
                pattern: PatternSyntax(stringLiteral: name),
                typeAnnotation: TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space), type: typeAnnotation)
            )
        })
    }
    
    func generateStructForObjectSchema(name: String) -> StructDeclSyntax {
        //TODO: make a check to see whether it includes properties or pattertn properties 
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
