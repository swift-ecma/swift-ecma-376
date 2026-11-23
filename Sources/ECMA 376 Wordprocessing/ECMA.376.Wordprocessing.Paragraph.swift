public import ECMA_376

extension ECMA.`376`.Wordprocessing {
    public struct Paragraph: Sendable, Hashable {
        public var runs: [ECMA.`376`.Wordprocessing.Run]

        public init(runs: [ECMA.`376`.Wordprocessing.Run]) {
            self.runs = runs
        }
    }
}

extension ECMA.`376`.Wordprocessing.Paragraph {
    public var text: String {
        runs.map(\.text).joined()
    }

    public var textboxes: [[ECMA.`376`.Wordprocessing.Block]] {
        runs.flatMap(\.textboxes)
    }
}
