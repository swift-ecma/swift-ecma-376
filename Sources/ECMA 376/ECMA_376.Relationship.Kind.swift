extension ECMA_376.Relationship {
    public struct Kind: Sendable, Hashable {
        public let name: String

        public init(_ name: String) {
            self.name = name
        }
    }

    public var kind: Kind? {
        Kind.bases.first { type.hasPrefix($0) }.map { Kind(String(type.dropFirst($0.count))) }
    }
}

extension ECMA_376.Relationship.Kind {
    static let bases = [
        "http://schemas.openxmlformats.org/officeDocument/2006/relationships/",
        "http://purl.oclc.org/ooxml/officeDocument/relationships/",
    ]

    public static let officeDocument = ECMA_376.Relationship.Kind("officeDocument")
    public static let header = ECMA_376.Relationship.Kind("header")
    public static let footer = ECMA_376.Relationship.Kind("footer")
    public static let worksheet = ECMA_376.Relationship.Kind("worksheet")
    public static let sharedStrings = ECMA_376.Relationship.Kind("sharedStrings")
}
