/**

 TODO:

 1. read `samtranslator schema.json`
 2. generate `../DeploymentDescriptor.swift`

 */
import Foundation
import HummingbirdMustache
import Logging
import SwiftSyntax
import SwiftSyntaxBuilder

public protocol DeploymentDescriptorGeneratorCommand {
    var inputFile: String? { get }
    var configFile: String? { get }
    var prefix: String? { get }
    var outputFolder: String { get }
    var inputFolder: String? { get }
    var endpoints: String { get }
    var module: String? { get }
    var output: Bool { get }
    var logLevel: String? { get }
}

public struct DeploymentDescriptorGenerator {
    struct FileError: Error {
        let filename: String
        let error: Error
    }

    static var rootPath: String {
        #file
            .split(separator: "/", omittingEmptySubsequences: false)
            .dropLast(3)
            .map { String(describing: $0) }
            .joined(separator: "/")
    }

    public func generate() {
        // generate code here

        let filePath = Bundle.module.path(forResource: "SamTranslatorSchema", ofType: "json") ?? ""
        let url = URL(fileURLWithPath: filePath)

        do {
            let schemaData = try Data(contentsOf: url)
            do {
                _ = try self.analyzeSAMSchema(from: schemaData)
                // access the schema information
            } catch {
                print("Error analyzing schema: \(error)")
            }

        } catch {
            print("Error getting schemaData contents of URL: \(error)")
        }
    }

    // MARK: - generateWithSwiftOpenapi

    public func generateWithSwiftOpenAPI() {}

    // MARK: - generateWithSwiftSyntax

    func writeGeneratedStructWithSwiftSyntax() {
        let exampleSchema = TypeSchema(
            typeName: "Example",
            properties: [
                TypeSchema.Property(name: "firstName", type: "String"),
                TypeSchema.Property(name: "lastName", type: "String"),
            ],
            subTypes: [
                TypeSchema(
                    typeName: "SubType",
                    properties: [
                        TypeSchema.Property(name: "subProperty1", type: "Int"),
                    ],
                    subTypes: []
                ),
            ]
        )
        self.generateTypeSchema(for: exampleSchema)
    }

    func generateDecoderInitializer() -> InitializerDeclSyntax {
        let parameters = FunctionParameterClauseSyntax {
            FunctionParameterListSyntax {
                FunctionParameterSyntax(
                    modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .identifier("from"))] },
                    firstName: .identifier("decoder"),
                    colon: .colonToken(trailingTrivia: .space),
                    type: TypeSyntax(IdentifierTypeSyntax(name: .identifier("Decoder")))
                )
            }
        }

        return InitializerDeclSyntax(
            modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
            signature: FunctionSignatureSyntax(
                parameterClause: parameters,
                effectSpecifiers: FunctionEffectSpecifiersSyntax(throwsSpecifier: .keyword(.throws))
            ),
            body: CodeBlockSyntax {
                CodeBlockItemListSyntax {
                    // let container = try decoder.container(keyedBy: CodingKeys.self)
                    CodeBlockItemSyntax(item: .decl(
                        DeclSyntax(
                            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                                PatternBindingSyntax(
                                    pattern: PatternSyntax("container"),
                                    initializer:
                                    InitializerClauseSyntax(
                                        equal: .equalToken(trailingTrivia: .space),
                                        value:
                                        ExprSyntax(
                                            TryExprSyntax(
                                                tryKeyword: .keyword(.try),
                                                expression:
                                                FunctionCallExprSyntax(
                                                    calledExpression: ExprSyntax(MemberAccessExprSyntax(
                                                        base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("decoder"))),
                                                        name: .identifier("container")
                                                    )),
                                                    leftParen: .leftParenToken(),
                                                    arguments: LabeledExprListSyntax {
                                                        LabeledExprSyntax(
                                                            label: .identifier("keyedBy"),
                                                            colon: .colonToken(trailingTrivia: .space),
                                                            expression: ExprSyntax(
                                                                MemberAccessExprSyntax(
                                                                    base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("CodingKeys"))),
                                                                    name: .identifier("self")
                                                                )
                                                            )
                                                        )
                                                    },
                                                    rightParen: .rightParenToken()
                                                )
                                            ))
                                    )
                                )
                            }
                        )
                    ))

                    // self.typeName = try container.decode(String.self, forKey: .typeName)
                    CodeBlockItemSyntax(item: .expr(
                        ExprSyntax(
                            InfixOperatorExprSyntax(
                                leftOperand: ExprSyntax(
                                    MemberAccessExprSyntax(
                                        base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("self"))),
                                        name: "typeName"
                                    )),
                                operator: ExprSyntax(BinaryOperatorExprSyntax(operator: .equalToken())),
                                rightOperand: ExprSyntax(
                                    TryExprSyntax(
                                        tryKeyword: .keyword(.try),
                                        expression: FunctionCallExprSyntax(
                                            calledExpression: ExprSyntax(MemberAccessExprSyntax(
                                                base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("container"))),
                                                name: .identifier("decode")
                                            )),
                                            leftParen: .leftParenToken(),
                                            arguments: LabeledExprListSyntax {
                                                LabeledExprSyntax(
                                                    expression: ExprSyntax(
                                                        MemberAccessExprSyntax(
                                                            base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("String"))),
                                                            name: .identifier("self")
                                                        )
                                                    )
                                                )
                                                LabeledExprSyntax(
                                                    label: .identifier("forKey"),
                                                    colon: .colonToken(trailingTrivia: .space),
                                                    expression: ExprSyntax(
                                                        MemberAccessExprSyntax(
                                                            name: "typeName"
                                                        )
                                                    )
                                                )
                                            },
                                            rightParen: .rightParenToken()
                                        )
                                    )
                                ) // end of InfixOperatorExprSyntax
                            )
                        )))

                    // self.properties = try container.decode([Property].self, forKey: .properties)
                    CodeBlockItemSyntax(item: .expr(
                        ExprSyntax(
                            InfixOperatorExprSyntax(
                                leftOperand: ExprSyntax(
                                    MemberAccessExprSyntax(
                                        base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("self"))),
                                        name: "properties"
                                    )),
                                operator: ExprSyntax(BinaryOperatorExprSyntax(operator: .equalToken())),
                                rightOperand: ExprSyntax(
                                    TryExprSyntax(
                                        tryKeyword: .keyword(.try),
                                        expression: FunctionCallExprSyntax(
                                            calledExpression: ExprSyntax(MemberAccessExprSyntax(
                                                base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("container"))),
                                                name: .identifier("decode")
                                            )),
                                            leftParen: .leftParenToken(),
                                            arguments: LabeledExprListSyntax {
                                                LabeledExprSyntax(
                                                    expression: ExprSyntax(
                                                        MemberAccessExprSyntax(
                                                            base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("[Property]"))),
                                                            name: .identifier("self")
                                                        )
                                                    )
                                                )
                                                LabeledExprSyntax(
                                                    label: .identifier("forKey"),
                                                    colon: .colonToken(trailingTrivia: .space),
                                                    expression: ExprSyntax(
                                                        MemberAccessExprSyntax(
                                                            name: "properties"
                                                        )
                                                    )
                                                )
                                            },
                                            rightParen: .rightParenToken()
                                        )
                                    )
                                ) // end of InfixOperatorExprSyntax
                            )
                        ))
                    )

                    // self.subTypes = try container.decode([TypeSchema].self, forKey: .subTypes)
                    CodeBlockItemSyntax(item: .expr(
                        ExprSyntax(
                            InfixOperatorExprSyntax(
                                leftOperand: ExprSyntax(
                                    MemberAccessExprSyntax(
                                        base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("self"))),
                                        name: "subTypes"
                                    )),
                                operator: ExprSyntax(BinaryOperatorExprSyntax(operator: .equalToken())),
                                rightOperand: ExprSyntax(
                                    TryExprSyntax(
                                        tryKeyword: .keyword(.try),
                                        expression: FunctionCallExprSyntax(
                                            calledExpression: ExprSyntax(MemberAccessExprSyntax(
                                                base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("container"))),
                                                name: .identifier("decode")
                                            )),
                                            leftParen: .leftParenToken(),
                                            arguments: LabeledExprListSyntax {
                                                LabeledExprSyntax(
                                                    expression: ExprSyntax(
                                                        MemberAccessExprSyntax(
                                                            base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("[Example]"))),
                                                            name: .identifier("self")
                                                        )
                                                    )
                                                )
                                                LabeledExprSyntax(
                                                    label: .identifier("forKey"),
                                                    colon: .colonToken(trailingTrivia: .space),
                                                    expression: ExprSyntax(
                                                        MemberAccessExprSyntax(
                                                            name: "subTypes"
                                                        )
                                                    )
                                                )
                                            },
                                            rightParen: .rightParenToken()
                                        )
                                    )
                                ) // end of InfixOperatorExprSyntax
                            )
                        ))
                    )
                }
            }
        )
    }

    func generateTypeSchema(for schema: TypeSchema) {
        // MARK: - Inheritance

        let structInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Decodable"))
            InheritedTypeSyntax(type: TypeSyntax("Equatable"))
        }

        let enumInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("String"))
            InheritedTypeSyntax(type: TypeSyntax("CodingKey"))
        }

        // MARK: - Initializer

        let parameters = FunctionParameterClauseSyntax {
            FunctionParameterListSyntax {
                FunctionParameterSyntax(
                    firstName: .identifier("typeName"),
                    colon: .colonToken(trailingTrivia: .space),
                    type: TypeSyntax("String")
                )
                FunctionParameterSyntax(
                    firstName: .identifier("properties"),
                    colon: .colonToken(trailingTrivia: .space),
                    type: ArrayTypeSyntax(element: TypeSyntax("Property"))
                )
                FunctionParameterSyntax(
                    firstName: .identifier("subTypes"),
                    colon: .colonToken(trailingTrivia: .space),
                    type: ArrayTypeSyntax(element: TypeSyntax("\(raw: schema.typeName)"))
                )
            }
        }

        let structInit = InitializerDeclSyntax(
            signature: FunctionSignatureSyntax(
                parameterClause: parameters
            ),
            body: CodeBlockSyntax {
                CodeBlockItemListSyntax {
                    CodeBlockItemSyntax(item: .expr(
                        ExprSyntax(
                            InfixOperatorExprSyntax(
                                leftOperand: ExprSyntax(
                                    MemberAccessExprSyntax(
                                        base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("self"))),
                                        name: "typeName"
                                    )),
                                operator: ExprSyntax(BinaryOperatorExprSyntax(operator: .equalToken())),
                                rightOperand: ExprSyntax(
                                    DeclReferenceExprSyntax(baseName: .identifier("typeName"))
                                )
                            )
                        )
                    ))

                    CodeBlockItemSyntax(item: .expr(
                        ExprSyntax(
                            InfixOperatorExprSyntax(
                                leftOperand: ExprSyntax(
                                    MemberAccessExprSyntax(
                                        base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("self"))),
                                        name: "properties"
                                    )),
                                operator: ExprSyntax(BinaryOperatorExprSyntax(operator: .equalToken())),
                                rightOperand: ExprSyntax(
                                    DeclReferenceExprSyntax(baseName: .identifier("properties"))
                                )
                            )
                        )
                    ))

                    CodeBlockItemSyntax(item: .expr(
                        ExprSyntax(
                            InfixOperatorExprSyntax(
                                leftOperand: ExprSyntax(
                                    MemberAccessExprSyntax(
                                        base: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("self"))),
                                        name: "subTypes"
                                    )),
                                operator: ExprSyntax(BinaryOperatorExprSyntax(operator: .equalToken())),
                                rightOperand: ExprSyntax(
                                    DeclReferenceExprSyntax(baseName: .identifier("subTypes"))
                                )
                            )
                        )
                    ))
                }
            }
        )

        let source = SourceFileSyntax {
            // MARK: - Type Schema Struct

            StructDeclSyntax(modifiers: DeclModifierListSyntax { [DeclModifierSyntax(name: .keyword(.public))] },
                             name: "\(raw: schema.typeName)",
                             inheritanceClause: structInheritance) {
                // MARK: - Main Struct Kyes

                MemberBlockItemListSyntax {
                    MemberBlockItemSyntax(decl: DeclSyntax("let typeName: String"))
                    MemberBlockItemSyntax(decl:
                        VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                            PatternBindingSyntax(pattern: PatternSyntax("properties"),
                                                 typeAnnotation:
                                                 TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space),
                                                                      type:
                                                                      ArrayTypeSyntax(element: TypeSyntax("Property"))))
                        })

                    MemberBlockItemSyntax(decl: DeclSyntax("let subTypes: [\(raw: schema.typeName)]"))
                    MemberBlockItemSyntax(decl: structInit)
                    MemberBlockItemSyntax(decl: self.generateDecoderInitializer())
                        .with(\.leadingTrivia, .newlines(2))
                }

                // MARK: - Property Struct

                StructDeclSyntax(modifiers: DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.public)) },
                                 name: "Property",
                                 inheritanceClause: structInheritance) {
                    MemberBlockItemListSyntax {
                        // Property: name
                        MemberBlockItemSyntax(decl:
                            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                                PatternBindingSyntax(pattern: PatternSyntax("name"),
                                                     typeAnnotation:
                                                     TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space),
                                                                          type:
                                                                          OptionalTypeSyntax(
                                                                              wrappedType: TypeSyntax(IdentifierTypeSyntax(name: .identifier("String")))
                                                                          )))
                            })

                        // Property: type
                        MemberBlockItemSyntax(decl:
                            VariableDeclSyntax(bindingSpecifier: .keyword(.let)) {
                                PatternBindingSyntax(pattern: PatternSyntax("type"),
                                                     typeAnnotation:
                                                     TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space),
                                                                          type:
                                                                          TypeSyntax(IdentifierTypeSyntax(name: .identifier("String")))))
                            })
                    }
                }.with(\.leadingTrivia, .newlines(2))

                // MARK: - Enum

                EnumDeclSyntax(modifiers: DeclModifierListSyntax { DeclModifierSyntax(name: .keyword(.private)) },
                               name: .identifier("CodingKeys"),
                               inheritanceClause: enumInheritance) {
                    MemberBlockItemListSyntax {
                        EnumCaseDeclSyntax {
                            EnumCaseElementListSyntax {
                                EnumCaseElementSyntax(
                                    name: .identifier("typeName"),
                                    rawValue: InitializerClauseSyntax(
                                        equal: .equalToken(trailingTrivia: .space),
                                        value: ExprSyntax(StringLiteralExprSyntax(content: "typeName"))
                                    )
                                )
                            }
                        }.with(\.leadingTrivia, .newlines(1))

                        EnumCaseDeclSyntax {
                            EnumCaseElementListSyntax {
                                EnumCaseElementSyntax(name: "properties")
                            }
                        }.with(\.leadingTrivia, .newlines(1))

                        EnumCaseDeclSyntax {
                            EnumCaseElementListSyntax {
                                EnumCaseElementSyntax(name: "subTypes")
                            }
                        }.with(\.leadingTrivia, .newlines(1))
                    }
                }.with(\.leadingTrivia, .newlines(2)) // end of enum
            }.with(\.leadingTrivia, .newlines(1)) // end of Type Schema Struct
        } // end of SourceFile

        let renderedStruct = source.formatted().description
        print(renderedStruct)
        self.writeGeneratedResultToFile(renderedStruct)
    }

    // MARK: - generateWithSwiftMustache

    public func generateWithSwiftMustache() {
        do {
            let library = try Templates.createLibrary()
            let template = library.getTemplate(named: "structTemplate")

            // TODO: Decode JSON here
            let properties: [TypeSchema.Property] = [
                .init(name: "id", type: "Int"),
                .init(name: "name", type: "String"),
            ]

            let schema = TypeSchema(typeName: "Hello",
                                    properties: properties,
                                    subTypes: [])

            let modelContext: [String: Any] = [
                "scope": "",
                "object": "struct",
                "name": schema.typeName,
                "shapeProtocol": "Codable",
                "typeName": schema.typeName,
                "properties": schema.properties.map { property in
                    [
                        "scope": "",
                        "variable": property.name ?? "",
                        "type": property.type,
                        "isOptional": property.type.contains("?"),
                        "last": property == schema.properties.last,
                    ]
                },
            ] as [String: Any]

            if let template = template {
                let renderedStruct = template.render(modelContext)
                print(renderedStruct)
                self.writeGeneratedResultToFile(renderedStruct)
            } else {
                print("Error: Template 'structTemplate' not found")
            }
        } catch {
            print("Error generating Swift struct: \(error)")
        }
    }

    func writeGeneratedResultToFile(_ result: String) {
        let projectDirectory = "\(DeploymentDescriptorGenerator.rootPath)"
        let filePath = projectDirectory + "/Sources/AWSLambdaDeploymentDescriptorGenerator/dummyGenerated.swift"

        let directoryPath = (filePath as NSString).deletingLastPathComponent
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDirectory) {
            print("Error: Directory does not exist.")
            return
        }

        let writable = FileManager.default.isWritableFile(atPath: directoryPath)
        if !writable {
            print("Error: No write permissions for the directory.")
            return
        }

        do {
            if try result.writeIfChanged(toFile: filePath) {
                print("Success Wrote ✅")
            }
        } catch {
            print("Error writing file: \(error)")
        }
    }

    func analyzeSAMSchema(from jsonData: Data) throws -> JSONSchema {
        let decoder = JSONDecoder()
        let schema = try decoder.decode(JSONSchema.self, from: jsonData)

        print("Schema Information:")
        print("  - Schema URL: \(schema.schema)")
        print("  - Overall Type: \(schema.type ?? [.null])")

        if let properties = schema.properties {
            print("\n  Properties:")
            for (name, propertyType) in properties {
                print("    - \(name): \(propertyType)")
            }
        }

        if let definitions = schema.definitions {
            print("\n  Definitions:")
            for (name, definitionType) in definitions {
                print("    - \(name): \(definitionType)")
            }
        }

        return schema
    }
}

extension String {
    /// Only writes to file if the string contents are different to the file contents. This is used to stop XCode rebuilding and reindexing files unnecessarily.
    /// If the file is written to XCode assumes it has changed even when it hasn't
    /// - Parameters:
    ///   - toFile: Filename
    ///   - atomically: make file write atomic
    ///   - encoding: string encoding
    func writeIfChanged(toFile: String) throws -> Bool {
        do {
            let original = try String(contentsOfFile: toFile)
            guard original != self else { return false }
        } catch {
            print(error)
        }
        try write(toFile: toFile, atomically: true, encoding: .utf8)
        return true
    }
}

public class HBMustacheTemplateAdapter: TemplateRendering {
    private let template: HBMustacheTemplate

    public init(string: String) throws {
        self.template = try HBMustacheTemplate(string: string)
    }

    public func render(_ object: Any?) -> String {
        self.template.render(object)
    }
}

class MockTemplate: TemplateRendering {
    private let templateString: String

    init(string: String) {
        self.templateString = string
    }

    func render(_: Any?) -> String {
        self.templateString
    }
}

class MockTemplateLibrary: TemplateLibrary {
    private var templates: [String: MockTemplate] = [:]

    func register(_ template: MockTemplate, named name: String) {
        self.templates[name] = template
    }

    func getTemplate(named name: String) -> TemplateRendering? {
        self.templates[name]
    }
}

public class HBMustacheLibraryAdapter: TemplateLibrary {
    private var templates: [String: HBMustacheTemplateAdapter] = [:]

    public func register(_ template: HBMustacheTemplateAdapter, named name: String) {
        self.templates[name] = template
    }

    public func getTemplate(named name: String) -> TemplateRendering? {
        self.templates[name]
    }
}
