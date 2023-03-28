//
//  PaymentMethodsItemTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUCore
@testable import PUPaymentMethods
@testable import PUTranslations

final class PaymentMethodsItemTests: XCTestCase {

  private var languageCodeProvider: LanguageCodeProviderMock!

  override func setUp() {
    super.setUp()
    languageCodeProvider = mock(LanguageCodeProvider.self)
    given(languageCodeProvider.languageCode()).willReturn("en")
  }

  override func tearDown() {
    super.tearDown()
    reset(languageCodeProvider)
  }

  func testPaymentMethodItemApplePayShouldReturnCorrectValues() {
    let disabledPayByLink = makePayByLink(status: .disabled)
    let disabledApplePay = ApplePay(payByLink: disabledPayByLink)
    let disabledSut = PaymentMethodItemApplePay(applePay: disabledApplePay)

    XCTAssertEqual(disabledSut.enabled, false)
    XCTAssertEqual(disabledSut.title, disabledApplePay.name)
    XCTAssertEqual(disabledSut.subtitle, "pay_by_phone".localized(languageCodeProvider: languageCodeProvider))
    XCTAssertEqual(disabledSut.brandImageProvider, disabledApplePay.brandImageProvider)
    XCTAssertEqual(disabledSut.paymentMethod?.value, disabledApplePay.value)
    XCTAssertTrue(disabledSut.paymentMethod is ApplePay)
    XCTAssertEqual(disabledSut.value, disabledApplePay.value)

    let enabledPayByLink = makePayByLink(status: .enabled)
    let enabledApplePay = ApplePay(payByLink: enabledPayByLink)
    let enabledSut = PaymentMethodItemApplePay(applePay: enabledApplePay)

    XCTAssertEqual(enabledSut.enabled, true)
    XCTAssertEqual(enabledSut.title, enabledApplePay.name)
    XCTAssertEqual(enabledSut.subtitle, "pay_by_phone".localized(languageCodeProvider: languageCodeProvider))
    XCTAssertEqual(enabledSut.brandImageProvider, enabledApplePay.brandImageProvider)
    XCTAssertTrue(enabledSut.paymentMethod is ApplePay)
    XCTAssertEqual(enabledSut.value, enabledApplePay.value)
  }

  func testPaymentMethodItemBankTransferShouldReturnCorrectValues() {
    let disabledSut = PaymentMethodItemBankTransfer(enabled: false)

    XCTAssertEqual(disabledSut.enabled, false)
    XCTAssertEqual(disabledSut.title, "bank_transfer".localized(languageCodeProvider: languageCodeProvider))
    XCTAssertEqual(disabledSut.subtitle, "fast_online_transfer".localized(languageCodeProvider: languageCodeProvider))
    XCTAssertEqual(disabledSut.brandImageProvider, BrandImageProvider.paperplane)
    XCTAssertEqual(disabledSut.paymentMethod?.value, nil)
    XCTAssertEqual(disabledSut.value, nil)

    let enabledSut = PaymentMethodItemBankTransfer(enabled: true)

    XCTAssertEqual(enabledSut.enabled, true)
    XCTAssertEqual(enabledSut.title, "bank_transfer".localized(languageCodeProvider: languageCodeProvider))
    XCTAssertEqual(enabledSut.subtitle, "fast_online_transfer".localized(languageCodeProvider: languageCodeProvider))
    XCTAssertEqual(enabledSut.brandImageProvider, BrandImageProvider.paperplane)
    XCTAssertEqual(enabledSut.value, nil)
  }

  func testPaymentMethodItemBlikCodeShouldReturnCorrectValues() {
    let blikCode = BlikCode()
    let sut = PaymentMethodItemBlikCode(blikCode: blikCode)

    XCTAssertEqual(sut.enabled, true)
    XCTAssertEqual(sut.title, "BLIK")
    XCTAssertEqual(sut.subtitle, "use_code_from_your_bank_app".localized(languageCodeProvider: languageCodeProvider))
    XCTAssertEqual(sut.brandImageProvider, BrandImageProvider.blik)
    XCTAssertTrue(sut.paymentMethod is BlikCode)
    XCTAssertEqual(sut.value, PaymentMethodValue.blikCode)
  }

  func testPaymentMethodItemBlikTokenShouldReturnCorrectValues() {
    let blikToken = BlikToken(brandImageUrl: makeBrandImageUrl(), type: "UID", value: "TOKB_nuGYkknycEp3NDWAN2hh1c7FLnXseaLX")
    let sut = PaymentMethodItemBlikToken(blikToken: blikToken)

    XCTAssertEqual(sut.enabled, true)
    XCTAssertEqual(sut.title, blikToken.name)
    XCTAssertEqual(sut.subtitle, "one_tap_payment".localized(languageCodeProvider: languageCodeProvider))
    XCTAssertEqual(sut.brandImageProvider, blikToken.brandImageProvider)
    XCTAssertTrue(sut.paymentMethod is BlikToken)
    XCTAssertEqual(sut.value, blikToken.value)
  }

  func testPaymentMethodItemCardShouldReturnCorrectValues() {
    let activeCardToken = makeCardToken(status: .active)
    let activeSut = PaymentMethodItemCardToken(cardToken: activeCardToken)

    XCTAssertEqual(activeSut.enabled, true)
    XCTAssertEqual(activeSut.title, activeCardToken.cardNumberMasked)
    XCTAssertEqual(activeSut.subtitle, "\(activeCardToken.cardExpirationMonth)/\(activeCardToken.cardExpirationYear)")
    XCTAssertEqual(activeSut.brandImageProvider, activeCardToken.brandImageProvider)
    XCTAssertTrue(activeSut.paymentMethod is CardToken)
    XCTAssertEqual(activeSut.value, activeCardToken.value)

    let expiredCardToken = makeCardToken(status: .expired)
    let expiredSut = PaymentMethodItemCardToken(cardToken: expiredCardToken)

    XCTAssertEqual(expiredSut.enabled, false)
    XCTAssertEqual(expiredSut.title, expiredCardToken.cardNumberMasked)
    XCTAssertEqual(expiredSut.subtitle, "\(expiredCardToken.cardExpirationMonth)/\(expiredCardToken.cardExpirationYear)")
    XCTAssertEqual(expiredSut.brandImageProvider, expiredCardToken.brandImageProvider)
    XCTAssertTrue(expiredSut.paymentMethod is CardToken)
    XCTAssertEqual(expiredSut.value, expiredCardToken.value)
  }

  func testPaymentMethodItemInstallmentsShouldReturnCorrectValues() {
    let enabledPayByLink = makePayByLink(status: .enabled)
    let enabledInstallments = Installments(payByLink: enabledPayByLink)
    let enabledSut = PaymentMethodItemInstallments(installments: enabledInstallments)

    XCTAssertEqual(enabledSut.enabled, true)
    XCTAssertEqual(enabledSut.title, enabledInstallments.name)
    XCTAssertEqual(enabledSut.subtitle, "decision_in_even_15_minutes".localized(languageCodeProvider: languageCodeProvider))
    XCTAssertEqual(enabledSut.brandImageProvider, enabledInstallments.brandImageProvider)
    XCTAssertTrue(enabledSut.paymentMethod is Installments)
    XCTAssertEqual(enabledSut.value, enabledInstallments.value)

    let disabledPayByLink = makePayByLink(status: .disabled)
    let disabledInstallments = Installments(payByLink: disabledPayByLink)
    let disabledSut = PaymentMethodItemInstallments(installments: disabledInstallments)

    XCTAssertEqual(disabledSut.enabled, false)
    XCTAssertEqual(disabledSut.title, disabledInstallments.name)
    XCTAssertEqual(disabledSut.subtitle, "decision_in_even_15_minutes".localized(languageCodeProvider: languageCodeProvider))
    XCTAssertEqual(disabledSut.brandImageProvider, disabledInstallments.brandImageProvider)
    XCTAssertTrue(disabledSut.paymentMethod is Installments)
    XCTAssertEqual(disabledSut.value, disabledInstallments.value)
  }

  func testPaymentMethodItemPayByLinkShouldReturnCorrectValues() {
    let enabledPayByLink = makePayByLink(status: .enabled)
    let enabledSut = PaymentMethodItemPayByLink(payByLink: enabledPayByLink)

    XCTAssertEqual(enabledSut.enabled, true)
    XCTAssertEqual(enabledSut.title, enabledPayByLink.name)
    XCTAssertEqual(enabledSut.subtitle, nil)
    XCTAssertEqual(enabledSut.brandImageProvider, enabledPayByLink.brandImageProvider)
    XCTAssertTrue(enabledSut.paymentMethod is PayByLink)
    XCTAssertEqual(enabledSut.value, enabledPayByLink.value)

    let disabledPayByLink = makePayByLink(status: .disabled)
    let disabledSut = PaymentMethodItemPayByLink(payByLink: disabledPayByLink)

    XCTAssertEqual(disabledSut.enabled, false)
    XCTAssertEqual(disabledSut.title, disabledPayByLink.name)
    XCTAssertEqual(disabledSut.subtitle, nil)
    XCTAssertEqual(disabledSut.brandImageProvider, disabledPayByLink.brandImageProvider)
    XCTAssertTrue(disabledSut.paymentMethod is PayByLink)
    XCTAssertEqual(disabledSut.value, disabledPayByLink.value)
  }

}

private extension PaymentMethodsItemTests {
  func makeBrandImageUrl() -> String {
    "https://www.payu.com/image_\(UUID().uuidString).jpg"
  }

  func makeCardToken(status: CardToken.Status) -> CardToken {
    CardToken(
      brandImageUrl: makeBrandImageUrl(),
      cardExpirationMonth: Int.random(in: 1...12),
      cardExpirationYear: Int.random(in: 2023...2033),
      cardNumberMasked: UUID().uuidString,
      cardScheme: UUID().uuidString,
      preferred: false,
      status: status,
      value: UUID().uuidString
    )
  }

  func makePayByLink(status: PayByLink.Status) -> PayByLink {
    PayByLink(
      brandImageUrl: makeBrandImageUrl(),
      name: UUID().uuidString,
      status: status,
      value: UUID().uuidString
    )
  }
}
