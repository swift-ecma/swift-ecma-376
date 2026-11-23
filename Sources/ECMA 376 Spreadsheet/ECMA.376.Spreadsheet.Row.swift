public import ECMA_376

extension ECMA.`376`.Spreadsheet {
    public struct Row: Sendable, Hashable {
        public var cells: [ECMA.`376`.Spreadsheet.Cell]

        public init(cells: [ECMA.`376`.Spreadsheet.Cell]) {
            self.cells = cells
        }
    }
}
