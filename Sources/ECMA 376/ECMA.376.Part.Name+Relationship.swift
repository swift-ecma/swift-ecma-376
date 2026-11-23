import RFC_3986

extension ECMA.`376`.Part.Name {
    public var relationships: ECMA.`376`.Part.Name {
        let slash = value.lastIndex(of: "/") ?? value.startIndex
        return ECMA.`376`.Part.Name(value[...slash] + "_rels/" + value[value.index(after: slash)...] + ".rels")
    }

    public func resolve(_ target: String) throws(ECMA.`376`.Package.Error) -> ECMA.`376`.Part.Name {
        do throws(IETF.RFC.`3986`.Error) {
            return ECMA.`376`.Part.Name(try IETF.RFC.`3986`.URI(value).resolve(target).value)
        } catch {
            throw .target(target)
        }
    }
}
