public import W3C_XML

extension ECMA.`376`.Package {
    public func markup(_ name: ECMA.`376`.Part.Name) throws(ECMA.`376`.Package.Error) -> W3C.XML.Element {
        let bytes = try part(name)
        do throws(W3C.XML.Parse.Error) {
            return try W3C.XML.parse(bytes.map(\.underlying)).root
        } catch {
            throw .markup(error)
        }
    }
}
