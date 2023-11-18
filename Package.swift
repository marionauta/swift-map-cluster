// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "MapCluster",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "MapCluster",
            targets: ["MapCluster"]),
    ],
    targets: [
        .target(
            name: "MapCluster"),
        .testTarget(
            name: "MapClusterTests",
            dependencies: ["MapCluster"]),
    ]
)
