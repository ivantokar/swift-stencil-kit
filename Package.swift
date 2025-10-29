// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MageStencilKit",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MageStencilKit",
            targets: ["MageStencilKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.15.1"),

    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MageStencilKit",
            dependencies: [
                .product(name: "Stencil", package: "Stencil"),
            ],
        ),

        .testTarget(
            name: "MageStencilKitTests",
            dependencies: ["MageStencilKit"]
        ),
    ]
)
