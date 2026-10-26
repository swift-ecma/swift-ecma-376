public import ISO_21320
public import W3C_XML

extension ECMA_376.Package {
    /// Why a package, or one of its parts, could not be read.
    public enum Error: Swift::Error, Sendable, Equatable {
        /// The bytes are no ZIP archive a package can be read from.
        case archive(ISO_21320.Archive.Directory.Error)
        /// The package holds no part of this name.
        case missing(ECMA_376.Part.Name)
        /// A part is no well-formed XML.
        case markup(W3C_XML.Parse.Error)
        /// A relationship's target is no reference a part name can be resolved from.
        case target(String)
        /// The package has no relationship of this kind where the format requires one.
        case relationship(ECMA_376.Relationship.Kind)
        /// A part's markup is not what its relationship promises: this element is where another is required.
        case unexpected(String)
    }
}
