public import ECMA_376

extension ECMA.`376`.Spreadsheet {
    public struct Worksheet: Sendable, Hashable {
        public var name: String
        public var rows: [ECMA.`376`.Spreadsheet.Row]

        public init(name: String, rows: [ECMA.`376`.Spreadsheet.Row]) {
            self.name = name
            self.rows = rows
        }
    }
}
