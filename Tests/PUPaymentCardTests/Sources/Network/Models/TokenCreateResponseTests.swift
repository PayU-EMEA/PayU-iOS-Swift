//
//  TokenCreateResponseTests.swift
//

import XCTest

@testable import PUAPI
@testable import PUPaymentCard

final class TokenCreateResponseTests: XCTestCase {

  func testShouldKeepPropertiesAfterBeingInitilized() throws {
    let sut = TokenCreateResponse(
      value: "TOK_QWERTYUIOP98765",
      maskedCard: "0000 **** **** 9999"
    )

    XCTAssertEqual(sut.value, "TOK_QWERTYUIOP98765")
    XCTAssertEqual(sut.maskedCard, "0000 **** **** 9999")
  }

}
