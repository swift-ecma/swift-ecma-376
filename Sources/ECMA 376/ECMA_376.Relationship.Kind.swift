extension ECMA_376.Relationship {
    /// What a relationship's target is to its source, by the name Part 1 gives its type. A Transitional document and
    /// a Strict one name the same kind under different bases.
    public struct Kind: Sendable, Hashable {
        public let name: String

        public init(_ name: String) {
            self.name = name
        }
    }

    /// The kind of this relationship, when its type is one Part 1 defines.
    public var kind: Kind? {
        Kind.bases.first { type.hasPrefix($0) }.map { Kind(String(type.dropFirst($0.count))) }
    }
}

extension ECMA_376.Relationship.Kind {
    /// The bases of Part 1's relationship types: Transitional, then Strict.
    static let bases = [
        "http://schemas.openxmlformats.org/officeDocument/2006/relationships/",
        "http://purl.oclc.org/ooxml/officeDocument/relationships/",
    ]

    /// The main part of a document: its word-processing document, workbook or presentation.
    public static let officeDocument = ECMA_376.Relationship.Kind("officeDocument")

    /// A header of a word-processing document.
    public static let header = ECMA_376.Relationship.Kind("header")

    /// A footer of a word-processing document.
    public static let footer = ECMA_376.Relationship.Kind("footer")

    /// A worksheet of a workbook.
    public static let worksheet = ECMA_376.Relationship.Kind("worksheet")

    /// The shared string table of a workbook.
    public static let sharedStrings = ECMA_376.Relationship.Kind("sharedStrings")
}
