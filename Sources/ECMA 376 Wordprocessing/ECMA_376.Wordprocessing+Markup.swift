public import ECMA_376
import W3C_XML

extension ECMA_376.Wordprocessing {
    static func blocks(_ container: W3C_XML.Element) -> [ECMA_376.Wordprocessing.Block] {
        container.children.flatMap { child -> [ECMA_376.Wordprocessing.Block] in
            switch child.name.local {
            case "p": [.paragraph(ECMA_376.Wordprocessing.Paragraph(runs: Self.runs(child)))]
            case "tbl": [.table(Self.table(child))]
            case "sdt": child.child("sdtContent").map(Self.blocks) ?? []
            case "customXml": Self.blocks(child)
            default: []
            }
        }
    }

    static func table(_ element: W3C_XML.Element) -> ECMA_376.Wordprocessing.Table {
        ECMA_376.Wordprocessing.Table(
            rows: element.children("tr").map { row in
                ECMA_376.Wordprocessing.Table.Row(
                    cells: row.children("tc").map { ECMA_376.Wordprocessing.Table.Cell(blocks: Self.blocks($0)) }
                )
            }
        )
    }

    static func runs(_ element: W3C_XML.Element) -> [ECMA_376.Wordprocessing.Run] {
        element.children.flatMap { child -> [ECMA_376.Wordprocessing.Run] in
            switch child.name.local {
            case "r": [ECMA_376.Wordprocessing.Run(content: child.children.flatMap(Self.content))]
            case "hyperlink", "ins", "del", "moveTo", "smartTag", "fldSimple", "customXml", "dir", "bdo": Self.runs(child)
            case "sdt": child.child("sdtContent").map(Self.runs) ?? []
            default: []
            }
        }
    }

    static func content(_ element: W3C_XML.Element) -> [ECMA_376.Wordprocessing.Run.Content] {
        switch element.name.local {
        case "t": [.text(element.textContent)]
        case "tab": [.tab]
        case "br": [.break]
        case "cr": [.carriageReturn]
        case "delText": [.deletedText(element.textContent)]
        case "instrText", "delInstrText": [.fieldCode(element.textContent)]
        case "drawing", "pict", "object", "AlternateContent": Self.textboxes(element).map { .textbox($0) }
        default: []
        }
    }

    static func textboxes(_ element: W3C_XML.Element) -> [[ECMA_376.Wordprocessing.Block]] {
        guard element.name.local != "txbxContent" else { return [Self.blocks(element)] }
        return Self.alternatives(element).flatMap(Self.textboxes)
    }

    static func alternatives(_ element: W3C_XML.Element) -> [W3C_XML.Element] {
        guard element.name.local == "AlternateContent" else { return element.children }
        return
            (element.children.first { $0.name.local == "Choice" }
            ?? element.children.first { $0.name.local == "Fallback" }).map { [$0] } ?? []
    }
}
