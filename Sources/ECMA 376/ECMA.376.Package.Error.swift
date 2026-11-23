public import ISO_21320
public import W3C_XML

extension ECMA.`376`.Package {
    public enum Error: Swift::Error, Sendable, Equatable {
        case archive(ISO.`21320`.Archive.Directory.Error)
        case missing(ECMA.`376`.Part.Name)
        case markup(W3C.XML.Parse.Error)
        case target(String)
        case relationship(ECMA.`376`.Relationship.Kind)
        case unexpected(String)
    }
}
