//
//  StringExtensionsTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class StringExtensionsTests: XCTestCase {

  func testDigitsOnlyReturnsCorrectValue() throws {
    XCTAssertEqual("1234 abcd".digitsOnly, "1234")
    XCTAssertEqual("abcd abcd".digitsOnly, "")
    XCTAssertEqual("{!@#$%^&*()}".digitsOnly, "")
  }

  func testIsDecimalDigitsReturnsCorrectValue() throws {
    XCTAssertTrue("123456".isDecimalDigits)
    XCTAssertFalse("1234 5678 9012 3456".isDecimalDigits)
    XCTAssertFalse("03/23".isDecimalDigits)
  }

  func testIsBlikCodeReturnsCorrectValue() throws {
    XCTAssertTrue("123456".isBlikCode)
    XCTAssertFalse("12345".isBlikCode)
    XCTAssertFalse("1234567".isBlikCode)
    XCTAssertFalse("123 456".isBlikCode)
    XCTAssertFalse("abcdef".isBlikCode)
  }

  func testIsBlikCodePartReturnsCorrectValue() throws {
    XCTAssertTrue("".isBlikCodePart)
    XCTAssertTrue("1".isBlikCodePart)
    XCTAssertTrue("12345".isBlikCodePart)
    XCTAssertTrue("123456".isBlikCodePart)
    XCTAssertFalse("abc".isBlikCodePart)
    XCTAssertFalse("1234567".isBlikCodePart)
  }

  func testIsCVVReturnsCorrectValue() throws {
    XCTAssertTrue("123".isCVV)
    XCTAssertFalse("12".isCVV)
    XCTAssertFalse("abc".isCVV)
  }
}
