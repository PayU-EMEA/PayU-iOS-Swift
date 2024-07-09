//
//  PaymentMethodsWidgetStateDecoratorTests.swift
//  
//  Created by PayU S.A. on 21/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUCore
@testable import PUPaymentMethods
@testable import PUTranslations

final class PaymentMethodsWidgetStateDecoratorTests: XCTestCase {

  private var languageCodeProvider: LanguageCodeProviderMock!
  private var sut: PaymentMethodsWidgetStateDecoratorFactory!

  override func setUp() {
    super.setUp()
    languageCodeProvider = mock(LanguageCodeProvider.self)
    sut = PaymentMethodsWidgetStateDecoratorFactory()

    given(languageCodeProvider.languageCode()).willReturn("en")
  }

  override func tearDown() {
    super.tearDown()
    reset(languageCodeProvider)
    sut = nil
  }

  func testDecoratorForInitialStateShouldReturnCorrectValues() {
    let decorator = sut.decorator(.initial)

    XCTAssertEqual(decorator.title, "Select payment method")
    XCTAssertEqual(decorator.subtitle, nil)
    XCTAssertEqual(decorator.logo, nil)

    XCTAssertEqual(decorator.isPaymentMethodLogoVisible, false)
    XCTAssertEqual(decorator.isPaymentMethodTitleVisible, true)
    XCTAssertEqual(decorator.isPaymentMethodSubtitleVisible, false)

    XCTAssertEqual(decorator.isBlikTokenButtonVisible, false)
    XCTAssertEqual(decorator.isBlikCodeTextInputViewVisible, false)
  }

  func testDecoratorForBlikCodeStateShouldReturnCorrectValues() {
    let blikCode = BlikCode()
    let decorator = sut.decorator(.blikCode(blikCode))

    XCTAssertEqual(decorator.title, blikCode.name)
    XCTAssertEqual(decorator.subtitle, blikCode.description)
    XCTAssertEqual(decorator.logo?.url, blikCode.brandImageProvider.url)

    XCTAssertEqual(decorator.isPaymentMethodLogoVisible, decorator.logo != nil)
    XCTAssertEqual(decorator.isPaymentMethodTitleVisible, decorator.title != nil)
    XCTAssertEqual(decorator.isPaymentMethodSubtitleVisible, decorator.subtitle != nil)

    XCTAssertEqual(decorator.isBlikTokenButtonVisible, false)
    XCTAssertEqual(decorator.isBlikCodeTextInputViewVisible, true)
  }

  func testDecoratorForBlikTokenStateShouldReturnCorrectValues() {
    let blikCode = BlikCode()
    let decorator = sut.decorator(.blikToken(blikCode))

    XCTAssertEqual(decorator.title, blikCode.name)
    XCTAssertEqual(decorator.subtitle, blikCode.description)
    XCTAssertEqual(decorator.logo?.url, blikCode.brandImageProvider.url)

    XCTAssertEqual(decorator.isPaymentMethodLogoVisible, decorator.logo != nil)
    XCTAssertEqual(decorator.isPaymentMethodTitleVisible, decorator.title != nil)
    XCTAssertEqual(decorator.isPaymentMethodSubtitleVisible, decorator.subtitle != nil)

    XCTAssertEqual(decorator.isBlikTokenButtonVisible, true)
    XCTAssertEqual(decorator.isBlikCodeTextInputViewVisible, false)
  }

  func testDecoratorForPaymentMethodStateShouldReturnCorrectValues() {
    let paymentMethod = makePaymentMethod()
    let decorator = sut.decorator(.paymentMethod(paymentMethod))

    XCTAssertEqual(decorator.title, paymentMethod.name)
    XCTAssertEqual(decorator.subtitle, paymentMethod.description)
    XCTAssertEqual(decorator.logo?.url, paymentMethod.brandImageProvider.url)

    XCTAssertEqual(decorator.isPaymentMethodLogoVisible, decorator.logo != nil)
    XCTAssertEqual(decorator.isPaymentMethodTitleVisible, decorator.title != nil)
    XCTAssertEqual(decorator.isPaymentMethodSubtitleVisible, decorator.subtitle != nil)

    XCTAssertEqual(decorator.isBlikTokenButtonVisible, false)
    XCTAssertEqual(decorator.isBlikCodeTextInputViewVisible, false)
  }
}

private extension PaymentMethodsWidgetStateDecoratorTests {
  func makePaymentMethod() -> PaymentMethod {
    CardToken(
      brandImageUrl: "https://www.payu.com/image_\(UUID().uuidString).jpg",
      cardExpirationMonth: Int.random(in: 1...12),
      cardExpirationYear: Int.random(in: 2023...2033),
      cardNumberMasked: UUID().uuidString,
      cardScheme: UUID().uuidString,
      preferred: false,
      status: .active,
      value: UUID().uuidString
    )
  }
}
