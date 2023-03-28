//
//  DefaultPaymentCardDateParserTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class DefaultPaymentCardDateParserTests: XCTestCase {

  private var sut: DefaultPaymentCardDateParser!

  override func setUp() {
    super.setUp()
    sut = DefaultPaymentCardDateParser()
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testReturnsCorrectDateForShortFormat() throws {
    let date1 = sut.parse("03/23")
    XCTAssertEqual(date1?.month, 3)
    XCTAssertEqual(date1?.year, 2023)

    let date2 = sut.parse("08/15")
    XCTAssertEqual(date2?.month, 8)
    XCTAssertEqual(date2?.year, 2015)

    let date3 = sut.parse("10/25")
    XCTAssertEqual(date3?.month, 10)
    XCTAssertEqual(date3?.year, 2025)
  }

  func testReturnsCorrectDateForLongFormat() throws {
    let date1 = sut.parse("03/2023")
    XCTAssertEqual(date1?.month, 3)
    XCTAssertEqual(date1?.year, 2023)

    let date2 = sut.parse("08/2015")
    XCTAssertEqual(date2?.month, 8)
    XCTAssertEqual(date2?.year, 2015)

    let date3 = sut.parse("10/2025")
    XCTAssertEqual(date3?.month, 10)
    XCTAssertEqual(date3?.year, 2025)
  }
}
