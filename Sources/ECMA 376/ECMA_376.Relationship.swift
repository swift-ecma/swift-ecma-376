extension ECMA_376 {
    public struct Relationship: Sendable, Hashable {
        public let id: String
        public let type: String
        public let target: String
        public let mode: Mode

        public init(id: String, type: String, target: String, mode: Mode = .internal) {
            self.id = id
            self.type = type
            self.target = target
            self.mode = mode
        }
    }
}
