public import W3C_XML

extension W3C_XML.Element {
    package func attribute(local: String) -> String? {
        attributes.first { $0.name.local == local }?.value
    }
}
