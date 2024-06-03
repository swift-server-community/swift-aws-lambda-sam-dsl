import HummingbirdMustache

public enum Templates {
    static var values: [String: String] = [
        "structTemplate": structTemplate,
    ]

    public static func createLibrary() throws -> TemplateLibrary {
        let library = HBMustacheLibraryAdapter()
        for (name, templateString) in self.values {
            do {
                let template = try HBMustacheTemplateAdapter(string: templateString)
                library.register(template, named: name)
            } catch {
                print("Error creating template '\(name)': \(error)")
            }
        }
        return library
    }
}
