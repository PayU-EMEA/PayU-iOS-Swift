//
//  StringExtensionsTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore
@testable import PUTranslations

final class StringExtensionsTests: XCTestCase {

  private var languageCodeProvider: LanguageCodeProviderMock!

  override func setUp() {
    super.setUp()
    languageCodeProvider = LanguageCodeProviderMock()
  }

  override func tearDown() {
    super.tearDown()
    languageCodeProvider = nil
  }

  func testShoudReturnSingularTranslationForSingularTableInEnglish() throws {
    languageCodeProvider.languageCodeHandler = { "en" }

    XCTAssertEqual(
      "card_number"
        .localized(
          numberCategory: .singular,
          languageCodeProvider: languageCodeProvider
        ),
      "Card number")
  }

  func testShoudNotReturnSingularTranslationForPluralTableInEnglish() throws {
    languageCodeProvider.languageCodeHandler = { "en" }

    XCTAssertEqual(
      "card_number"
        .localized(
          numberCategory: .plural,
          languageCodeProvider: languageCodeProvider
        ),
      "card_number")
  }


  func testShoudReturnSingularTranslationForSingularTableInSpanish() throws {
    languageCodeProvider.languageCodeHandler = { "es" }

    XCTAssertEqual(
      "card_number"
        .localized(
          numberCategory: .singular,
          languageCodeProvider: languageCodeProvider
        ),
      "Numero de tarjeta")
  }

  func testShoudNotReturnSingularTranslationForPluralTableInSpanish() throws {
    languageCodeProvider.languageCodeHandler = { "es" }

    XCTAssertEqual(
      "card_number"
        .localized(
          numberCategory: .plural,
          languageCodeProvider: languageCodeProvider
        ),
      "card_number")
  }
}
