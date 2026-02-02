//
//  StringExtensionsTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUCore
@testable import PUTranslations

final class StringExtensionsTests: XCTestCase {

  private var languageCodeProvider: LanguageCodeProviderMock!

  override func setUp() {
    super.setUp()
    languageCodeProvider = mock(LanguageCodeProvider.self)
  }

  override func tearDown() {
    super.tearDown()
    reset(languageCodeProvider)
  }

  func testShoudReturnSingularTranslationForSingularTableInEnglish() throws {
    given(languageCodeProvider.languageCode()).willReturn("en")

    XCTAssertEqual(
      "card_number"
        .localized(
          numberCategory: .singular,
          languageCodeProvider: languageCodeProvider
        ),
      "Card number")
  }

  func testShoudNotReturnSingularTranslationForPluralTableInEnglish() throws {
    given(languageCodeProvider.languageCode()).willReturn("en")

    XCTAssertEqual(
      "card_number"
        .localized(
          numberCategory: .plural,
          languageCodeProvider: languageCodeProvider
        ),
      "card_number")
  }


  func testShoudReturnSingularTranslationForSingularTableInSpanish() throws {
    given(languageCodeProvider.languageCode()).willReturn("es")

    XCTAssertEqual(
      "card_number"
        .localized(
          numberCategory: .singular,
          languageCodeProvider: languageCodeProvider
        ),
      "Numero de tarjeta")
  }

  func testShoudNotReturnSingularTranslationForPluralTableInSpanish() throws {
    given(languageCodeProvider.languageCode()).willReturn("es")

    XCTAssertEqual(
      "card_number"
        .localized(
          numberCategory: .plural,
          languageCodeProvider: languageCodeProvider
        ),
      "card_number")
  }
}
