//
//  DefaultPaymentCardFormatterTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class DefaultPaymentCardFormatterTests: XCTestCase {

  func testCVVFormatterReturnsCorrectValue() throws {
    let sut = PaymentCardFormatterFactory().makeCVV()
    XCTAssertEqual(sut.formatted("00"), "00")
    XCTAssertEqual(sut.formatted("123"), "123")
    XCTAssertEqual(sut.formatted("4 5 6"), "456")
    XCTAssertEqual(sut.formatted("0 1 2 3"), "012")
  }

  func testDateFormatterReturnsCorrectValue() throws {
    let sut = PaymentCardFormatterFactory().makeDate()
    XCTAssertEqual(sut.formatted("0"), "0")
    XCTAssertEqual(sut.formatted("03"), "03")
    XCTAssertEqual(sut.formatted("032"), "03/2")
    XCTAssertEqual(sut.formatted("0323"), "03/23")
    XCTAssertEqual(sut.formatted("032023"), "03/2023")
    XCTAssertEqual(sut.formatted("a032023"), "03/2023")
  }

  func testNumberFormatterReturnsCorrectValue() throws {
    let sut = PaymentCardFormatterFactory().makeNumber()
    XCTAssertEqual(sut.formatted("4"), "4")
    XCTAssertEqual(sut.formatted("4444"), "4444")
    XCTAssertEqual(sut.formatted("4444333322221111"), "4444 3333 2222 1111")
    XCTAssertEqual(sut.formatted("a4444333322221111"), "4444 3333 2222 1111")
  }
}
