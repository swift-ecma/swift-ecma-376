public import ECMA_376
import W3C_XML

extension ECMA.`376`.Wordprocessing {
    public struct Document: Sendable, Hashable {
        public var body: [ECMA.`376`.Wordprocessing.Block]
        public var headers: [ECMA.`376`.Wordprocessing.Header]
        public var footers: [ECMA.`376`.Wordprocessing.Footer]

        public init(
            body: [ECMA.`376`.Wordprocessing.Block],
            headers: [ECMA.`376`.Wordprocessing.Header] = [],
            footers: [ECMA.`376`.Wordprocessing.Footer] = []
        ) {
            self.body = body
            self.headers = headers
            self.footers = footers
        }
    }
}

extension ECMA.`376`.Wordprocessing.Document {
    public init(_ package: ECMA.`376`.Package) throws(ECMA.`376`.Package.Error) {
        let main = try package.target(of: .officeDocument, from: .root)
        let document = try package.markup(main)
        guard document.name.local == "document", let body = document.child("body") else {
            throw .unexpected(document.name.qualified)
        }
        let source = ECMA.`376`.Wordprocessing.Document.Source(
            package: package,
            main: main,
            body: body,
            relationships: try package.relationships(of: main)
        )
        self.init(
            body: ECMA.`376`.Wordprocessing.blocks(body),
            headers: try source.parts(referred: "headerReference", root: "hdr")
                .map(ECMA.`376`.Wordprocessing.Header.init(blocks:)),
            footers: try source.parts(referred: "footerReference", root: "ftr")
                .map(ECMA.`376`.Wordprocessing.Footer.init(blocks:))
        )
    }
}
