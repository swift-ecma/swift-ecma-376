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
        .library(name: "ECMA 376 Wordprocessing", targets: ["ECMA 376 Wordprocessing"]),
        .library(name: "ECMA 376 Spreadsheet", targets: ["ECMA 376 Spreadsheet"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-byte.git", branch: "main"),
        .package(url: "https://github.com/swift-iso/swift-iso-21320.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-3986.git", branch: "main"),
        .package(url: "https://github.com/swift-w3c/swift-w3c-xml.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "ECMA 376",
            dependencies: [
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "ISO 21320", package: "swift-iso-21320"),
                .product(name: "RFC 3986", package: "swift-rfc-3986"),
                .product(name: "W3C XML", package: "swift-w3c-xml"),
            ]
        ),
        .target(
            name: "ECMA 376 Wordprocessing",
            dependencies: [
                .target(name: "ECMA 376"),
                .product(name: "W3C XML", package: "swift-w3c-xml"),
            ]
        ),
        .target(
            name: "ECMA 376 Spreadsheet",
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
            name: "ECMA 376 Wordprocessing Tests",
            dependencies: [
                .target(name: "ECMA 376"),
                .target(name: "ECMA 376 Wordprocessing"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "ISO 21320", package: "swift-iso-21320"),
            ]
        ),
        .testTarget(
            name: "ECMA 376 Spreadsheet Tests",
            dependencies: [
                .target(name: "ECMA 376"),
                .target(name: "ECMA 376 Spreadsheet"),
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
