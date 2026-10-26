public import ECMA_376

extension ECMA_376.SpreadsheetML {
    public struct Worksheet: Sendable, Hashable {
        public var name: String
        public var rows: [ECMA_376.SpreadsheetML.Row]

        public init(name: String, rows: [ECMA_376.SpreadsheetML.Row]) {
            self.name = name
            self.rows = rows
        }
    }
}
