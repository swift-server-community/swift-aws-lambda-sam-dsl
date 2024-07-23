
[ ] Header license in all source files

[ ] Generate header comment in generated code (code exists, but is not called) 

[ ] Sync Package.swift and Package@swift-5.10.swift

[ ] Include unit tests 

[ ] Avoid code duplication
    
    Examples :

	      let enumInheritance = InheritanceClauseSyntax {
            InheritedTypeSyntax(type: TypeSyntax("Codable"))
            InheritedTypeSyntax(type: TypeSyntax("Sendable"))
        }

    \.leadingTrivia, .newlines(2)


  [ ] Do we really need 3 enum generation structs ?  
      `generateEnumCodingKeys` `generateEnumPropertyDeclaration` `generateEnumDeclaration`
  
  [ ] What is the difference between  
      `RegularProperty` and `Properties`

  [ ] add function header comments 

  [ ] soundness.sh should run without errors