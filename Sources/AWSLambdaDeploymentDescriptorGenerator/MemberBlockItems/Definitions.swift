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
            self.logger.info("Processing key: \(name) in definitions declaration")

            if case .type(let jsonType) = value {
                self.logger.info("Processing type of value for key: \(name) in definitions declaration")

                if let objectSchema = value.jsonType().object(), let properties = objectSchema.properties {
                    let structDecl = generateStructDeclaration(for: name, with: properties, isRequired: jsonType.required)
                    structDecls.append(structDecl)
                    self.logger.info("Generating struct declaration for object schema with properties for key: \(name)")
                }
            }
        }
        return structDecls
    }
}
