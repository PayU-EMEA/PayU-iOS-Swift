//
//  PaymentMethodWidgetTests.swift
//
//  Copyright © PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore
@testable import PUPaymentMethods

final class PaymentMethodWidgetTests: XCTestCase {
  private var configuration: PaymentMethodsConfiguration!
  private var storage: PaymentMethodsStorageProtocolMock!
  private var sut: PaymentMethodsWidget!

  override func setUp() {
    super.setUp()
    storage = PaymentMethodsStorageProtocolMock()
  }

  func testWhenStorageReturnsSelectedPaymentValueThenShouldReturnPaymentMethod() {
    let payByLink = makePayByLink()
    let payByLinks: [PayByLink] = [payByLink]

    configuration = PaymentMethodsConfiguration(
      payByLinks: payByLinks)

    storage.getSelectedPaymentMethodValueHandler = { payByLink.value }

    sut = PaymentMethodsWidget.Factory().make(
      configuration: configuration,
      storage: storage)

    XCTAssertEqual(sut.paymentMethod?.value, payByLink.value)
  }
    
  func testWhenStorageReturnsApplePayPaymentValueThenShouldReturnCorrectTypeOfApplePay() {
    let payByLink = makePayByLink(value: "jp")
    let payByLinks: [PayByLink] = [payByLink]

    configuration = PaymentMethodsConfiguration(
      payByLinks: payByLinks)

    storage.getSelectedPaymentMethodValueHandler = { payByLink.value }

    sut = PaymentMethodsWidget.Factory().make(
      configuration: configuration,
      storage: storage)

    XCTAssertEqual(sut.paymentMethod?.value, payByLink.value)
    XCTAssertTrue(sut.paymentMethod is ApplePay)
  }

  func testWhenStorageReturnsEmptyValueThenShouldReturnPaymentMethod() {
    let payByLink = makePayByLink()
    let payByLinks: [PayByLink] = [payByLink]

    configuration = PaymentMethodsConfiguration(
      payByLinks: payByLinks)

    sut = PaymentMethodsWidget.Factory().make(
      configuration: configuration,
      storage: storage)

    XCTAssertNil(sut.paymentMethod)
  }
}

private extension PaymentMethodWidgetTests {
  func makeBrandImageUrl() -> String {
    "https://www.payu.com/image_\(UUID().uuidString).jpg"
  }

  func makePayByLink(value: String? = nil) -> PayByLink {
    PayByLink(
      brandImageUrl: makeBrandImageUrl(),
      name: UUID().uuidString,
      status: .enabled,
      value: value ?? UUID().uuidString
    )
  }
}
