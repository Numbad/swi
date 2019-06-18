// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "evalBack",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura", from:"2.6.0"),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger", from:"1.8.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine", from:"1.11.0")

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "evalBack",
            dependencies: ["Kitura","HeliumLogger","KituraStencil"]),
        .testTarget(
            name: "evalBackTests",
            dependencies: ["evalBack"]),
    ]
)
