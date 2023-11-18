// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "MapCluster",
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
