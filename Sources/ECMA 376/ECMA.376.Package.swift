public import Byte
public import ISO_21320

extension ECMA.`376` {
    public struct Package: Sendable {
        let directory: ISO.`21320`.Archive.Directory
    }
}

extension ECMA.`376`.Package {
    public init(_ bytes: [Byte]) throws(ECMA.`376`.Package.Error) {
        do throws(ISO.`21320`.Archive.Directory.Error) {
            directory = try ISO.`21320`.Archive.Directory(bytes)
        } catch {
            throw .archive(error)
        }
    }

    public var names: [ECMA.`376`.Part.Name] {
        directory.entries.map { ECMA.`376`.Part.Name($0.path) }
    }

    public func contains(_ name: ECMA.`376`.Part.Name) -> Bool {
        entry(name) != nil
    }

    public func part(_ name: ECMA.`376`.Part.Name) throws(ECMA.`376`.Package.Error) -> [Byte] {
        guard let entry = entry(name) else { throw .missing(name) }
        do throws(ISO.`21320`.Archive.Directory.Error) {
            return try directory.read(entry)
        } catch {
            throw .archive(error)
        }
    }

    func entry(_ name: ECMA.`376`.Part.Name) -> ISO.`21320`.Archive.Directory.Entry? {
        directory.entries.first { ECMA.`376`.Part.Name($0.path) == name }
    }
}
