//
//  String+Translations.swift
//  
//  Created by PayU S.A. on 21/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

public extension String {

  // MARK: - Public Methods
  /// Allow to translate `String` into the given language
  /// - Parameters:
  ///   - numberCategory: ``NumberCategory`` value. Default is ``NumberCategory/singular``
  ///   - languageCodeProvider: implementation of ``LanguageCodeProvider``. Default is ``DefaultLanguageCodeProvider``
  /// - Returns: translated String is exists. Otherwise it returns key to be translated
  func localized(
    numberCategory: NumberCategory = .singular,
    languageCodeProvider: LanguageCodeProvider = DefaultLanguageCodeProvider()
  ) -> String {

    return localized(
      tableName: numberCategory.tableName.rawValue,
      languageCodeProvider: languageCodeProvider)
  }

  // MARK: - Private Methods
  private func localized(
    tableName: String,
    languageCodeProvider: LanguageCodeProvider = DefaultLanguageCodeProvider()
  ) -> String {
    let languageCode = languageCodeProvider.languageCode()
    let localizedString = Bundle
      .bundle(languageCode: languageCode)
      .localizedString(forKey: self, value: nil, table: tableName)

    if self == localizedString {
      Console.console.log("A user-visible string for `\(self)` for `\(languageCode)` not found.")
    }

    return localizedString
  }
}
