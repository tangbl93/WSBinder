// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WSBinder",
    products: [
        .library(name: "WSBinder", targets: ["WSBinder"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "WSBinder", dependencies: []),
        .testTarget(name: "WSBinderTests", dependencies: ["WSBinder"]),
    ]
)
