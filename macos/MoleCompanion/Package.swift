// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MoleCompanion",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "MoleCompanion",
            targets: ["MoleCompanion"]
        )
    ],
    targets: [
        .executableTarget(
            name: "MoleCompanion",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
