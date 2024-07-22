//
//
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    func generateDefinitionsDeclaration(from dictionary: [String: JSONUnionType]?) -> [StructDeclSyntax] {
        guard let dictionary = dictionary else { return [] }
        var structDecls: [StructDeclSyntax] = []

        for (name, value) in dictionary {
            print("🎯 I am Definitions Declaration and Processing key: \(name)")

            if case .type(let jsonType) = value {
                // Check for object schema with properties
                print("🎯 I am Definitions Declaration inside type of value: \(name)")
                if let objectSchema = value.jsonType().object(), let properties = objectSchema.properties {
                    let structDecl = generateStructDeclaration(for: name, with: properties, isRequired: jsonType.required)
                    structDecls.append(structDecl)
                    print("🎯 I am Definitions Declaration inside properties for object and will appedna struct for that object: \(name)")
                }
            }
        }
        return structDecls
    }
}
