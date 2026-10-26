public import W3C_XML

extension ECMA_376.Package {
    /// The root element of the part named `name`, an XML document.
    public func markup(_ name: ECMA_376.Part.Name) throws(ECMA_376.Package.Error) -> W3C_XML.Element {
        let bytes = try part(name)
        do throws(W3C_XML.Parse.Error) {
            return try W3C_XML.parse(bytes.map(\.underlying)).root
        } catch {
            throw .markup(error)
        }
    }
}
