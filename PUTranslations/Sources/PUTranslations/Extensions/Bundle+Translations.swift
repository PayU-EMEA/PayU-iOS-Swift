//
//  Bundle+Translations.swift
//  
//  Created by PayU S.A. on 21/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

extension Bundle {
  static func bundle(languageCode: String) -> Bundle {
    let currentBundle = Bundle.current(.PUTranslations)
    guard let path = currentBundle.path(
      forResource: languageCode,
      ofType: "lproj")
    else { return currentBundle }
    return Bundle(path: path) ?? currentBundle
  }
}
