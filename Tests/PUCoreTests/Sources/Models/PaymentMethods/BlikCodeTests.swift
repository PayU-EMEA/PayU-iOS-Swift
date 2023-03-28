//
//  BlikCodeTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class BlikCodeTests: XCTestCase {

  func testMapsCorrectly() throws {
    let sut = BlikCode()

    XCTAssertEqual(sut.brandImageProvider.url, "https://static.payu.com/images/mobile/logos/pbl_blik.png")
    XCTAssertEqual(sut.description, nil)
    XCTAssertEqual(sut.enabled, true)
    XCTAssertEqual(sut.name, "BLIK")
    XCTAssertEqual(sut.value, "blik_code")
  }
}
