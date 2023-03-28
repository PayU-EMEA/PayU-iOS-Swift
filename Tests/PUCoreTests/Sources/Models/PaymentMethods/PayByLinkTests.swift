//
//  PayByLinkTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class PayByLinkTests: XCTestCase {

  func testMapsCorrectly() throws {
    let sut = decode(type: PayByLink.self, from: "pbl_pay_by_link")

    XCTAssertEqual(sut.brandImageProvider.url, "https://static.payu.com/images/mobile/logos/pbl_m.png")
    XCTAssertEqual(sut.description, nil)
    XCTAssertEqual(sut.enabled, true)

    XCTAssertEqual(sut.brandImageUrl, "https://static.payu.com/images/mobile/logos/pbl_m.png")
    XCTAssertEqual(sut.name, "mTransfer")
    XCTAssertEqual(sut.status, PayByLink.Status.enabled)
    XCTAssertEqual(sut.value, "m")
  }
}
