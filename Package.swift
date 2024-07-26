// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "AvalonThree",
    products: [
        .library(
            name: "AvalonThree",
            targets: ["AvalonThree"]
        )
    ],
    targets: [
        .target(
            name: "AvalonThree"
        ),
        .testTarget(
            name: "AvalonThreeTests",
            dependencies: ["AvalonThree"]
        ),
    ]
)
