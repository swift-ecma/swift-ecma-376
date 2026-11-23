public import ECMA_376

extension ECMA.`376`.Wordprocessing {
    public struct Run: Sendable, Hashable {
        public var content: [ECMA.`376`.Wordprocessing.Run.Content]

        public init(content: [ECMA.`376`.Wordprocessing.Run.Content]) {
            self.content = content
        }
    }
}

extension ECMA.`376`.Wordprocessing.Run {
    public var text: String {
        content.map(\.text).joined()
    }

    public var textboxes: [[ECMA.`376`.Wordprocessing.Block]] {
        content.compactMap(\.textbox)
    }
}
