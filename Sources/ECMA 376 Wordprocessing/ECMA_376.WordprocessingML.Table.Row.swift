public import ECMA_376

extension ECMA_376.WordprocessingML.Table {
    public struct Row: Sendable, Hashable {
        public var cells: [ECMA_376.WordprocessingML.Table.Cell]

        public init(cells: [ECMA_376.WordprocessingML.Table.Cell]) {
            self.cells = cells
        }
    }
}
