public import ECMA_376

extension ECMA.`376`.Wordprocessing.Table {
    public struct Row: Sendable, Hashable {
        public var cells: [ECMA.`376`.Wordprocessing.Table.Cell]

        public init(cells: [ECMA.`376`.Wordprocessing.Table.Cell]) {
            self.cells = cells
        }
    }
}
