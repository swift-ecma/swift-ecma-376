public import ISO_21320
public import W3C_XML

extension ECMA_376.Package {
    public enum Error: Swift::Error, Sendable, Equatable {
        case archive(ISO_21320.Archive.Directory.Error)
        case missing(ECMA_376.Part.Name)
        case markup(W3C_XML.Parse.Error)
        case target(String)
        case relationship(ECMA_376.Relationship.Kind)
        case unexpected(String)
    }
}
