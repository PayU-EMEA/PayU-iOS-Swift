//
//  CardTokenTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class CardTokenTests: XCTestCase {

  func testMapsCorrectly() throws {
    let sut = decode(type: CardToken.self, from: "pbl_card_token")

    XCTAssertEqual(sut.brandImageProvider.url, "https://static.payu.com/images/mobile/visa_off.png")
    XCTAssertEqual(sut.description, "1/2019")
    XCTAssertEqual(sut.enabled, false)

    XCTAssertEqual(sut.brandImageUrl, "https://static.payu.com/images/mobile/visa_off.png")
    XCTAssertEqual(sut.cardExpirationMonth, 1)
    XCTAssertEqual(sut.cardExpirationYear, 2019)
    XCTAssertEqual(sut.cardNumberMasked, "401200******1112")
    XCTAssertEqual(sut.cardScheme, "VS")
    XCTAssertEqual(sut.preferred, false)
    XCTAssertEqual(sut.status, CardToken.Status.expired)
    XCTAssertEqual(sut.value, "TOKC_QPY10DEHHLWPOMJIV5LWUZHG2DG")
  }
}
