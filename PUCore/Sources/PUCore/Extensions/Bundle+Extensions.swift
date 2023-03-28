//
//  Bundle+Extensions.swift
//  
//  Created by PayU S.A. on 27/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//
// https://developer.apple.com/forums/thread/652736

import class Foundation.Bundle

private class BundleFinder {}

public extension Foundation.Bundle {

  enum Package: String {
    case PUAPI = "PUAPI"
    case PUCore = "PUCore"
    case PUPaymentCard = "PUPaymentCard"
    case PUTheme = "PUTheme"
    case PUTranslations = "PUTranslations"

    case PUCoreTests = "PUCoreTests"
    case PUMastercardInstallmentsTests = "PUMastercardInstallmentsTests"
    case PUPaymentMethodsTests = "PUPaymentMethodsTests"

  }

  /// Returns the resource bundle associated with the current Swift module.
  static func current(_ package: Package) -> Bundle {
    let bundleName = "PUSDK_\(package.rawValue)"
    let candidates = [
      Bundle.main.resourceURL,
      Bundle(for: BundleFinder.self).resourceURL,
      Bundle.main.bundleURL,
    ]
    for candidate in candidates {
      let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
      if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
        return bundle
      }
    }

    return Bundle(for: BundleFinder.self)
  }
}
