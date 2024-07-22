
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
        var enumDecls = [EnumCaseDeclSyntax]()

        for jsonType in types {
            if let arrayType = jsonType.arraySchema() {
                if let item = arrayType.items, let stringType = item.stringSchema() {
                    self.logger.info("Generating 'anyOf' case for an array of strings in: \(name)")

                    enumDecls.append(generateEnumCaseDecl(name: "itemArray", type: "[\(item.swiftType(for: name))]"))
                } else if let reference = arrayType.items?.reference {
                    let caseName = reference.toSwiftEnumCaseName()

                    let caseType = reference.toSwiftObject()
                    enumDecls.append(generateEnumCaseDecl(name: "\(caseName)Array", type: "[\(caseType)]"))
                    self.logger.info("Generating 'anyOf' case for an array of references in: \(name) with type: \(reference)")
                }

            } else if let stringType = jsonType.stringSchema() {
                self.logger.info("Generating 'anyOf' case for a string type in: \(name)")

                enumDecls.append(generateEnumCaseDecl(name: "item", type: "\(jsonType.swiftType(for: name))"))

            } else if let objectType = jsonType.object() {
                self.logger.info("Generating 'anyOf' case for an object type in: \(name)")
                enumDecls.append(generateEnumCaseDecl(name: "itemObject", type: "\(name.toSwiftAWSClassCase().toSwiftClassCase())Object"))
            } else if let reference = jsonType.reference {
                self.logger.info("Generating 'anyOf' case for a reference type in: \(name) with type: \(reference)")

                let caseName = reference.toSwiftEnumCaseName()

                let caseType = reference.toSwiftObject()
                enumDecls.append(generateEnumCaseDecl(name: caseName, type: caseType))
            }
        }

        let variableDecl = generateDictionaryVariable(for: name, with: name, isRequired: isRequired)

        for jsonType in types {
            if let objectType = jsonType.object() {
                self.logger.info("Generating struct declaration for object type in 'anyOf': \(name)")

                let properties = objectType.properties ?? [:]
                let structDecl = generateStructDeclaration(for: "\(name)Object",
                                                           with: properties, isRequired: jsonType.required)
                memberDecls.append(MemberBlockItemListSyntax { structDecl })
            }
        }

        let enumDecl = EnumDeclSyntax(modifiers: DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.public)) },
                                      name: .identifier(name.toSwiftAWSClassCase().toSwiftClassCase()),
                                      inheritanceClause: enumInheritance) {
            MemberBlockItemListSyntax {
                for enumDecl in enumDecls {
                    enumDecl
                }
            }.with(\.leadingTrivia, .newlines(1))
        }.with(\.leadingTrivia, .newlines(2))

        memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        memberDecls.append(MemberBlockItemListSyntax { enumDecl })
        for structDecl in structDecls {
            memberDecls.append(MemberBlockItemListSyntax { structDecl })
        }

        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
}
