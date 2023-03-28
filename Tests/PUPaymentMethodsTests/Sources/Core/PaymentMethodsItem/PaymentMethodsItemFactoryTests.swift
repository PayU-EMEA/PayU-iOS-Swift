//
//  PaymentMethodsItemFactoryTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUCore
@testable import PUPaymentMethods
@testable import PUTranslations

final class PaymentMethodsItemFactoryTests: XCTestCase {

  private var sut: PaymentMethodsItemFactory!

  override func setUp() {
    super.setUp()
    sut = PaymentMethodsItemFactory()
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testShouldReturnPaymentMethodItemApplePayForApplePay() {
    XCTAssertTrue(sut.item(makeApplePay()) is PaymentMethodItemApplePay)
  }

  func testShouldReturnPaymentMethodItemBlikCodeForBlikCode() {
    XCTAssertTrue(sut.item(makeBlikCode()) is PaymentMethodItemBlikCode)
  }

  func testShouldReturnPaymentMethodItemBlikTokenForBlikToken() {
    XCTAssertTrue(sut.item(makeBlikToken()) is PaymentMethodItemBlikToken)
  }

  func testShouldReturnPaymentMethodItemCardTokenForCardToken() {
    XCTAssertTrue(sut.item(makeCardToken()) is PaymentMethodItemCardToken)
  }

  func testShouldReturnPaymentMethodItemInstallmentsForInstallments() {
    XCTAssertTrue(sut.item(makeInstallments()) is PaymentMethodItemInstallments)
  }

  func testShouldReturnPaymentMethodItemPayByLinkForPayByLink() {
    XCTAssertTrue(sut.item(makePayByLink()) is PaymentMethodItemPayByLink)
  }

  func testShouldReturnNilForOtherPaymentMethod() {
    struct UnknownPaymentMethod: PaymentMethod {
      public var brandImageProvider: BrandImageProvider { .blik }
      public let description: String? = nil
      public let enabled: Bool = true
      public let name: String = "UnknownPaymentMethod"
      public let value: String = "UnknownPaymentMethod"
    }

    XCTAssertNil(sut.item(UnknownPaymentMethod()))
  }

}

private extension PaymentMethodsItemFactoryTests {
  func makeBrandImageUrl() -> String {
    "https://www.payu.com/image_\(UUID().uuidString).jpg"
  }

  func makeApplePay() -> ApplePay {
    ApplePay(payByLink: makePayByLink())
  }

  func makeBlikCode() -> BlikCode {
    BlikCode()
  }

  func makeBlikToken() -> BlikToken {
    BlikToken(
      brandImageUrl: makeBrandImageUrl(),
      type: "UID",
      value: "TOKB_nuGYkknycEp3NDWAN2hh1c7FLnXseaLX")
  }

  func makeCardToken() -> CardToken {
    CardToken(
      brandImageUrl: makeBrandImageUrl(),
      cardExpirationMonth: Int.random(in: 1...12),
      cardExpirationYear: Int.random(in: 2023...2033),
      cardNumberMasked: UUID().uuidString,
      cardScheme: UUID().uuidString,
      preferred: false,
      status: .active,
      value: UUID().uuidString
    )
  }

  func makeInstallments() -> Installments {
    Installments(payByLink: makePayByLink())
  }

  func makePayByLink() -> PayByLink {
    PayByLink(
      brandImageUrl: makeBrandImageUrl(),
      name: UUID().uuidString,
      status: .enabled,
      value: UUID().uuidString
    )
  }
}
