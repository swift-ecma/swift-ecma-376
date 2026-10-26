public import ECMA_376

extension ECMA_376.WordprocessingML {
    public struct Run: Sendable, Hashable {
        public var content: [ECMA_376.WordprocessingML.Run.Content]

        public init(content: [ECMA_376.WordprocessingML.Run.Content]) {
            self.content = content
        }
    }
}

extension ECMA_376.WordprocessingML.Run {
    public var text: String {
        content.map(\.text).joined()
    }

    public var textboxes: [[ECMA_376.WordprocessingML.Block]] {
        content.compactMap(\.textbox)
    }
}
