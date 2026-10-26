extension ECMA_376.Part {
    /// A part name (Part 2): the absolute path of a part in its package, such as `/word/document.xml`. Two part names
    /// are equivalent when they are equal compared case-insensitively.
    public struct Name: Sendable {
        public let value: String

        /// The part name `value`, given with or without its leading slash.
        public init(_ value: some StringProtocol) {
            self.value = value.hasPrefix("/") ? String(value) : "/" + value
        }
    }
}

extension ECMA_376.Part.Name {
    /// The package itself, as the source of the package's own relationships.
    public static let root = ECMA_376.Part.Name("/")
}

extension ECMA_376.Part.Name: Hashable {
    public static func == (lhs: ECMA_376.Part.Name, rhs: ECMA_376.Part.Name) -> Bool {
        lhs.value.lowercased() == rhs.value.lowercased()
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value.lowercased())
    }
}

extension ECMA_376.Part.Name: CustomStringConvertible {
    public var description: String { value }
}
