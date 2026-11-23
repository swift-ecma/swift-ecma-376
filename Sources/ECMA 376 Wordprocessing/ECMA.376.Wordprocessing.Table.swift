public import ECMA_376

extension ECMA.`376`.Wordprocessing {
    public struct Table: Sendable, Hashable {
        public var rows: [ECMA.`376`.Wordprocessing.Table.Row]

        public init(rows: [ECMA.`376`.Wordprocessing.Table.Row]) {
            self.rows = rows
        }
    }
}
