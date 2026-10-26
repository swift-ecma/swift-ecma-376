public import ECMA_376

extension ECMA_376.Wordprocessing {
    public struct Table: Sendable, Hashable {
        public var rows: [ECMA_376.Wordprocessing.Table.Row]

        public init(rows: [ECMA_376.Wordprocessing.Table.Row]) {
            self.rows = rows
        }
    }
}
