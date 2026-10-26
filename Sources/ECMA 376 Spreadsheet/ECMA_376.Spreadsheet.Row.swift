public import ECMA_376

extension ECMA_376.Spreadsheet {
    public struct Row: Sendable, Hashable {
        public var cells: [ECMA_376.Spreadsheet.Cell]

        public init(cells: [ECMA_376.Spreadsheet.Cell]) {
            self.cells = cells
        }
    }
}
