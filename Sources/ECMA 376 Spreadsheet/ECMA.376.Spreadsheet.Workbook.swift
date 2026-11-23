public import ECMA_376
import W3C_XML

extension ECMA.`376`.Spreadsheet {
    public struct Workbook: Sendable, Hashable {
        public var sheets: [ECMA.`376`.Spreadsheet.Worksheet]

        public init(sheets: [ECMA.`376`.Spreadsheet.Worksheet]) {
            self.sheets = sheets
        }
    }
}

extension ECMA.`376`.Spreadsheet.Workbook {
    public init(_ package: ECMA.`376`.Package) throws(ECMA.`376`.Package.Error) {
        let main = try package.target(of: .officeDocument, from: .root)
        let workbook = try package.markup(main)
        guard workbook.name.local == "workbook" else { throw .unexpected(workbook.name.qualified) }
        let relationships = try package.relationships(of: main)
        let strings = try Self.strings(in: package, from: main, relationships: relationships)
        let sheets = try (workbook.child("sheets")?.children("sheet") ?? []).map {
            sheet throws(ECMA.`376`.Package.Error) -> ECMA.`376`.Spreadsheet.Worksheet? in
            guard
                let name = sheet.attribute("name"),
                let id = sheet.attribute(local: "id"),
                let relationship = relationships.first(where: { $0.id == id })
            else { throw .unexpected(sheet.name.qualified) }
            guard relationship.kind == .worksheet else { return nil }
            let worksheet = try package.markup(try main.resolve(relationship.target))
            guard worksheet.name.local == "worksheet" else { throw .unexpected(worksheet.name.qualified) }
            return ECMA.`376`.Spreadsheet.Worksheet(
                name: name,
                rows: (worksheet.child("sheetData")?.children("row") ?? []).map {
                    ECMA.`376`.Spreadsheet.row($0, strings: strings)
                }
            )
        }
        self.init(sheets: sheets.compactMap { $0 })
    }

    static func strings(
        in package: ECMA.`376`.Package,
        from main: ECMA.`376`.Part.Name,
        relationships: [ECMA.`376`.Relationship]
    ) throws(ECMA.`376`.Package.Error) -> [String] {
        guard let shared = relationships.first(where: { $0.kind == .sharedStrings && $0.mode == .internal }) else {
            return []
        }
        let table = try package.markup(try main.resolve(shared.target))
        guard table.name.local == "sst" else { throw .unexpected(table.name.qualified) }
        return table.children("si").map(ECMA.`376`.Spreadsheet.text)
    }
}
