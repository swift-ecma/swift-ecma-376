public import ECMA_376

extension ECMA_376.SpreadsheetML {
    public struct Cell: Sendable, Hashable {
        public var reference: String?
        public var value: ECMA_376.SpreadsheetML.Cell.Value?
        public var formula: String?

        public init(reference: String? = nil, value: ECMA_376.SpreadsheetML.Cell.Value?, formula: String? = nil) {
            self.reference = reference
            self.value = value
            self.formula = formula
        }
    }
}
