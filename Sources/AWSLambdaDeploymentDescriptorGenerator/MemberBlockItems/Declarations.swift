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
    
    func handleTypeCase(name: String, jsonType: JSONType, decls: inout [MemberBlockItemListSyntax], enumDecls: inout [MemberBlockItemListSyntax]) { // clean this
        if jsonType.hasEnum() {
            enumDecls.append(generateEnumDeclaration(for: name, with: jsonType.enumValues() ?? ["No case found!"]))
            decls.append(generateEnumPropertyDeclaration(for: name, with: jsonType))
        } else if let objectSchema = jsonType.object(), let properties = objectSchema.properties {
            let structDecl = generateStructDeclaration(for: name, with: properties)
            decls.append(MemberBlockItemListSyntax{ structDecl })
        } else {
            decls.append(generateRegularPropertyDeclaration(for: name, with: jsonType))
        }
    }
    
    func generateDeclarations(from dictionary: [String: JSONUnionType]?, into decls: inout [MemberBlockItemListSyntax], enumDecls: inout [MemberBlockItemListSyntax], codingKeys: inout [String]) {
        guard let dictionary = dictionary else { return }
        for (name, value) in dictionary {
            print("➡️ Processing key: \(name)")
            
            
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
                                handleAnyOfCase(name: name, value: patternValue, decls: &decls)
                                codingKeys.append(name)
                            }
                        }  else {
                            handleTypeCase(name: name, jsonType: jsonType, decls: &decls, enumDecls: &enumDecls)
                            codingKeys.append(name)
                        }
                    }
                } else  if let objectSchema = value.jsonType().stringSchema() {
                    handleTypeCase(name: name, jsonType: jsonType, decls: &decls, enumDecls: &enumDecls)
                    codingKeys.append(name)
                } else if jsonType.hasEnum() {
                    handleTypeCase(name: name, jsonType: jsonType, decls: &decls, enumDecls: &enumDecls)
                    codingKeys.append(name)
                }
            } else {
                print("❓ No match for key: \(name)")
            }
        }
    }
}
