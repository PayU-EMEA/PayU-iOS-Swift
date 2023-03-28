//
//  DefaultTextFormatterTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class DefaultTextFormatterTests: XCTestCase {

  func testTextFormatterWithBlikMaskShouldFormatTextCorrectly() throws {
    let sut = TextFormatterFactory().makeBlik()

    XCTAssertEqual(sut.formatted(""), "")
    XCTAssertEqual(sut.formatted("123"), "123")
    XCTAssertEqual(sut.formatted("1 2 3"), "123")
    XCTAssertEqual(sut.formatted("6543210"), "654321")
  }

  func testTextFormatterWithCVVMaskShouldFormatTextCorrectly() throws {
    let sut = TextFormatterFactory().makeCVV()

    XCTAssertEqual(sut.formatted(""), "")
    XCTAssertEqual(sut.formatted("123"), "123")
    XCTAssertEqual(sut.formatted("1 2 3"), "123")
    XCTAssertEqual(sut.formatted("1234"), "123")
  }
}
