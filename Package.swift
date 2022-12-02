// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PollfishMaxAdapter",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "PollfishMaxAdapter",
            targets: ["PollfishMaxAdapter", "Wrapper"])
    ],
    dependencies: [
        .package(
            name: "AppLovinSDK",
            url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git",
            "11.0.0" ..< "12.0.0"
        ),
        .package(
            name: "Pollfish",
            url: "https://github.com/pollfish/ios-sdk-pollfish.git",
            .exact("6.3.0")
        )
    ],
    targets: [
        .target(
            name: "Wrapper",
            dependencies: ["Pollfish", "AppLovinSDK"],
            path: "Wrapper"
        ),
        .binaryTarget(
            name: "PollfishMaxAdapter",
            path: "PollfishMaxAdapter.xcframework"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
