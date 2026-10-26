public import ECMA_376

extension ECMA_376.Wordprocessing.Table {
    public struct Row: Sendable, Hashable {
        public var cells: [ECMA_376.Wordprocessing.Table.Cell]

        public init(cells: [ECMA_376.Wordprocessing.Table.Cell]) {
            self.cells = cells
        }
    }
}
