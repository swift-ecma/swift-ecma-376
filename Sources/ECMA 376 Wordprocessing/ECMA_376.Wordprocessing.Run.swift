public import ECMA_376

extension ECMA_376.Wordprocessing {
    public struct Run: Sendable, Hashable {
        public var content: [ECMA_376.Wordprocessing.Run.Content]

        public init(content: [ECMA_376.Wordprocessing.Run.Content]) {
            self.content = content
        }
    }
}

extension ECMA_376.Wordprocessing.Run {
    public var text: String {
        content.map(\.text).joined()
    }

    public var textboxes: [[ECMA_376.Wordprocessing.Block]] {
        content.compactMap(\.textbox)
    }
}
