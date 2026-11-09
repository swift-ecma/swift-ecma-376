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
        lhs.folded.elementsEqual(rhs.folded)
    }

    public func hash(into hasher: inout Hasher) {
        for byte in folded { hasher.combine(byte) }
    }

    private var folded: some Swift::Sequence<UInt8> {
        value.utf8.lazy.map { (0x41...0x5A).contains($0) ? $0 | 0x20 : $0 }
    }
}

extension ECMA_376.Part.Name: CustomStringConvertible {
    public var description: String { value }
}
