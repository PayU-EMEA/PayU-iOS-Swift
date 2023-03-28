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
      "transaction_approved"
        .localized(
          numberCategory: .singular,
          languageCodeProvider: languageCodeProvider
        ),
      "Transaction approved")
  }

  func testShoudNotReturnSingularTranslationForPluralTableInEnglish() throws {
    given(languageCodeProvider.languageCode()).willReturn("en")

    XCTAssertEqual(
      "transaction_approved"
        .localized(
          numberCategory: .plural,
          languageCodeProvider: languageCodeProvider
        ),
      "transaction_approved")
  }


  func testShoudReturnSingularTranslationForSingularTableInSpanish() throws {
    given(languageCodeProvider.languageCode()).willReturn("es")

    XCTAssertEqual(
      "transaction_approved"
        .localized(
          numberCategory: .singular,
          languageCodeProvider: languageCodeProvider
        ),
      "Transaccion aprobada")
  }

  func testShoudNotReturnSingularTranslationForPluralTableInSpanish() throws {
    given(languageCodeProvider.languageCode()).willReturn("es")

    XCTAssertEqual(
      "transaction_approved"
        .localized(
          numberCategory: .plural,
          languageCodeProvider: languageCodeProvider
        ),
      "transaction_approved")
  }

  func testShoudReturnPluralTranslationForPluralTableInEnglish() throws {
    given(languageCodeProvider.languageCode()).willReturn("en")

    XCTAssertEqual(
      String(
        format: "number_of_installments"
          .localized(
            numberCategory: .plural,
            languageCodeProvider: languageCodeProvider
          ),
        0),
      "0 installments")

    XCTAssertEqual(
      String(
        format: "number_of_installments"
          .localized(
            numberCategory: .plural,
            languageCodeProvider: languageCodeProvider
          ),
        1),
      "1 installment")
  }

  func testShoudNotReturnPluralTranslationForSingularTableInEnglish() throws {
    given(languageCodeProvider.languageCode()).willReturn("en")

    XCTAssertEqual(
      String(
        format: "number_of_installments"
          .localized(
            numberCategory: .singular,
            languageCodeProvider: languageCodeProvider
          ),
        1),
      "number_of_installments")
  }

  func testShoudReturnPluralTranslationForPluralTableInPolish() throws {
    given(languageCodeProvider.languageCode()).willReturn("pl")

    XCTAssertEqual(
      String(
        format: "number_of_installments"
          .localized(
            numberCategory: .plural,
            languageCodeProvider: languageCodeProvider
          ),
        0),
      "0 rat")

    XCTAssertEqual(
      String(
        format: "number_of_installments"
          .localized(
            numberCategory: .plural,
            languageCodeProvider: languageCodeProvider
          ),
        1),
      "1 rata")
  }

  func testShoudNotReturnPluralTranslationForSingularTableInPolish() throws {
    given(languageCodeProvider.languageCode()).willReturn("pl")

    XCTAssertEqual(
      String(
        format: "number_of_installments"
          .localized(
            numberCategory: .singular,
            languageCodeProvider: languageCodeProvider
          ),
        1),
      "number_of_installments")
  }
}
