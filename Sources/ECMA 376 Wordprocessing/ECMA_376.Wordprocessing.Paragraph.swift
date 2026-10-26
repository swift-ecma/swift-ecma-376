public import ECMA_376

extension ECMA_376.Wordprocessing {
    public struct Paragraph: Sendable, Hashable {
        public var runs: [ECMA_376.Wordprocessing.Run]

        public init(runs: [ECMA_376.Wordprocessing.Run]) {
            self.runs = runs
        }
    }
}

extension ECMA_376.Wordprocessing.Paragraph {
    public var text: String {
        runs.map(\.text).joined()
    }

    public var textboxes: [[ECMA_376.Wordprocessing.Block]] {
        runs.flatMap(\.textboxes)
    }
}
