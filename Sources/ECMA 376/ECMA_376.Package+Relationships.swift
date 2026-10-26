extension ECMA_376.Package {
    public func relationships(
        of source: ECMA_376.Part.Name
    ) throws(ECMA_376.Package.Error) -> [ECMA_376.Relationship] {
        let name = source.relationships
        guard contains(name) else { return [] }
        let root = try markup(name)
        guard root.name.local == "Relationships" else { throw .unexpected(root.name.qualified) }
        return try root.children.filter { $0.name.local == "Relationship" }.map {
            element throws(ECMA_376.Package.Error) in
            guard
                let id = element.attribute("Id"),
                let type = element.attribute("Type"),
                let target = element.attribute("Target")
            else { throw .unexpected(element.name.qualified) }
            return ECMA_376.Relationship(
                id: id,
                type: type,
                target: target,
                mode: element.attribute("TargetMode") == "External" ? .external : .internal
            )
        }
    }

    public func target(
        of kind: ECMA_376.Relationship.Kind,
        from source: ECMA_376.Part.Name
    ) throws(ECMA_376.Package.Error) -> ECMA_376.Part.Name {
        guard
            let relationship = try relationships(of: source).first(where: { $0.kind == kind && $0.mode == .internal })
        else { throw .relationship(kind) }
        return try source.resolve(relationship.target)
    }
}
