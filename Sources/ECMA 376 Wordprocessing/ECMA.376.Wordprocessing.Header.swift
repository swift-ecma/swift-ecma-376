public import ECMA_376

extension ECMA.`376`.Wordprocessing {
    public struct Header: Sendable, Hashable {
        public var blocks: [ECMA.`376`.Wordprocessing.Block]

        public init(blocks: [ECMA.`376`.Wordprocessing.Block]) {
            self.blocks = blocks
        }
    }
}
