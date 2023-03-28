//
//  DefaultLanguageProvider.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import Foundation

/// Protocol which allows to define the primary `languageCode` for translations
public protocol LanguageCodeProvider {

  /// Method to be implemented by instance
  /// - Returns: The language code for the locale (for ex: `en`, `pl`)
  func languageCode() -> String
}
