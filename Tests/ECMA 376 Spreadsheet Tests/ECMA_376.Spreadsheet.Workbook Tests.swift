import Byte
import ECMA_376
import ECMA_376_Spreadsheet
import ISO_21320
import Testing

extension ECMA_376.Spreadsheet.Workbook {
    @Suite struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension ECMA_376.Spreadsheet.Workbook.Test {
    static let namespace = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"

    static func workbook(
        sheets: [(name: String, kind: String, target: String)],
        strings: String? = nil,
        parts: [(path: String, content: String)]
    ) throws(ECMA_376.Package.Error) -> ECMA_376.Spreadsheet.Workbook {
        let base = "http://schemas.openxmlformats.org/officeDocument/2006/relationships/"
        let listed = sheets.enumerated().map { index, sheet in
            "<sheet name=\"\(sheet.name)\" sheetId=\"\(index + 1)\" r:id=\"rId\(index + 1)\"/>"
        }.joined()
        let related = sheets.enumerated().map { index, sheet in
            "<Relationship Id=\"rId\(index + 1)\" Type=\"\(base)\(sheet.kind)\" Target=\"\(sheet.target)\"/>"
        }.joined()
        let shared = strings.map { _ in
            "<Relationship Id=\"rIdStrings\" Type=\"\(base)sharedStrings\" Target=\"sharedStrings.xml\"/>"
        } ?? ""
        let entries = [
            (
                path: "_rels/.rels",
                content: "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
                    + "<Relationship Id=\"rId1\" Type=\"\(base)officeDocument\" Target=\"xl/workbook.xml\"/></Relationships>"
            ),
            (
                path: "xl/workbook.xml",
                content: "<workbook xmlns=\"\(Self.namespace)\" "
                    + "xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\">"
                    + "<sheets>\(listed)</sheets></workbook>"
            ),
            (
                path: "xl/_rels/workbook.xml.rels",
                content: "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
                    + related + shared + "</Relationships>"
            ),
        ] + (strings.map { [(path: "xl/sharedStrings.xml", content: $0)] } ?? []) + parts
        let archive = entries.reduce(into: ISO_21320.Archive()) { archive, entry in
            archive.add(path: entry.path, content: entry.content)
        }
        return try ECMA_376.Spreadsheet.Workbook(ECMA_376.Package(archive.finalize().map(Byte.init(bitPattern:))))
    }

    static func sheet(_ rows: String) -> String {
        "<worksheet xmlns=\"\(Self.namespace)\"><sheetData>\(rows)</sheetData></worksheet>"
    }
}

extension ECMA_376.Spreadsheet.Workbook.Test.Unit {
    @Test func `sheets are read in the workbook's order, rows of cells with shared strings in place`() throws {
        let strings = """
            <sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="3" uniqueCount="3">\
            <si><t>Omschrijving</t></si><si><t>Bedrag</t></si>\
            <si><r><t xml:space="preserve">Huur </t></r><r><t>oktober</t></r><rPh sb="0" eb="1"><t>uitspraak</t></rPh></si>\
            </sst>
            """
        let workbook = try ECMA_376.Spreadsheet.Workbook.Test.workbook(
            sheets: [
                ("Blad1", "worksheet", "worksheets/sheet1.xml"),
                ("Blad2", "worksheet", "worksheets/sheet10.xml"),
            ],
            strings: strings,
            parts: [
                (
                    "xl/worksheets/sheet1.xml",
                    ECMA_376.Spreadsheet.Workbook.Test.sheet(
                        """
                        <row r="1"><c r="A1" t="s"><v>0</v></c><c r="B1" t="s"><v>1</v></c></row>\
                        <row r="2"><c r="A2" t="s"><v>2</v></c><c r="B2" s="1"><v>1250.5</v></c><c r="C2"><f>B2*2</f><v>2501</v></c></row>
                        """
                    )
                ),
                (
                    "xl/worksheets/sheet10.xml",
                    ECMA_376.Spreadsheet.Workbook.Test.sheet(
                        "<row r=\"1\"><c r=\"A1\" t=\"inlineStr\"><is><t>Tiende blad</t></is></c></row>"
                    )
                ),
            ]
        )
        #expect(workbook.sheets.map(\.name) == ["Blad1", "Blad2"])
        #expect(workbook.sheets[0].rows.map { $0.cells.map(\.value) } == [
            [.text("Omschrijving"), .text("Bedrag")],
            [.text("Huur oktober"), .number("1250.5"), .number("2501")],
        ])
        #expect(workbook.sheets[0].rows[1].cells[2].formula == "B2*2")
        #expect(workbook.sheets[0].rows[1].cells.map(\.reference) == ["A2", "B2", "C2"])
        #expect(workbook.sheets[1].rows.map { $0.cells.map(\.value) } == [[.text("Tiende blad")]])
    }

    @Test func `a cell's value carries its type`() throws {
        let workbook = try ECMA_376.Spreadsheet.Workbook.Test.workbook(
            sheets: [("Blad1", "worksheet", "worksheets/sheet1.xml")],
            parts: [
                (
                    "xl/worksheets/sheet1.xml",
                    ECMA_376.Spreadsheet.Workbook.Test.sheet(
                        """
                        <row r="1"><c r="A1" t="b"><v>1</v></c><c r="B1" t="b"><v>0</v></c><c r="C1" t="e"><v>#DIV/0!</v></c>\
                        <c r="D1" t="d"><v>2026-10-26</v></c><c r="E1" t="str"><f>"Tweede"</f><v>Tweede blad</v></c>\
                        <c r="F1" t="n"><v>42</v></c><c r="G1"/></row>
                        """
                    )
                )
            ]
        )
        #expect(workbook.sheets[0].rows[0].cells.map(\.value) == [
            .boolean(true), .boolean(false), .error("#DIV/0!"), .date("2026-10-26"), .text("Tweede blad"), .number("42"), nil,
        ])
    }

    @Test func `a workbook without a shared string table is read`() throws {
        let workbook = try ECMA_376.Spreadsheet.Workbook.Test.workbook(
            sheets: [("Blad1", "worksheet", "worksheets/sheet1.xml")],
            parts: [
                (
                    "xl/worksheets/sheet1.xml",
                    ECMA_376.Spreadsheet.Workbook.Test.sheet("<row r=\"1\"><c r=\"A1\"><v>42</v></c></row>")
                )
            ]
        )
        #expect(workbook.sheets[0].rows[0].cells.map(\.value) == [.number("42")])
    }
}

extension ECMA_376.Spreadsheet.Workbook.Test.`Edge Case` {
    @Test func `a sheet that is no worksheet is left out`() throws {
        let workbook = try ECMA_376.Spreadsheet.Workbook.Test.workbook(
            sheets: [
                ("Grafiek", "chartsheet", "chartsheets/sheet1.xml"),
                ("Blad1", "worksheet", "worksheets/sheet1.xml"),
            ],
            parts: [
                ("xl/chartsheets/sheet1.xml", "<chartsheet xmlns=\"\(ECMA_376.Spreadsheet.Workbook.Test.namespace)\"/>"),
                ("xl/worksheets/sheet1.xml", ECMA_376.Spreadsheet.Workbook.Test.sheet("")),
            ]
        )
        #expect(workbook.sheets.map(\.name) == ["Blad1"])
    }

    @Test func `a shared string index beyond the table has no value`() throws {
        let workbook = try ECMA_376.Spreadsheet.Workbook.Test.workbook(
            sheets: [("Blad1", "worksheet", "worksheets/sheet1.xml")],
            strings: "<sst xmlns=\"\(ECMA_376.Spreadsheet.Workbook.Test.namespace)\"><si><t>Een</t></si></sst>",
            parts: [
                (
                    "xl/worksheets/sheet1.xml",
                    ECMA_376.Spreadsheet.Workbook.Test.sheet("<row r=\"1\"><c r=\"A1\" t=\"s\"><v>7</v></c></row>")
                )
            ]
        )
        #expect(workbook.sheets[0].rows[0].cells.map(\.value) == [nil])
    }

    @Test func `a worksheet part with another root element is refused by that element`() {
        #expect(throws: ECMA_376.Package.Error.unexpected("styleSheet")) {
            try ECMA_376.Spreadsheet.Workbook.Test.workbook(
                sheets: [("Blad1", "worksheet", "worksheets/sheet1.xml")],
                parts: [("xl/worksheets/sheet1.xml", "<styleSheet/>")]
            )
        }
    }
}
