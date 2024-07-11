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
            let swiftType = jsonType.swiftType(for: name)
            decls.append(generateRegularPropertyDeclaration(for: name, with: swiftType, isRequired: isRequired))
        }
    }
    
    func generateDeclarations(from dictionary: [String: JSONUnionType]?, into decls: inout [MemberBlockItemListSyntax], enumDecls: inout [MemberBlockItemListSyntax], codingKeys: inout [String], isRequired: [String]?) {
     
        
        guard let dictionary = dictionary else { return }
        for (name, value) in dictionary {
            print("➡️ Processing key: \(name)")
            let required = isRequired?.contains(name) ?? false
            
            if case .type(let jsonType) = value {
                // Check for patternProperties
                if let objectSchema = value.jsonType().object(), let patternProperties = objectSchema.patternProperties {
                    for (pattern, patternValue) in patternProperties {
                        print("🥳 Found patternProperty with pattern: \(pattern), value: \(patternValue)")
                        
                        // Check for anyOf within patternProperties
                        if patternValue.hasAnyOf() {
                            print("🥳 Found anyOf within patternProperty for pattern: \(pattern)")
                            if case .anyOf(let jsonTypes) = patternValue {
                                print("🥳 Handling anyOf case for patternProperty with \(jsonTypes.count) elements")
                                handleAnyOfCase(name: name, value: patternValue, decls: &decls, isRequired: required)
                                codingKeys.append(name)
                            }
                        }  else {
                            handleTypeCase(name: name, jsonType: jsonType, decls: &decls, enumDecls: &enumDecls,
                                           isRequired: required)
                            codingKeys.append(name)
                        }
                    }
                } else  if let objectSchema = value.jsonType().stringSchema() {
                    handleTypeCase(name: name, jsonType: jsonType, decls: &decls, enumDecls: &enumDecls,
                                   isRequired: required)
                    codingKeys.append(name)
                } else if jsonType.hasEnum() {
                    handleTypeCase(name: name, jsonType: jsonType, decls: &decls, enumDecls: &enumDecls,
                                   isRequired: required)
                    codingKeys.append(name)
                }
            } else {
                print("❓ No match for key: \(name)")
            }
        }
      
    }
}
