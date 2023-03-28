//
//  ApplePayTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class ApplePayTests: XCTestCase {

  func testMapsCorrectly() throws {
    let sut = decode(type: ApplePay.self, from: "pbl_apple_pay")

    XCTAssertEqual(sut.brandImageProvider.url, "https://static.payu.com/images/mobile/logos/pbl_jp.png")
    XCTAssertEqual(sut.description, nil)
    XCTAssertEqual(sut.enabled, true)

    XCTAssertEqual(sut.brandImageUrl, "https://static.payu.com/images/mobile/logos/pbl_jp.png")
    XCTAssertEqual(sut.name, "Apple Pay")
    XCTAssertEqual(sut.status, PayByLink.Status.enabled)
    XCTAssertEqual(sut.value, "jp")
  }
}
