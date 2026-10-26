public import ECMA_376

extension ECMA_376.WordprocessingML {
    public struct Header: Sendable, Hashable {
        public var blocks: [ECMA_376.WordprocessingML.Block]

        public init(blocks: [ECMA_376.WordprocessingML.Block]) {
            self.blocks = blocks
        }
    }
}
