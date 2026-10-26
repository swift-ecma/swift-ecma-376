public import ECMA_376

extension ECMA_376.SpreadsheetML.Cell {
    public enum Value: Sendable, Hashable {
        case boolean(Bool)
        case number(String)
        case date(String)
        case error(String)
        case text(String)
    }
}
