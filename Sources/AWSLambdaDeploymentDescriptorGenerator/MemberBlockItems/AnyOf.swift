
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateAnyOfDeclaration(for name: String, with types: [JSONType], isRequired: Bool) -> MemberBlockItemListSyntax {
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
                        if let item = arrayType.items, let stringType = item.stringSchema() {
//                            print("🛺 I am stringSchemaArray in 'anyof' for: \(name) \n with type: \(item.swiftType(for: name)))"
                            generateEnumCaseDecl(name: "itemArray", type: "[\(item.swiftType(for: name))]")
                        } else if let reference = arrayType.items?.reference {
                            let caseName = reference.contains(":") ? reference.toSwiftAWSEnumCase().toSwiftVariableCase() : String(reference.split(separator: "/").last ?? "unknown").toSwiftVariableCase()

                            let caseType = reference.contains(":") ? reference.toSwiftAWSEnumCase() : String(reference.split(separator: "/").last ?? "unknown")
                            generateEnumCaseDecl(name: "\(caseName)Array", type: "[\(caseType)]")
//                            print("🛺 I am referenceArray in 'anyof' for: \(name) \n with type: \(reference)")
                        }

                    } else if let stringType = jsonType.stringSchema() {
//                        print("🛺 I am string in 'anyof' for: \(name)")
                        generateEnumCaseDecl(name: "item", type: "\(jsonType.swiftType(for: name))")

                    } else if let objectType = jsonType.object() {
//                        print("🛺 I am object in 'anyof' for: \(name)")
                        generateEnumCaseDecl(name: "itemObject", type: "\(name.toSwiftAWSClassCase().toSwiftClassCase())Object")
                    } else if let reference = jsonType.reference {
//                        print("🛺 I am reference in 'anyof' for: \(name) \n with type: \(reference)")
                        let caseName = reference.contains(":") ? reference.toSwiftAWSEnumCase().toSwiftVariableCase() : String(reference.split(separator: "/").last ?? "unknown").toSwiftVariableCase()

                        let caseType = reference.contains(":") ? reference.toSwiftAWSEnumCase() : String(reference.split(separator: "/").last ?? "unknown")
                        generateEnumCaseDecl(name: caseName, type: caseType)
                    }
                }
            }.with(\.leadingTrivia, .newlines(1))
        }.with(\.leadingTrivia, .newlines(2))

        let variableDecl = generateDictionaryVariable(for: name, with: name, isRequired: isRequired)

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
                        MemberBlockItemListSyntax {}
                    }
                }
                memberDecls.append(MemberBlockItemListSyntax { propertyDecl })

            } else if let objectSchema = jsonType.object(), let properties = objectSchema.properties { // if it has properties
                let structDecl = generateStructDeclaration(for: "\(name)Object",
                                                           with: properties, isRequired: jsonType.required)
                memberDecls.append(MemberBlockItemListSyntax { structDecl })
            }
        }

        memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        memberDecls.append(MemberBlockItemListSyntax { enumDecl })
        for structDecl in structDecls {
            memberDecls.append(MemberBlockItemListSyntax { structDecl })
        }

        // Return the combined declarations
        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
}
