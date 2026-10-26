extension ECMA_376.Part {
    public struct Name: Sendable {
        public let value: String

        public init(_ value: some StringProtocol) {
            self.value = value.hasPrefix("/") ? String(value) : "/" + value
        }
    }
}

extension ECMA_376.Part.Name {
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
