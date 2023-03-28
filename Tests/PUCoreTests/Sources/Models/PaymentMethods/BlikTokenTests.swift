//
//  BlikTokenTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class BlikTokenTests: XCTestCase {

  func testMapsCorrectly() throws {
    let sut = decode(type: BlikToken.self, from: "pbl_blik_token")

    XCTAssertEqual(sut.brandImageProvider.url, "https://static.payu.com/images/mobile/logos/pbl_blik.png")
    XCTAssertEqual(sut.description, nil)
    XCTAssertEqual(sut.enabled, true)

    XCTAssertEqual(sut.brandImageUrl, "https://static.payu.com/images/mobile/logos/pbl_blik.png")
    XCTAssertEqual(sut.name, "BLIK")
    XCTAssertEqual(sut.type, "UID")
    XCTAssertEqual(sut.value, "TOKB_nuGYkknycEp3NDWAN2hh1c7FLnXseaLX")
  }
}
