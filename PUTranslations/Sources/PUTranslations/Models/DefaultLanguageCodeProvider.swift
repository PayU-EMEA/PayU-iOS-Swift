//
//  DefaultLanguageCodeProvider.swift
//  
//  Created by PayU S.A. on 21/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

/// Default provider for language code
///
/// Uses `PayU.languageCode` or `Locale.current.languageCode` or `en`
public struct DefaultLanguageCodeProvider: LanguageCodeProvider {

  // MARK: - Initialization
  public init() {  }

  // MARK: - LanguageProviderProtocol

  /// Returns `languageCode` based on PayU business logic
  /// - Returns: `PayU.languageCode` or `Locale.current.languageCode` or `en`
  public func languageCode() -> String {
    PayU.languageCode ?? Locale.current.languageCode ?? "en"
  }
}
