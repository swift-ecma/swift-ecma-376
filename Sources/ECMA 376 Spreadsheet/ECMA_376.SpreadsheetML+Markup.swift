public import ECMA_376
import W3C_XML

extension ECMA_376.SpreadsheetML {
    static func row(_ element: W3C_XML.Element, strings: [String]) -> ECMA_376.SpreadsheetML.Row {
        ECMA_376.SpreadsheetML.Row(cells: element.children("c").map { Self.cell($0, strings: strings) })
    }

    static func cell(_ element: W3C_XML.Element, strings: [String]) -> ECMA_376.SpreadsheetML.Cell {
        ECMA_376.SpreadsheetML.Cell(
            reference: element.attribute("r"),
            value: Self.value(element, strings: strings),
            formula: element.child("f")?.textContent
        )
    }

    static func value(_ element: W3C_XML.Element, strings: [String]) -> ECMA_376.SpreadsheetML.Cell.Value? {
        let stored = element.child("v")?.textContent
        return switch element.attribute("t") {
        case "s":
            stored.flatMap { Int($0) }.flatMap { index in
                strings.indices.contains(index) ? ECMA_376.SpreadsheetML.Cell.Value.text(strings[index]) : nil
            }
        case "inlineStr": element.child("is").map { .text(Self.text($0)) }
        case "str": stored.map { .text($0) }
        case "b": stored.map { .boolean($0 == "1") }
        case "e": stored.map { .error($0) }
        case "d": stored.map { .date($0) }
        default: stored.map { .number($0) }
        }
    }

    static func text(_ element: W3C_XML.Element) -> String {
        element.children.map { child in
            switch child.name.local {
            case "t": child.textContent
            case "r": child.child("t")?.textContent ?? ""
            default: ""
            }
        }.joined()
    }
}
