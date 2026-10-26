public import ECMA_376

extension ECMA_376.WordprocessingML {
    public struct Paragraph: Sendable, Hashable {
        public var runs: [ECMA_376.WordprocessingML.Run]

        public init(runs: [ECMA_376.WordprocessingML.Run]) {
            self.runs = runs
        }
    }
}

extension ECMA_376.WordprocessingML.Paragraph {
    public var text: String {
        runs.map(\.text).joined()
    }

    public var textboxes: [[ECMA_376.WordprocessingML.Block]] {
        runs.flatMap(\.textboxes)
    }
}
