//
//  File.swift
//  
//
//  Created by Esraa Eid on 03/07/2024.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

extension DeploymentDescriptorGenerator {
    
    func handleTypeCase(name: String, jsonType: JSONType, decls: inout [MemberBlockItemListSyntax], enumDecls: inout [MemberBlockItemListSyntax], isRequired: Bool) { // clean this
        
        if jsonType.hasEnum() {
            enumDecls.append(generateEnumDeclaration(for: name, with: jsonType.enumValues() ?? ["No case found!"]))
            decls.append(generateEnumPropertyDeclaration(for: name, with: jsonType, isRequired: isRequired))
        } else {
            decls.append(generateRegularPropertyDeclaration(for: name, with: jsonType, isRequired: isRequired))
        }
    }
    
    func generateDeclarations(from dictionary: [String: JSONUnionType]?, into decls: inout [MemberBlockItemListSyntax], enumDecls: inout [MemberBlockItemListSyntax], codingKeys: inout [String], isRequired: [String]?) {
     
        
        guard let dictionary = dictionary else { return }
        for (name, value) in dictionary {
            print("➡️ I am Generate Declaration processing: \(name)")
            let required = isRequired?.contains(name) ?? false
            
            if case .type(let jsonType) = value {
                print("➡️ I am Generate Declaration with 'type' for: \(name)")
                // Check for patternProperties
                if let objectSchema = value.jsonType().object(), let patternProperties = objectSchema.patternProperties {
                    print("➡️ I am Generate Declaration with 'type' and 'object' and 'patternProperties' for: \(name)")
                    
                    for (pattern, patternValue) in patternProperties {
                          
                        if case .anyOf(let jsonTypes) = patternValue {
                            print("➡️ I am Generate Declaration with 'patternProperties' and 'hasAnyOf' for: \(name)")
                            handleAnyOfCase(name: name, types: jsonTypes, decls: &decls, isRequired: required)
                            codingKeys.append(name)
                        } else if case .type(let jsonTypes) = patternValue {
                            print("➡️ I am Generate Declaration with 'patternProperties' and 'type' for: \(name)")
                            handleTypeCase(name: name, type: jsonTypes, decls: &decls, isRequired: required)
                            codingKeys.append(name)
                        }
                    }
                } else  if let objectSchema = value.jsonType().stringSchema() {
                    print("➡️ I am Generate Declaration with 'type' and 'stringSchema' for: \(name)")
                    handleTypeCase(name: name, jsonType: jsonType, decls: &decls, enumDecls: &enumDecls,
                                   isRequired: required)
                    codingKeys.append(name)
                } else if jsonType.hasEnum() {
                    print("➡️ I am Generate Declaration with 'type' and 'Enum' for: \(name)")
                    handleTypeCase(name: name, jsonType: jsonType, decls: &decls, enumDecls: &enumDecls,
                                   isRequired: required)
                    codingKeys.append(name)
                }
            } else {
                print("➡️ I am Generate Declaration and couldn't found 'type' for: \(name)")
            }
        }
      
    }
}
