//
//  
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
   
    func handleAnyOfCase(name: String, types: [JSONType], decls: inout [MemberBlockItemListSyntax], isRequired: Bool) {
        print("🧞‍♀️ I am 'anyOf' case for: \(name)")
        decls.append(generateResourcesPropertyDeclaration(for: name, with: types, isRequired: isRequired))
    }
    

    
    func handleTypeCase(name: String, type: JSONType, decls: inout [MemberBlockItemListSyntax], isRequired: Bool) {
        print("🧞‍♀️ I am 'type' case for: \(name)")
        decls.append(generatePatternPropertyDeclaration(for: name, with: type, isRequired: isRequired))
        
    }
}
