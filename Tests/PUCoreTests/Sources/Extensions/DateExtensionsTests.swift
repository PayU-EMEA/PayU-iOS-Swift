//
//  DateExtensionsTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class DateExtensionsTests: XCTestCase {

  private var dateFormatter: DateFormatter!

  override func setUp() {
    super.setUp()
    dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
  }

  override func tearDown() {
    super.tearDown()
    dateFormatter = nil
  }

  func testDateInFutureReturnsCorrectValue() throws {
    XCTAssertEqual(dateFormatter.date(from: "03/13/3000")?.isInFuture, true)
    XCTAssertEqual(dateFormatter.date(from: "03/13/2000")?.isInFuture, false)
  }

  func testMonthReturnsCorrectMonth() throws {
    XCTAssertEqual(dateFormatter.date(from: "03/13/2023")?.month, 3)
    XCTAssertEqual(dateFormatter.date(from: "08/13/2023")?.month, 8)
  }

  func testYearReturnsCorrectYear() throws {
    XCTAssertEqual(dateFormatter.date(from: "03/13/2023")?.year, 2023)
    XCTAssertEqual(dateFormatter.date(from: "03/13/1999")?.year, 1999)
    XCTAssertEqual(dateFormatter.date(from: "03/13/3000")?.year, 3000)
  }
}
