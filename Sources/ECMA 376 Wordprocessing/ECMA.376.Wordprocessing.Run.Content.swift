public import ECMA_376

extension ECMA.`376`.Wordprocessing.Run {
    public enum Content: Sendable, Hashable {
        case text(String)
        case tab
        case `break`
        case carriageReturn
        case deletedText(String)
        case fieldCode(String)
        case textbox([ECMA.`376`.Wordprocessing.Block])
    }
}

extension ECMA.`376`.Wordprocessing.Run.Content {
    public var text: String {
        switch self {
        case .text(let text): text
        case .tab: "\t"
        case .break, .carriageReturn: "\n"
        case .deletedText, .fieldCode, .textbox: ""
        }
    }

    public var textbox: [ECMA.`376`.Wordprocessing.Block]? {
        guard case .textbox(let blocks) = self else { return nil }
        return blocks
    }
}
