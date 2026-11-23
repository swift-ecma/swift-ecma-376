public import ECMA_376

extension ECMA.`376`.Spreadsheet {
    public struct Cell: Sendable, Hashable {
        public var reference: String?
        public var value: ECMA.`376`.Spreadsheet.Cell.Value?
        public var formula: String?

        public init(reference: String? = nil, value: ECMA.`376`.Spreadsheet.Cell.Value?, formula: String? = nil) {
            self.reference = reference
            self.value = value
            self.formula = formula
        }
    }
}
