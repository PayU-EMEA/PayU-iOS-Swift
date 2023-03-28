//
//  PaymentCardProviderFinderTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUCore

final class PaymentCardProviderFinderTests: XCTestCase {

  private var luhnValidator: PaymentCardLuhnValidatorProtocolMock!
  private var sut: DefaultPaymentCardProviderFinder!

  override func setUp() {
    super.setUp()
    luhnValidator = mock(PaymentCardLuhnValidatorProtocol.self)
    sut = DefaultPaymentCardProviderFinder(luhnValidator: luhnValidator)
  }

  override func tearDown() {
    super.tearDown()
    reset(luhnValidator)
    sut = nil
  }

  func testFindPaymentCardProviderWhenPaymentCardNumberIsCorrect() throws {
    given(luhnValidator.matches(any())).willReturn(true)

    XCTAssertEqual(sut.find("4444 3333 2222 1111"), .visa)
    XCTAssertEqual(sut.find("5434 0210 1682 4014"), .mastercard)
    XCTAssertEqual(sut.find("5598 6148 1656 3766"), .mastercard)
    XCTAssertEqual(sut.find("4532 5980 2110 4999"), .visa)
  }

  func testFindNothingWhenPaymentCardNumberIsNotCorrect() throws {
    given(luhnValidator.matches(any())).willReturn(true)

    XCTAssertNil(sut.find("4444 3336 2222 111"))
    XCTAssertNil(sut.find("5434 0216 1682 401"))
    XCTAssertNil(sut.find("5598 6146 1656 376"))
    XCTAssertNil(sut.find("4532 5986 2110 499"))
  }

  func testFindNothingWhenLuhnValidatorCannotValidatePaymentCardNumber() throws {
    given(luhnValidator.matches(any())).willReturn(false)

    XCTAssertNil(sut.find("4444 3333 2222 1111"))
    XCTAssertNil(sut.find("5434 0210 1682 4014"))
    XCTAssertNil(sut.find("5598 6148 1656 3766"))
    XCTAssertNil(sut.find("4532 5980 2110 4999"))
  }

  func testPossiblePaymentCardProviderWhenPaymentCardNumberIsCorrect() throws {
    XCTAssertNil(sut.possible(""))

    XCTAssertEqual(sut.possible("444"), .visa)
    XCTAssertEqual(sut.possible("543"), .mastercard)
    XCTAssertEqual(sut.possible("559"), .mastercard)
    XCTAssertEqual(sut.possible("453"), .visa)
  }
}
