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
        var enumDecls = [MemberBlockItemListSyntax]()
        var swiftType = type.swiftType(for: name)

        if let objectSchema = type.object() {
            self.logger.info("Generating property declaration for an object type: \(name)")

            if let properties = objectSchema.properties {
                self.logger.info("Object \(name) has properties, generating struct declaration.")

                let structDecl = generateStructDeclaration(for: name, with: properties, isRequired: type.required)
                memberDecls.append(MemberBlockItemListSyntax { structDecl }.with(\.leadingTrivia, .newlines(2)))

                let variableDecl = generateVariableDecl(for: name, with: name.toSwiftAWSClassCase(), isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })

            } else {
                self.logger.info("Object \(name) does not have properties, generating empty struct declaration.")
                let propertyDecl = generateStructDeclaration(for: name, with: [:], isRequired: type.required)
                memberDecls.append(MemberBlockItemListSyntax { propertyDecl }.with(\.leadingTrivia, .newlines(2)))

                let variableDecl = generateVariableDecl(for: name, with: swiftType, isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })
            }
        } else if let reference = type.reference {
            self.logger.info("Generating property declaration for a reference type: \(name)")
            swiftType = reference.toSwiftAWSClassCase()
            let variableDecl = generateVariableDecl(for: name, with: swiftType, isRequired: isRequired)
            memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        } else if let arrayValue = type.arraySchema() {
            self.logger.info("Generating property declaration for an array type: \(name)")

            if let jsonType = arrayValue.items {
                if let objectValue = jsonType.object() {
                    self.logger.info("Array \(name) contains objects, generating struct declaration.")
                    let structDecl = generateStructDeclaration(for: name,
                                                               with: objectValue.properties ?? [:], isRequired: type.required)
                    memberDecls.append(MemberBlockItemListSyntax { structDecl }.with(\.leadingTrivia, .newlines(2)))

                } else if let stringValue = jsonType.stringSchema() {
                    self.logger.info("Array \(name) contains strings.")
                    swiftType = "[\(jsonType.swiftType(for: name))]"
                }
            } else {
                swiftType = "[String]"
                self.logger.info("Array \(name) does not have a defined item type, defaulting to [String].")
            }
            let variableDecl = generateVariableDecl(for: name, with: swiftType, isRequired: isRequired)
            memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        } else {
            self.logger.info("Generating property declaration for a basic type: \(name)")

            if let arrayOfType = type.type, arrayOfType.count > 1 {
                self.logger.info("\(name) has multiple types defined, generating enum declaration.")

                memberDecls.append(generateArrayOfTypesDeclaration(for: name, with: arrayOfType, isRequired: isRequired))
            } else {
                let variableDecl = generateVariableDecl(for: name, with: swiftType, isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })
            }
        }

        return MemberBlockItemListSyntax {
            for memberDecl in memberDecls {
                memberDecl
            }
        }
    }
}
