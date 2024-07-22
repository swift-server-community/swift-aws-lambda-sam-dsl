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

        // TODO: we need to handle this with function to verify the name matches the pattern

        if let objectSchema = type.object() {
            self.logger.info("🌍 I am Regular Property with 'object' for: \(name)")
            if let properties = objectSchema.properties {
                print("🌍 I am Regular Property object with 'properties' for: \(name)")
                let structDecl = generateStructDeclaration(for: name, with: properties, isRequired: type.required)
                memberDecls.append(MemberBlockItemListSyntax { structDecl }.with(\.leadingTrivia, .newlines(2)))

                let variableDecl = generateVariableDecl(for: name, with: name.toSwiftAWSClassCase(), isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })

            } else {
                print("🌍 I am Regular Property object not 'properties' nor 'patternProperties' for: \(name)")
                let propertyDecl = generateStructDeclaration(for: name, with: [:], isRequired: type.required)
                memberDecls.append(MemberBlockItemListSyntax { propertyDecl }.with(\.leadingTrivia, .newlines(2)))

                let variableDecl = generateVariableDecl(for: name, with: swiftType, isRequired: isRequired)
                memberDecls.append(MemberBlockItemListSyntax { variableDecl })
            }
        } else if let reference = type.reference {
            print("🌍 I am Regular Property with 'reference' for: \(name)")
            swiftType = reference.toSwiftAWSClassCase()
            let variableDecl = generateVariableDecl(for: name, with: swiftType, isRequired: isRequired)
            memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        } else if let arrayValue = type.arraySchema() {
            print("🌍 I am Regular Property with 'arraySchema' for: \(name)")

            if let jsonType = arrayValue.items {
                if let objectValue = jsonType.object() {
                    print("🌍 I am object with 'arraySchema' for: \(name)")
                    let structDecl = generateStructDeclaration(for: name,
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
            let variableDecl = generateVariableDecl(for: name, with: swiftType, isRequired: isRequired)
            memberDecls.append(MemberBlockItemListSyntax { variableDecl })
        } else {
            print("🌍 I am Regular Property not 'object' nor 'reference' for: \(name)")
            if let arrayOfType = type.type, arrayOfType.count > 1 {
                print("🌍 I am Regular Property and have arrayOfType for: \(name)")
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
