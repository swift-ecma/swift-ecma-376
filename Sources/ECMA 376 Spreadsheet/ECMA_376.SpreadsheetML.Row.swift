public import ECMA_376

extension ECMA_376.SpreadsheetML {
    public struct Row: Sendable, Hashable {
        public var cells: [ECMA_376.SpreadsheetML.Cell]

        public init(cells: [ECMA_376.SpreadsheetML.Cell]) {
            self.cells = cells
        }
    }
}
