//
//  PaymentRequestTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import PassKit
@testable import PUApplePay

final class PaymentRequestTests: XCTestCase {

  private var sut: PaymentRequest!

  override func setUp() {
    super.setUp()
    sut = PaymentRequest(
      countryCode: "UA",
      currencyCode: "UAH",
      merchantIdentifier: "merchant.identifier",
      paymentSummaryItems: [
        PaymentRequest
          .SummaryItem(
            label: "Apple",
            amount: 150
          ),
        PaymentRequest
          .SummaryItem(
            label: "Orange",
            amount: 250
          )
      ],
      shippingContact: PaymentRequest
        .Contact(
          emailAddress: "email@address.com"
        )
      )
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testShouldHaveExpectedCountryCode() throws {
    XCTAssertEqual(sut.countryCode, "UA")
  }

  func testShouldHaveExpectedCurrencyCode() throws {
    XCTAssertEqual(sut.currencyCode, "UAH")
  }

  func testShouldHaveExpectedMerchantIdentifier() throws {
    XCTAssertEqual(sut.merchantIdentifier, "merchant.identifier")
  }

  func testShouldHaveExpectedPaymentSummaryItems() throws {
    XCTAssertEqual(sut.paymentSummaryItems.count, 2)

    XCTAssertEqual(sut.paymentSummaryItems[0].label, "Apple")
    XCTAssertEqual(sut.paymentSummaryItems[0].amount, 150)

    XCTAssertEqual(sut.paymentSummaryItems[1].label, "Orange")
    XCTAssertEqual(sut.paymentSummaryItems[1].amount, 250)
  }

  func testShouldHaveExpectedShippingContact() throws {
    XCTAssertEqual(sut.shippingContact?.emailAddress, "email@address.com")
  }
}
