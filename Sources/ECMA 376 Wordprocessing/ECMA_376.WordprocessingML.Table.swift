public import ECMA_376

extension ECMA_376.WordprocessingML {
    public struct Table: Sendable, Hashable {
        public var rows: [ECMA_376.WordprocessingML.Table.Row]

        public init(rows: [ECMA_376.WordprocessingML.Table.Row]) {
            self.rows = rows
        }
    }
}
