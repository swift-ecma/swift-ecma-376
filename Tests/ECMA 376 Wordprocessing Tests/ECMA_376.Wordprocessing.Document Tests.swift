import Byte
import ECMA_376
import ECMA_376_Wordprocessing
import ISO_21320
import Testing

extension ECMA_376.Wordprocessing.Document {
    @Suite struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension ECMA_376.Wordprocessing.Document.Test {
    static let namespaces = """
        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" \
        xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" \
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" \
        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" \
        xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" \
        xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" \
        xmlns:v="urn:schemas-microsoft-com:vml"
        """

    static let main = """
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\
        <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" \
        Target="word/document.xml"/></Relationships>
        """

    static func document(
        _ body: String,
        relationships: [(id: String, kind: String, target: String)] = [],
        parts: [(path: String, content: String)] = []
    ) throws(ECMA_376.Package.Error) -> ECMA_376.Wordprocessing.Document {
        let listed = relationships.map { relationship in
            "<Relationship Id=\"\(relationship.id)\" "
                + "Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/\(relationship.kind)\" "
                + "Target=\"\(relationship.target)\"/>"
        }.joined()
        let entries = [
            (path: "_rels/.rels", content: Self.main),
            (
                path: "word/document.xml",
                content: "<w:document \(Self.namespaces)><w:body>\(body)</w:body></w:document>"
            ),
            (
                path: "word/_rels/document.xml.rels",
                content: "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
                    + listed + "</Relationships>"
            ),
        ] + parts
        let archive = entries.reduce(into: ISO_21320.Archive()) { archive, entry in
            archive.add(path: entry.path, content: entry.content)
        }
        return try ECMA_376.Wordprocessing.Document(
            ECMA_376.Package(archive.finalize().map(Byte.init(bitPattern:)))
        )
    }

    static func texts(_ blocks: [ECMA_376.Wordprocessing.Block]) -> [String] {
        blocks.flatMap(\.paragraphs).map(\.text)
    }
}

extension ECMA_376.Wordprocessing.Document.Test.Unit {
    @Test func `a paragraph's text is its runs' text with their tabs and breaks, deleted text and field codes apart`() throws {
        let document = try ECMA_376.Wordprocessing.Document.Test.document(
            """
            <w:p><w:pPr><w:tabs><w:tab w:val="left" w:pos="720"/></w:tabs></w:pPr><w:r><w:t>Voorbeeld B.V.</w:t></w:r></w:p>
            <w:p><w:r><w:t xml:space="preserve">Factuurdatum: </w:t></w:r><w:r><w:t>3 oktober 2026</w:t></w:r></w:p>
            <w:p><w:r><w:t>Bedrag</w:t><w:tab/><w:t>€ 12,00 &amp; btw</w:t><w:br/><w:t>Betaal vóór 1 november</w:t></w:r></w:p>
            <w:p><w:del><w:r><w:delText>weg</w:delText></w:r></w:del><w:r><w:instrText>PAGE</w:instrText></w:r></w:p>
            """
        )
        #expect(ECMA_376.Wordprocessing.Document.Test.texts(document.body) == [
            "Voorbeeld B.V.",
            "Factuurdatum: 3 oktober 2026",
            "Bedrag\t€ 12,00 & btw\nBetaal vóór 1 november",
            "",
        ])
        #expect(document.body.last?.paragraphs.first?.runs.flatMap(\.content) == [.deletedText("weg"), .fieldCode("PAGE")])
    }

    @Test func `headers and footers are the parts the sections refer to, each once, in the order first referred to`() throws {
        let header = { (text: String) in
            "<w:hdr \(ECMA_376.Wordprocessing.Document.Test.namespaces)><w:p><w:r><w:t>\(text)</w:t></w:r></w:p></w:hdr>"
        }
        let footer = { (text: String) in
            "<w:ftr \(ECMA_376.Wordprocessing.Document.Test.namespaces)><w:p><w:r><w:t>\(text)</w:t></w:r></w:p></w:ftr>"
        }
        let document = try ECMA_376.Wordprocessing.Document.Test.document(
            """
            <w:p><w:pPr><w:sectPr><w:headerReference w:type="default" r:id="rId2"/></w:sectPr></w:pPr>\
            <w:r><w:t>Geachte heer,</w:t></w:r></w:p>
            <w:sectPr><w:headerReference w:type="first" r:id="rId1"/><w:headerReference w:type="default" r:id="rId2"/>\
            <w:footerReference w:type="default" r:id="rId3"/></w:sectPr>
            """,
            relationships: [
                ("rId1", "header", "header1.xml"),
                ("rId2", "header", "header2.xml"),
                ("rId3", "footer", "footer1.xml"),
                ("rId4", "footer", "footer2.xml"),
            ],
            parts: [
                ("word/header1.xml", header("Voorbeeld B.V.")),
                ("word/header2.xml", header("Utrecht")),
                ("word/footer1.xml", footer("KvK 12345678")),
                ("word/footer2.xml", footer("Niet verwezen")),
            ]
        )
        #expect(document.headers.map { ECMA_376.Wordprocessing.Document.Test.texts($0.blocks) } == [["Utrecht"], ["Voorbeeld B.V."]])
        #expect(document.footers.map { ECMA_376.Wordprocessing.Document.Test.texts($0.blocks) } == [["KvK 12345678"]])
        #expect(ECMA_376.Wordprocessing.Document.Test.texts(document.body) == ["Geachte heer,"])
    }

    @Test func `a table's paragraphs are read row by row and cell by cell`() throws {
        let document = try ECMA_376.Wordprocessing.Document.Test.document(
            """
            <w:tbl><w:tblPr/><w:tblGrid/>\
            <w:tr><w:tc><w:p><w:r><w:t>Omschrijving</w:t></w:r></w:p></w:tc><w:tc><w:p><w:r><w:t>Bedrag</w:t></w:r></w:p></w:tc></w:tr>\
            <w:tr><w:tc><w:p><w:r><w:t>Huur</w:t></w:r></w:p></w:tc><w:tc><w:p><w:r><w:t>€ 950</w:t></w:r></w:p></w:tc></w:tr>\
            </w:tbl>
            """
        )
        #expect(ECMA_376.Wordprocessing.Document.Test.texts(document.body) == ["Omschrijving", "Bedrag", "Huur", "€ 950"])
    }

    @Test func `a text box is read once, from the first alternative, after the paragraph that holds it`() throws {
        let box = "<w:txbxContent><w:p><w:r><w:t>Postbus 1</w:t></w:r></w:p></w:txbxContent>"
        let document = try ECMA_376.Wordprocessing.Document.Test.document(
            """
            <w:p><w:r><w:t>Aan</w:t></w:r><w:r><mc:AlternateContent>\
            <mc:Choice Requires="wps"><w:drawing><wp:anchor><a:graphic><a:graphicData><wps:wsp><wps:txbx>\(box)\
            </wps:txbx></wps:wsp></a:graphicData></a:graphic></wp:anchor></w:drawing></mc:Choice>\
            <mc:Fallback><w:pict><v:shape><v:textbox>\(box)</v:textbox></v:shape></w:pict></mc:Fallback>\
            </mc:AlternateContent></w:r></w:p>
            """
        )
        #expect(ECMA_376.Wordprocessing.Document.Test.texts(document.body) == ["Aan", "Postbus 1"])
        #expect(document.body.first?.paragraphs.first?.text == "Aan")
    }

    @Test func `hyperlinks, insertions and content controls are opened to their runs, moved-away runs are not`() throws {
        let document = try ECMA_376.Wordprocessing.Document.Test.document(
            """
            <w:sdt><w:sdtContent><w:p><w:hyperlink r:id="rId9"><w:r><w:t>Mijn</w:t></w:r></w:hyperlink>\
            <w:ins><w:r><w:t> overzicht</w:t></w:r></w:ins>\
            <w:moveFrom><w:r><w:t> elders</w:t></w:r></w:moveFrom></w:p></w:sdtContent></w:sdt>
            """
        )
        #expect(ECMA_376.Wordprocessing.Document.Test.texts(document.body) == ["Mijn overzicht"])
    }
}

extension ECMA_376.Wordprocessing.Document.Test.`Edge Case` {
    @Test func `a reference to a relationship the document does not have is refused`() {
        #expect(throws: ECMA_376.Package.Error.unexpected("headerReference")) {
            try ECMA_376.Wordprocessing.Document.Test.document(
                "<w:sectPr><w:headerReference w:type=\"default\" r:id=\"rId9\"/></w:sectPr>"
            )
        }
    }

    @Test func `a main part that is no document is refused by its root element`() throws {
        let archive = [
            (path: "_rels/.rels", content: ECMA_376.Wordprocessing.Document.Test.main),
            (path: "word/document.xml", content: "<w:styles xmlns:w=\"urn:w\"/>"),
        ].reduce(into: ISO_21320.Archive()) { archive, entry in
            archive.add(path: entry.path, content: entry.content)
        }
        let package = try ECMA_376.Package(archive.finalize().map(Byte.init(bitPattern:)))
        #expect(throws: ECMA_376.Package.Error.unexpected("w:styles")) {
            try ECMA_376.Wordprocessing.Document(package)
        }
    }
}
