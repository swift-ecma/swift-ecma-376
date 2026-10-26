import RFC_3986

extension ECMA_376.Part.Name {
    /// The part that holds this part's relationships: `/word/_rels/document.xml.rels` for `/word/document.xml`, and
    /// `/_rels/.rels` for the package's own (``root``).
    public var relationships: ECMA_376.Part.Name {
        let slash = value.lastIndex(of: "/") ?? value.startIndex
        return ECMA_376.Part.Name(value[...slash] + "_rels/" + value[value.index(after: slash)...] + ".rels")
    }

    /// The part a relationship of this part targets: `target` resolved against this part's name as RFC 3986
    /// resolves a relative reference.
    public func resolve(_ target: String) throws(ECMA_376.Package.Error) -> ECMA_376.Part.Name {
        do throws(RFC_3986.Error) {
            return ECMA_376.Part.Name(try RFC_3986.URI(value).resolve(target).value)
        } catch {
            throw .target(target)
        }
    }
}
