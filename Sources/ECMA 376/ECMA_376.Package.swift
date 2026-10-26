public import Byte
public import ISO_21320

extension ECMA_376 {
    /// A package (Part 2): the parts of one document, each stored in a ZIP archive as an item named by its part name
    /// without the leading slash.
    public struct Package: Sendable {
        let directory: ISO_21320.Archive.Directory
    }
}

extension ECMA_376.Package {
    /// The package in `bytes`, a ZIP archive.
    public init(_ bytes: [Byte]) throws(ECMA_376.Package.Error) {
        do throws(ISO_21320.Archive.Directory.Error) {
            directory = try ISO_21320.Archive.Directory(bytes)
        } catch {
            throw .archive(error)
        }
    }

    /// The names of the parts the package holds, in the order of its archive.
    public var names: [ECMA_376.Part.Name] {
        directory.entries.map { ECMA_376.Part.Name($0.path) }
    }

    /// Whether the package holds a part named `name`.
    public func contains(_ name: ECMA_376.Part.Name) -> Bool {
        entry(name) != nil
    }

    /// The bytes of the part named `name`.
    public func part(_ name: ECMA_376.Part.Name) throws(ECMA_376.Package.Error) -> [Byte] {
        guard let entry = entry(name) else { throw .missing(name) }
        do throws(ISO_21320.Archive.Directory.Error) {
            return try directory.read(entry)
        } catch {
            throw .archive(error)
        }
    }

    func entry(_ name: ECMA_376.Part.Name) -> ISO_21320.Archive.Directory.Entry? {
        directory.entries.first { ECMA_376.Part.Name($0.path) == name }
    }
}
