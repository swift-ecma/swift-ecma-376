import Byte
import ECMA_376
import ISO_21320
import Testing

extension ECMA_376.Package {
    @Suite struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension ECMA_376.Package.Test {
    static func package(_ parts: [(path: String, content: String)]) throws(ECMA_376.Package.Error) -> ECMA_376.Package {
        let archive = parts.reduce(into: ISO_21320.Archive()) { archive, part in
            archive.add(path: part.path, content: part.content)
        }
        return try ECMA_376.Package(archive.finalize().map(Byte.init(bitPattern:)))
    }

    static let relationships = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\
        <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" \
        Target="word/document.xml"/>\
        <Relationship Id="rId2" Type="http://purl.oclc.org/ooxml/officeDocument/relationships/header" Target="header1.xml"/>\
        <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink" \
        Target="https://example.com/" TargetMode="External"/>\
        <Relationship Id="rId4" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" \
        Target="docProps/core.xml"/>\
        </Relationships>
        """
}

extension ECMA_376.Package.Test.Unit {
    @Test func `a part is found by its name, compared without regard to case`() throws {
        let package = try ECMA_376.Package.Test.package([("word/document.xml", "<w:document/>")])
        #expect(try package.part(ECMA_376.Part.Name("/Word/Document.XML")) == [Byte](utf8: "<w:document/>"))
        #expect(package.names == [ECMA_376.Part.Name("/word/document.xml")])
    }

    @Test func `a part's relationships are in the relationships part beside it, the package's in its root`() {
        #expect(ECMA_376.Part.Name("word/document.xml").relationships == ECMA_376.Part.Name("/word/_rels/document.xml.rels"))
        #expect(ECMA_376.Part.Name.root.relationships == ECMA_376.Part.Name("/_rels/.rels"))
    }

    @Test func `a relationship's target resolves against the name of its source`() throws {
        let document = ECMA_376.Part.Name("/word/document.xml")
        #expect(try ECMA_376.Part.Name.root.resolve("word/document.xml") == document)
        #expect(try document.resolve("header1.xml") == ECMA_376.Part.Name("/word/header1.xml"))
        #expect(try document.resolve("../customXml/item1.xml") == ECMA_376.Part.Name("/customXml/item1.xml"))
        #expect(try document.resolve("/xl/workbook.xml") == ECMA_376.Part.Name("/xl/workbook.xml"))
    }

    @Test func `relationships are read in order, with their kind in Transitional and Strict, and their mode`() throws {
        let package = try ECMA_376.Package.Test.package([("_rels/.rels", ECMA_376.Package.Test.relationships)])
        let relationships = try package.relationships(of: .root)
        #expect(relationships.map(\.id) == ["rId1", "rId2", "rId3", "rId4"])
        #expect(relationships.map(\.kind) == [.officeDocument, .header, ECMA_376.Relationship.Kind("hyperlink"), nil])
        #expect(relationships.map(\.mode) == [.internal, .internal, .external, .internal])
    }

    @Test func `a package's main part is the target of its office document relationship`() throws {
        let package = try ECMA_376.Package.Test.package([("_rels/.rels", ECMA_376.Package.Test.relationships)])
        #expect(try package.target(of: .officeDocument, from: .root) == ECMA_376.Part.Name("/word/document.xml"))
    }
}

extension ECMA_376.Package.Test.`Edge Case` {
    @Test func `a part without a relationships part has no relationships`() throws {
        let package = try ECMA_376.Package.Test.package([("word/document.xml", "<w:document/>")])
        #expect(try package.relationships(of: ECMA_376.Part.Name("/word/document.xml")).isEmpty)
    }

    @Test func `a missing part is reported by its name`() throws {
        let package = try ECMA_376.Package.Test.package([("word/document.xml", "<w:document/>")])
        #expect(throws: ECMA_376.Package.Error.missing(ECMA_376.Part.Name("/word/styles.xml"))) {
            try package.part(ECMA_376.Part.Name("word/styles.xml"))
        }
    }

    @Test func `a package without the relationship a format requires reports the relationship's kind`() throws {
        let package = try ECMA_376.Package.Test.package([("word/document.xml", "<w:document/>")])
        #expect(throws: ECMA_376.Package.Error.relationship(.officeDocument)) {
            try package.target(of: .officeDocument, from: .root)
        }
    }

    @Test func `bytes that are no ZIP archive are no package`() {
        #expect(throws: ECMA_376.Package.Error.self) {
            try ECMA_376.Package([Byte](utf8: "PK"))
        }
    }

    @Test func `a relationships part that is no well-formed XML is refused`() throws {
        let package = try ECMA_376.Package.Test.package([("_rels/.rels", "<Relationships>")])
        #expect(throws: ECMA_376.Package.Error.self) {
            try package.relationships(of: .root)
        }
    }

    @Test func `a relationships part with another root element is refused by that element`() throws {
        let package = try ECMA_376.Package.Test.package([("_rels/.rels", "<Types/>")])
        #expect(throws: ECMA_376.Package.Error.unexpected("Types")) {
            try package.relationships(of: .root)
        }
    }
}
