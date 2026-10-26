public import ECMA_376
import W3C_XML

extension ECMA_376.Wordprocessing.Document {
    struct Source {
        let package: ECMA_376.Package
        let main: ECMA_376.Part.Name
        let body: W3C_XML.Element
        let relationships: [ECMA_376.Relationship]
    }
}

extension ECMA_376.Wordprocessing.Document.Source {
    func parts(
        referred element: String,
        root: String
    ) throws(ECMA_376.Package.Error) -> [[ECMA_376.Wordprocessing.Block]] {
        var names: [ECMA_376.Part.Name] = []
        for id in Self.references(element, in: body) {
            guard let relationship = relationships.first(where: { $0.id == id }) else { throw .unexpected(element) }
            let name = try main.resolve(relationship.target)
            if !names.contains(name) { names.append(name) }
        }
        return try names.map { name throws(ECMA_376.Package.Error) in
            let part = try package.markup(name)
            guard part.name.local == root else { throw .unexpected(part.name.qualified) }
            return ECMA_376.Wordprocessing.blocks(part)
        }
    }

    static func references(_ name: String, in element: W3C_XML.Element) -> [String] {
        element.children.flatMap { child in
            child.name.local == name
                ? child.attribute(local: "id").map { [$0] } ?? []
                : Self.references(name, in: child)
        }
    }
}
