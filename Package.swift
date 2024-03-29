// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reactor",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Reactor",
            targets: ["Reactor"]
        ),
        .executable(name: "Benchmarks", targets: ["Benchmarks"])
    ],
    dependencies: [
        .package(url: "https://github.com/wickwirew/Runtime.git", from: .init(2, 2, 2))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Reactor",
            dependencies: ["Runtime"]
        ),
        .testTarget(
            name: "ReactorTests",
            dependencies: ["Reactor"]
        ),
        .executableTarget(
            name: "Benchmarks",
            dependencies: ["Reactor"],
            path: "Benchmarks"
        )
    ]
)
