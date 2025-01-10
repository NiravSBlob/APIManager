// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APIManager",
    platforms: [
           .iOS(.v12),  // Specify the minimum platform version
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "APIManager",
            targets: ["APIManager"]),
    ],
    dependencies: [
            // Add Alamofire and SwiftyJSON dependencies
            .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.0"),
            .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.1")
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "APIManager",
            dependencies: [
                        .product(name: "Alamofire", package: "Alamofire"),
                        .product(name: "SwiftyJSON", package: "SwiftyJSON")
                    ]
            ),
        .testTarget(
            name: "APIManagerTests",
            dependencies: ["APIManager"]),
    ]
)
