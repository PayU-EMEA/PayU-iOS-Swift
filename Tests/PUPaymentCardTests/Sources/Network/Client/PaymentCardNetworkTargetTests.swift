//
//  PaymentCardNetworkTargetTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUPaymentCard

final class PaymentCardNetworkTargetTests: XCTestCase {
  func testShouldHaveCorrectPath() throws {
    let sut = PaymentCardNetworkTarget.tokenize(makeTokenCreateRequest())
    XCTAssertEqual(sut.path, "api/v2/token/token.json")
  }

  func testShouldHaveCorrectHTTPMethod() throws {
    let sut = PaymentCardNetworkTarget.tokenize(makeTokenCreateRequest())
    XCTAssertEqual(sut.httpMethod, "POST")
  }

  // TODO: fix problem with data order
  func skipped_testShouldHaveCorrectHTTPBody() throws {
    let httpBody = """
data={\"request\":\"TokenCreateRequest\",\"data\":{\"card\":{\"number\":\"5405 8609 3727 0285\",\"expirationYear\":\"2023\",\"expirationMonth\":\"03\",\"cvv\":\"827\"},\"agreement\":true},\"sender\":\"453872304\"}
"""

    let sut = PaymentCardNetworkTarget.tokenize(makeTokenCreateRequest())
    XCTAssertEqual(sut.httpBody, httpBody.data(using: .utf8))
  }

  func testShouldHaveCorrectHTTPHeaders() throws {
    let sut = PaymentCardNetworkTarget.tokenize(makeTokenCreateRequest())
    XCTAssertEqual(sut.httpHeaders["Content-Type"], "application/x-www-form-urlencoded")
  }
}

private extension PaymentCardNetworkTargetTests {
  func makeTokenCreateRequest() -> TokenCreateRequest {
    TokenCreateRequest(
      sender: "453872304",
      data: TokenCreateRequest.Data(
        agreement: true,
        card: TokenCreateRequest.Data.Card(
          number: "5405 8609 3727 0285",
          expirationMonth: "03",
          expirationYear: "2023",
          cvv: "827"
        )
      )
    )
  }
}
