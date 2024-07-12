

import Foundation

// https://github.com/soto-project/soto-codegenerator/blob/43477dcdced99513b3281e129b225ee0e38a57e8/Sources/SotoCodeGeneratorLib/String.swift#L18
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

    func withFirstLetterUppercased() -> String {
        if let firstLetter = self.first {
            return firstLetter.uppercased() + self.dropFirst()
        } else {
            return self
        }
    }

    func withFirstLetterLowercased() -> String {
        if let firstLetter = self.first {
            return firstLetter.lowercased() + self.dropFirst()
        } else {
            return self
        }
    }

    public func toSwiftLabelCase(isEnum: Bool = false) -> String {
        let snakeCase = self.replacingOccurrences(of: "-", with: "_")
        if snakeCase.allLetterIsSnakeUppercased() {
            return snakeCase.lowercased().camelCased(capitalize: false, isEnum: isEnum)
        }
        return snakeCase.camelCased(capitalize: false, isEnum: isEnum)
    }

    public func toSwiftVariableCase() -> String {
        self.replacingOccurrences(of: ".", with: "")
            .toSwiftLabelCase().reservedwordEscaped()
    }

    public func toSwiftClassCase() -> String {
        self.replacingOccurrences(of: "-", with: "_")
            .camelCased(capitalize: true)
            .reservedwordEscaped()
    }

    public func toSwiftRegionEnumCase() -> String {
        self.replacingOccurrences(of: "-", with: "")
    }
    
    public func toSwiftAWSEnumCase() -> String {
        let components = self.split(separator: "::")
        guard components.count >= 2 else { return self }        
        let lastTwoComponents = components.suffix(2)
        let capitalizedComponents = lastTwoComponents.map { component in
            return component.prefix(1).uppercased() + component.dropFirst()
        }
        return capitalizedComponents.joined().replacingOccurrences(of: ".", with: "")
    }
    
    public func toSwiftAWSClassCase() -> String {
        let components = self.split(separator: "::")
        guard components.count >= 2 else { return self }
        let lastTwoComponents = components.suffix(2)
        let capitalizedComponents = lastTwoComponents.map { component in
            return component.prefix(1).uppercased() + component.dropFirst()
        }
        
        return capitalizedComponents.joined().replacingOccurrences(of: ".", with: "")
    }

    public func toSwiftEnumCase() -> String {
        self
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: ":", with: "_")
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "(", with: "_")
            .replacingOccurrences(of: ")", with: "_")
            .replacingOccurrences(of: "*", with: "all")
            .replacingOccurrences(of: ">", with: "")
            .replacingOccurrences(of: "<", with: "")
            .toSwiftLabelCase(isEnum: true)
            .reservedwordEscaped()
    }

    public func tagStriped() -> String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    func camelCased(capitalize: Bool, isEnum: Bool = false) -> String {
        let items = self.split(separator: "_")
        let firstWord = items.first!
        let firstWordProcessed: String
        if capitalize {
            firstWordProcessed = firstWord.upperFirst()
        } else {
            firstWordProcessed = firstWord.lowerFirstWord()
        }
        let remainingItems = items.dropFirst().map { word -> String in
            if word.allLetterIsSnakeUppercased() {
                return String(word)
            }
            return word.capitalized
        }
        if isEnum {
            return firstWordProcessed + "_" + remainingItems.joined(separator: "_")
        } else {
            return firstWordProcessed + remainingItems.joined()
        }
    }

    func reservedwordEscaped() -> String {
        if self == "self" {
            return "_self"
        }
        if swiftReservedWords.contains(self) {
            return "`\(self)`"
        }
        return self
    }
}

extension StringProtocol {
    func allLetterIsNumeric() -> Bool {
        let characters = self.replacingOccurrences(of: "-", with: "")
        for c in characters {
            if !c.isNumber {
                return false
            }
        }
        return true
    }

    fileprivate func allLetterIsSnakeUppercased() -> Bool {
        for c in self {
            if !c.isSnakeUppercase() {
                return false
            }
        }
        return true
    }

    private func lowerFirst() -> String {
        String(self[startIndex]).lowercased() + self[index(after: startIndex)...]
    }

    fileprivate func upperFirst() -> String {
        String(self[self.startIndex]).uppercased() + self[index(after: startIndex)...]
    }
    
    fileprivate func upperLastWord() -> String {
        guard let lastSeparator = self.lastIndex(of: ":") else {
            return self.upperFirst()
        }
        let beforeSeparator = self[..<lastSeparator]
        let afterSeparator = self[index(after: lastSeparator)...]
        return beforeSeparator + ":" + afterSeparator.upperFirst()
    }

    /// Lowercase first letter, or if first word is an uppercase acronym then lowercase the whole of the acronym
    fileprivate func lowerFirstWord() -> String {
        var firstLowercase = self.startIndex
        var lastUppercaseOptional: Self.Index?
        // get last uppercase character, first lowercase character
        while firstLowercase != self.endIndex, self[firstLowercase].isSnakeUppercase() {
            lastUppercaseOptional = firstLowercase
            firstLowercase = self.index(after: firstLowercase)
        }
        // if first character was never set first character must be lowercase
        guard let lastUppercase = lastUppercaseOptional else {
            return String(self)
        }
        if firstLowercase == self.endIndex {
            // if first lowercase letter is the end index then whole word is uppercase and
            // should be wholly lowercased
            return self.lowercased()
        } else if lastUppercase == self.startIndex {
            // if last uppercase letter is the first letter then only lower that character
            return self.lowerFirst()
        } else {
            // We have an acronym at the start, lowercase the whole of it
            return self[startIndex ..< lastUppercase].lowercased() + self[lastUppercase...]
        }
    }
}

extension Character {
    fileprivate func isSnakeUppercase() -> Bool {
        self.isNumber || ("A" ... "Z").contains(self) || self == "_"
    }
}

private let swiftReservedWords: Set<String> = [
    "as",
    "async",
    "await",
    "break",
    "case",
    "catch",
    "class",
    "continue",
    "default",
    "defer",
    "do",
    "else",
    "enum",
    "extension",
    "false",
    "for",
    "func",
    "if",
    "import",
    "in",
    "internal",
    "is",
    "let",
    "nil",
    "operator",
    "private",
    "protocol",
    "Protocol",
    "public",
    "repeat",
    "return",
    "self",
    "Self",
    "static",
    "struct",
    "switch",
    "true",
    "try",
    "Type",
    "var",
    "where",
    "while",
]
