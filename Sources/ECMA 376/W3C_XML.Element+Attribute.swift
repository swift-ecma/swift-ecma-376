public import W3C_XML

extension W3C_XML.Element {
    /// The value of the attribute whose local name is `local`, whatever prefix its namespace is bound to.
    package func attribute(local: String) -> String? {
        attributes.first { $0.name.local == local }?.value
    }
}
