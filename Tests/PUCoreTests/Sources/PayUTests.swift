//
//  PayUTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class PayUTests: XCTestCase {

  func testShouldSaveCurrencyCode() throws {
    XCTAssertNil(PayU.currencyCode)

    PayU.currencyCode = "PLN"
    XCTAssertEqual(PayU.currencyCode, "PLN")

    PayU.currencyCode = "EUR"
    XCTAssertEqual(PayU.currencyCode, "EUR")
  }

  func testShouldSaveLanguageCode() throws {
    XCTAssertNil(PayU.languageCode)

    PayU.languageCode = "pl"
    XCTAssertEqual(PayU.languageCode, "pl")

    PayU.languageCode = "uk"
    XCTAssertEqual(PayU.languageCode, "uk")
  }

  func testShouldSavePOS() throws {
    XCTAssertNil(PayU.pos)

    PayU.pos = POS(id: "357902", environment: .sandbox)
    XCTAssertEqual(PayU.pos.id, "357902")
    XCTAssertEqual(PayU.pos.environment, .sandbox)

    PayU.pos = POS(id: "354902", environment: .sandboxBeta)
    XCTAssertEqual(PayU.pos.id, "354902")
    XCTAssertEqual(PayU.pos.environment, .sandboxBeta)
  }
}
