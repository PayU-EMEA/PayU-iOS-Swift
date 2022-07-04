// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PayU_SDK_Lite",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "PayU_SDK_Lite",
            targets: ["PayU_SDK_Lite"]
        ),
    ],
    targets: [
      .binaryTarget(
        name: "PayU_SDK_Lite",
        path: "libs/PayU_SDK_Lite.xcframework"
      )
    ],
    swiftLanguageVersions: [.v5]
)
