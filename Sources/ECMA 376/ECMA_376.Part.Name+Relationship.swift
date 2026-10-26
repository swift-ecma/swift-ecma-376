import RFC_3986

extension ECMA_376.Part.Name {
    public var relationships: ECMA_376.Part.Name {
        let slash = value.lastIndex(of: "/") ?? value.startIndex
        return ECMA_376.Part.Name(value[...slash] + "_rels/" + value[value.index(after: slash)...] + ".rels")
    }

    public func resolve(_ target: String) throws(ECMA_376.Package.Error) -> ECMA_376.Part.Name {
        do throws(RFC_3986.Error) {
            return ECMA_376.Part.Name(try RFC_3986.URI(value).resolve(target).value)
        } catch {
            throw .target(target)
        }
    }
}
