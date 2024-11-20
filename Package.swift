// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PUSDK",
  defaultLocalization: "pl",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "PUSDK",
      targets: [
        "PUSDK"
      ]
    ),
    .library(
      name: "PUAPI",
      targets: [
        "PUAPI"
      ]
    ),
    .library(
      name: "PUApplePay",
      targets: [
        "PUApplePay"
      ]
    ),
    .library(
      name: "PUCore",
      targets: [
        "PUCore"
      ]
    ),
    .library(
      name: "PUPaymentCard",
      targets: [
        "PUPaymentCard"
      ]
    ),
    .library(
      name: "PUPaymentCardScanner",
      targets: [
        "PUPaymentCardScanner"
      ]
    ),
    .library(
      name: "PUPaymentMethods",
      targets: [
        "PUPaymentMethods"
      ]
    ),
    .library(
      name: "PUTheme",
      targets: [
        "PUTheme"
      ]
    ),
    .library(
      name: "PUThreeDS",
      targets: [
        "PUThreeDS"
      ]
    ),
    .library(
      name: "PUTranslations",
      targets: [
        "PUTranslations"
      ]
    ),
    .library(
      name: "PUWebPayments",
      targets: [
        "PUWebPayments"
      ]
    ),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(
      url: "https://github.com/onevcat/Kingfisher.git",
       .upToNextMinor(from: .init(8, 1, 0))
    ),
    .package(
      url: "https://github.com/birdrides/mockingbird",
      .upToNextMinor(from: .init(0, 20, 0))
    ),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "PUAPI",
      dependencies: [
        "PUCore"
      ],
      path: "PUAPI",
      resources: [
        .copy("../PUAPI/Sources/PUAPI/Certificates/entrust-root-certificate-authority-G2.cer"),
        .copy("../PUAPI/Sources/PUAPI/Certificates/payu-root-ca-01.cer")
      ]
    ),
    .target(
      name: "PUApplePay",
      dependencies: [],
      path: "PUApplePay",
      linkerSettings: [
        .linkedFramework(
          "PassKit",
            .when(
              platforms: [
                .iOS
              ]
            )
        )
      ]
    ),
    .target(
      name: "PUCore",
      dependencies: [],
      path: "PUCore",
      resources: [
        .process("../PUCore/Resources/Media.xcassets")
      ],
      linkerSettings: [
        .linkedFramework(
          "UIKit",
            .when(
              platforms: [
                .iOS
              ]
            )
        )
      ]
    ),
    .target(
      name: "PUPaymentCard",
      dependencies: [
        "PUAPI",
        "PUCore",
        "PUPaymentCardScanner",
        "PUTheme",
        "PUTranslations"
      ],
      path: "PUPaymentCard",
      resources: [
        .process("../PUPaymentCard/Sources/PUPaymentCard/Resources/cards.json")
      ]
    ),
    .target(
      name: "PUPaymentCardScanner",
      dependencies: [
        "PUCore",
        "PUTheme",
        "PUTranslations"
      ],
      path: "PUPaymentCardScanner"
    ),
    .target(
      name: "PUPaymentMethods",
      dependencies: [
        "PUApplePay",
        "PUCore",
        "PUPaymentCard",
        "PUTheme",
        "PUTranslations"
      ],
      path: "PUPaymentMethods"
    ),
    .target(
      name: "PUSDK",
      dependencies: [
        "PUAPI",
        "PUCore",
        "PUPaymentCard",
        "PUPaymentCardScanner",
        "PUPaymentMethods",
        "PUTheme",
        "PUThreeDS",
        "PUTranslations",
        "PUWebPayments"
      ],
      path: "PUSDK",
      resources: [.copy("Resources/PrivacyInfo.xcprivacy")]
    ),
    .target(
      name: "PUTheme",
      dependencies: [
        "PUCore",
        "Kingfisher"
      ],
      path: "PUTheme",
      resources: [
        .process("../PUTheme/Sources/PUTheme/Resources")
      ],
      linkerSettings: [
        .linkedFramework(
          "UIKit",
            .when(
              platforms: [
                .iOS
              ]
            )
        )
      ]
    ),
    .target(
      name: "PUThreeDS",
      dependencies: [
        "PUAPI",
        "PUCore",
      ],
      path: "PUThreeDS"
    ),
    .target(
      name: "PUTranslations",
      dependencies: [
        "PUCore"
      ],
      path: "PUTranslations",
      resources: [
        .process("../PUTranslations/Sources/PUTranslations/Resources")
      ]
    ),
    .target(
      name: "PUWebPayments",
      dependencies: [
        "PUAPI",
        "PUCore",
        "PUTheme",
        "PUTranslations"
      ],
      path: "PUWebPayments"
    ),
    .testTarget(
      name: "PUAPITests",
      dependencies: [
        "PUAPI",
        "PUCore"
      ]
    ),
    .testTarget(
      name: "PUApplePayTests",
      dependencies: [
        "PUApplePay"
      ]
    ),
    .testTarget(
      name: "PUCoreTests",
      dependencies: [
        "PUCore",
        .product(
          name: "Mockingbird",
          package: "mockingbird"
        )
      ],
      resources: [
        .process("../PUCoreTests/Data/Files")
      ]
    ),
    .testTarget(
      name: "PUPaymentCardTests",
      dependencies: [
        "PUAPI",
        "PUCore",
        "PUPaymentCard",
        "PUPaymentCardScanner",
        .product(
          name: "Mockingbird",
          package: "mockingbird"
        )
      ]
    ),
    .testTarget(
      name: "PUPaymentCardScannerTests",
      dependencies: [
        "PUCore",
        "PUPaymentCardScanner",
        .product(
          name: "Mockingbird",
          package: "mockingbird"
        )
      ]
    ),
    .testTarget(
      name: "PUPaymentMethodsTests",
      dependencies: [
        "PUApplePay",
        "PUCore",
        "PUPaymentCard",
        "PUPaymentMethods",
        "PUTranslations",
        .product(
          name: "Mockingbird",
          package: "mockingbird"
        ),
      ],
      resources: [
        .process("../PUPaymentMethodsTests/Data/Files")
      ]
    ),
    .testTarget(
      name: "PUSDKTests",
      dependencies: [
        "PUSDK"
      ]
    ),
    .testTarget(
      name: "PUThreeDSTests",
      dependencies: [
        "PUAPI",
        "PUCore",
        "PUTheme",
        "PUThreeDS",
        .product(
          name: "Mockingbird",
          package: "mockingbird"
        )
      ]
    ),
    .testTarget(
      name: "PUTranslationsTests",
      dependencies: [
        "PUCore",
        "PUTranslations",
        .product(
          name: "Mockingbird",
          package: "mockingbird"
        )
      ]
    ),
    .testTarget(
      name: "PUWebPaymentsTests",
      dependencies: [
        "PUAPI",
        "PUWebPayments",
        .product(
          name: "Mockingbird",
          package: "mockingbird"
        )
      ]
    )
  ]
)
