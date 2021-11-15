// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreDatable",
    platforms: [
        .iOS(.v15),         //.v8 - .v13
        .macOS(.v10_15),    //.v10_10 - .v10_15
        .tvOS(.v13),        //.v9 - .v13
        .watchOS(.v6),      //.v2 - .v6
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CoreDatable",
            targets: ["CoreDatable"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CoreDatable",
            dependencies: []),
        .testTarget(
            name: "CoreDatableTests",
            dependencies: ["CoreDatable"]),
    ]
)
