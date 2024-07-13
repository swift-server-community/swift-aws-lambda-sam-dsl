//
//  
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
   
    func handleAnyOfCase(name: String, value: JSONUnionType, decls: inout [MemberBlockItemListSyntax], isRequired: Bool) {
        if case .anyOf(let jsonTypes) = value {
            if name == "Resources" {
                print("🧞‍♀️ -------------- \((name))")
                decls.append(generateResourcesPropertyDeclaration(for: name, with: jsonTypes, isRequired: isRequired))
            }
        }
    }
}
