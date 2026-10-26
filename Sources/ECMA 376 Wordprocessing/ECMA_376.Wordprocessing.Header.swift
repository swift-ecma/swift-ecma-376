public import ECMA_376

extension ECMA_376.Wordprocessing {
    public struct Header: Sendable, Hashable {
        public var blocks: [ECMA_376.Wordprocessing.Block]

        public init(blocks: [ECMA_376.Wordprocessing.Block]) {
            self.blocks = blocks
        }
    }
}
