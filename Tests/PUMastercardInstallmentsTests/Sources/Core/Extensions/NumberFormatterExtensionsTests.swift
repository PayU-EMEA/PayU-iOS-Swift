//
//  NumberFormatterExtensionsTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUMastercardInstallments

final class NumberFormatterExtensionsTests: XCTestCase {

  func testNumberFormatterWithPercentNumberStyleShouldFormatTextCorrectly() throws {
    let sut = NumberFormatter.percent
    XCTAssertEqual(sut.string(from: NSNumber(value: 5.4)), "5.4%")
    XCTAssertEqual(sut.string(from: NSNumber(value: 0.5)), "0.5%")
  }

  func testNumberFormatterWithPriceNumberStyleShouldFormatTextCorrectly() throws {
    let sut = NumberFormatter.price(currencyCode: "PLN")
    XCTAssertEqual(sut.string(from: NSNumber(value: 5.4)), "PLN 0.05")
    XCTAssertEqual(sut.string(from: NSNumber(value: 0.5)), "PLN 0.00")
    XCTAssertEqual(sut.string(from: NSNumber(value: 10123.0)), "PLN 101.23")
    XCTAssertEqual(sut.string(from: NSNumber(value: 9665.0)), "PLN 96.65")
  }
}
