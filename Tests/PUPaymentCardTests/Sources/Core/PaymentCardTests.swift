//
//  PaymentCardTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUPaymentCard

final class PaymentCardTests: XCTestCase {

  private var number: String!
  private var expirationMonth: String!
  private var expirationYear: String!
  private var cvv: String!

  override func setUp() {
    super.setUp()
    number = UUID().uuidString
    expirationMonth = UUID().uuidString
    expirationYear = UUID().uuidString
    cvv = UUID().uuidString
  }

  override func tearDown() {
    super.tearDown()
    number = nil
    expirationMonth = nil
    expirationYear = nil
    cvv = nil
  }

  func testShouldKeepPropertiesAfterBeingInitilized() throws {
    let sut = PaymentCard(
      number: number,
      expirationMonth: expirationMonth,
      expirationYear: expirationYear,
      cvv: cvv)

    XCTAssertEqual(sut.number, number)
    XCTAssertEqual(sut.expirationMonth, expirationMonth)
    XCTAssertEqual(sut.expirationYear, expirationYear)
    XCTAssertEqual(sut.cvv, cvv)
  }

}
