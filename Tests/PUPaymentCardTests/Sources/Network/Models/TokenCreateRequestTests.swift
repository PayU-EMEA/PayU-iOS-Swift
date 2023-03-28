//
//  TokenCreateRequestTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUPaymentCard

final class TokenCreateRequestTests: XCTestCase {

  func testShouldKeepPropertiesAfterBeingInitilized() throws {
    let sut = TokenCreateRequest(
      sender: "2093489029024",
      data: TokenCreateRequest.Data(
        agreement: true,
        card: TokenCreateRequest.Data.Card(
          number: "4012 0010 3714 1112",
          expirationMonth: "03",
          expirationYear: "23",
          cvv: "953")))

    XCTAssertEqual(sut.sender, "2093489029024")
    XCTAssertEqual(sut.data.agreement, true)
    XCTAssertEqual(sut.data.card.number, "4012 0010 3714 1112")
    XCTAssertEqual(sut.data.card.expirationMonth, "03")
    XCTAssertEqual(sut.data.card.expirationYear, "23")
    XCTAssertEqual(sut.data.card.cvv, "953")
  }

}
