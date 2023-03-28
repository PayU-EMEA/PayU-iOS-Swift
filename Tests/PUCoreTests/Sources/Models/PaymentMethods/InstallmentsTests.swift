//
//  InstallmentsTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class InstallmentsTests: XCTestCase {

  func testMapsCorrectly() throws {
    let sut = decode(type: Installments.self, from: "pbl_installments")

    XCTAssertEqual(sut.brandImageProvider.url, "https://static.payu.com/images/mobile/logos/pbl_ai.png")
    XCTAssertEqual(sut.description, nil)
    XCTAssertEqual(sut.enabled, true)

    XCTAssertEqual(sut.brandImageUrl, "https://static.payu.com/images/mobile/logos/pbl_ai.png")
    XCTAssertEqual(sut.name, "Raty PayU")
    XCTAssertEqual(sut.status, PayByLink.Status.enabled)
    XCTAssertEqual(sut.value, "ai")
  }
}
