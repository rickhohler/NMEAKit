// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "NMEAKit",
    products: [
        .library(
            name: "NMEAKit",
            targets: ["NMEAKit"]),
    ],
    targets: [
        .target(
            name: "NMEAKit"),
        .testTarget(
            name: "NMEAKitTests",
            dependencies: ["NMEAKit"]),
    ]
)
