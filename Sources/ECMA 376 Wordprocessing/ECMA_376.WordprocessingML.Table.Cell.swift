public import ECMA_376

extension ECMA_376.WordprocessingML.Table {
    public struct Cell: Sendable, Hashable {
        public var blocks: [ECMA_376.WordprocessingML.Block]

        public init(blocks: [ECMA_376.WordprocessingML.Block]) {
            self.blocks = blocks
        }
    }
}
