//
//  PKPaymentRequestExtensionsTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import PassKit
@testable import PUApplePay

final class PKPaymentRequestExtensionsTests: XCTestCase {

  private var sut: PKPaymentRequest!

  override func setUp() {
    super.setUp()
    sut = PKPaymentRequest
      .Builder()
      .withCountryCode("PL")
      .withCurrencyCode("PLN")
      .withMerchantIdentifier("merchant.identifier")
      .withPaymentSummaryItems(
        [
          PaymentRequest
            .SummaryItem(
              label: "Apple",
              amount: 50
            ),
          PaymentRequest
            .SummaryItem(
              label: "Orange",
              amount: 100
            )
        ]
      )
      .withShippingContact(
        PaymentRequest
          .Contact(
            emailAddress: "tester@test.com")
      ).build()
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testShouldHaveExpectedCountryCode() throws {
    XCTAssertEqual(sut.countryCode, "PL")
  }

  func testShouldHaveExpectedCurrencyCode() throws {
    XCTAssertEqual(sut.currencyCode, "PLN")
  }

  func testShouldHaveExpectedMerchantIdentifier() throws {
    XCTAssertEqual(sut.merchantIdentifier, "merchant.identifier")
  }

  func testShouldHaveExpectedPaymentSummaryItems() throws {
    XCTAssertEqual(sut.paymentSummaryItems.count, 2)

    XCTAssertEqual(sut.paymentSummaryItems[0].label, "Apple")
    XCTAssertEqual(sut.paymentSummaryItems[0].amount, NSDecimalNumber(string: "0.5"))

    XCTAssertEqual(sut.paymentSummaryItems[1].label, "Orange")
    XCTAssertEqual(sut.paymentSummaryItems[1].amount, NSDecimalNumber(string: "1"))
  }

  func testShouldHaveExpectedShippingContact() throws {
    XCTAssertEqual(sut.shippingContact?.emailAddress, "tester@test.com")
  }
}
