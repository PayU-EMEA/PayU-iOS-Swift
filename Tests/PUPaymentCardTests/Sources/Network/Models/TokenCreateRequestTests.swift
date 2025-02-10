//
//  TokenCreateRequestTests.swift
//

import XCTest

@testable import PUPaymentCard

final class TokenCreateRequestTests: XCTestCase {

  func testShouldKeepPropertiesAfterBeingInitilized() throws {
    let sut = TokenCreateRequest(
      posId: "2093489029024",
      type: TokenType.MULTI.rawValue,
      card: PaymentCard(
        number: "4012 0010 3714 1112",
        expirationMonth: "03",
        expirationYear: "23",
        cvv: "953"
      )
    )

    XCTAssertEqual(sut.posId, "2093489029024")
    XCTAssertEqual(sut.type, "MULTI")
    XCTAssertEqual(sut.card.number, "4012 0010 3714 1112")
    XCTAssertEqual(sut.card.expirationMonth, "03")
    XCTAssertEqual(sut.card.expirationYear, "23")
    XCTAssertEqual(sut.card.cvv, "953")
  }

}
