public import ECMA_376

extension ECMA_376.Wordprocessing {
    public enum Block: Sendable, Hashable {
        case paragraph(ECMA_376.Wordprocessing.Paragraph)
        case table(ECMA_376.Wordprocessing.Table)
    }
}

extension ECMA_376.Wordprocessing.Block {
    public var paragraphs: [ECMA_376.Wordprocessing.Paragraph] {
        switch self {
        case .paragraph(let paragraph):
            [paragraph] + paragraph.textboxes.flatMap { $0.flatMap(\.paragraphs) }
        case .table(let table):
            table.rows.flatMap { $0.cells.flatMap { $0.blocks.flatMap(\.paragraphs) } }
        }
    }
}
