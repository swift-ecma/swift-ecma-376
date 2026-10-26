// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-ecma-376",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "ECMA 376", targets: ["ECMA 376"]),
        .library(name: "ECMA 376 WordprocessingML", targets: ["ECMA 376 WordprocessingML"]),
        .library(name: "ECMA 376 SpreadsheetML", targets: ["ECMA 376 SpreadsheetML"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-byte.git", branch: "main"),
        .package(url: "https://github.com/swift-iso/swift-iso-21320.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-3986.git", branch: "main"),
        .package(url: "https://github.com/swift-w3c/swift-w3c-xml.git", branch: "main"),
    ],
    targets: [
        // Part 2, the Open Packaging Conventions: a document's parts in their ZIP archive, and the relationships
        // between them.
        .target(
            name: "ECMA 376",
            dependencies: [
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "ISO 21320", package: "swift-iso-21320"),
                .product(name: "RFC 3986", package: "swift-rfc-3986"),
                .product(name: "W3C XML", package: "swift-w3c-xml"),
            ]
        ),
        // Part 1 §17, WordprocessingML: a document's body, headers and footers as paragraphs and tables.
        .target(
            name: "ECMA 376 WordprocessingML",
            dependencies: [
                .target(name: "ECMA 376"),
                .product(name: "W3C XML", package: "swift-w3c-xml"),
            ]
        ),
        // Part 1 §18, SpreadsheetML: a workbook's sheets as rows of cells.
        .target(
            name: "ECMA 376 SpreadsheetML",
            dependencies: [
                .target(name: "ECMA 376"),
                .product(name: "W3C XML", package: "swift-w3c-xml"),
            ]
        ),
        .testTarget(
            name: "ECMA 376 Tests",
            dependencies: [
                .target(name: "ECMA 376"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "ISO 21320", package: "swift-iso-21320"),
            ]
        ),
        .testTarget(
            name: "ECMA 376 WordprocessingML Tests",
            dependencies: [
                .target(name: "ECMA 376"),
                .target(name: "ECMA 376 WordprocessingML"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "ISO 21320", package: "swift-iso-21320"),
            ]
        ),
        .testTarget(
            name: "ECMA 376 SpreadsheetML Tests",
            dependencies: [
                .target(name: "ECMA 376"),
                .target(name: "ECMA 376 SpreadsheetML"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "ISO 21320", package: "swift-iso-21320"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .strictMemorySafety(),
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
            .enableUpcomingFeature("InferIsolatedConformances"),
            .enableExperimentalFeature("Lifetimes"),
            .treatAllWarnings(as: .error),
        ]
}
