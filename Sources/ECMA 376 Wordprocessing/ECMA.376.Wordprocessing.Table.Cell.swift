public import ECMA_376

extension ECMA.`376`.Wordprocessing.Table {
    public struct Cell: Sendable, Hashable {
        public var blocks: [ECMA.`376`.Wordprocessing.Block]

        public init(blocks: [ECMA.`376`.Wordprocessing.Block]) {
            self.blocks = blocks
        }
    }
}
