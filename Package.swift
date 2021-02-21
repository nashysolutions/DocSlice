// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DocSlice",
    platforms: [.iOS(.v13), .macOS(.v10_13)],
    products: [
        .executable(name: "docslice", targets: ["DocSlice"]),
        .library(name: "Slice", targets: ["Slice"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/JohnSundell/Files.git", .upToNextMinor(from: "4.2.0")),
    ],
    targets: [
        .target(
            name: "DocSlice",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Files", package: "Files"),
                .target(name: "Slice")
            ],
            linkerSettings: [
                .linkedFramework("PDFKit")
            ]
        ),
        .target(
            name: "Slice",
            dependencies: [
                .product(name: "Files", package: "Files")
            ]),
        .testTarget(
            name: "SliceTests",
            dependencies: [
                .product(name: "Files", package: "Files"),
                .target(name: "Slice")
            ],
            resources: [
                .process("Resources")
            ],
            linkerSettings: [
                .linkedFramework("PDFKit")
            ]
        ),
    ]
)
