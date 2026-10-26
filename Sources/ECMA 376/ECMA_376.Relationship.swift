extension ECMA_376 {
    /// A relationship (Part 2): from a source, the package or one of its parts, to a target, with a type that says
    /// what the target is to the source.
    public struct Relationship: Sendable, Hashable {
        public let id: String
        public let type: String
        public let target: String
        /// Whether the target is a resource outside the package rather than one of its parts.
        public let isExternal: Bool

        public init(id: String, type: String, target: String, isExternal: Bool = false) {
            self.id = id
            self.type = type
            self.target = target
            self.isExternal = isExternal
        }
    }
}
