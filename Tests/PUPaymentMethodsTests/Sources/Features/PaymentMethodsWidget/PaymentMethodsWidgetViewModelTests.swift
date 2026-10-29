//
//  PaymentMethodsWidgetViewModelTests.swift
//  
//  Created by PayU S.A. on 21/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore
@testable import PUPaymentMethods

final class PaymentMethodsWidgetViewModelTests: XCTestCase {

  private var configuration: PaymentMethodsConfiguration!
  private var delegate: PaymentMethodsWidgetViewModelDelegateMock!
  private var storage: PaymentMethodsStorageProtocolMock!
  private var textFormatter: TextFormatterProtocolMock!
  private var sut: PaymentMethodsWidgetViewModel!

  override func setUp() {
    super.setUp()
    configuration = PaymentMethodsConfiguration()
    delegate = PaymentMethodsWidgetViewModelDelegateMock()
    storage = PaymentMethodsStorageProtocolMock()
    textFormatter = TextFormatterProtocolMock()

    sut = PaymentMethodsWidgetViewModel(
      configuration: configuration,
      storage: storage,
      textFormatter: textFormatter)

    sut.delegate = delegate
  }

  override func tearDown() {
    super.tearDown()
    delegate = nil
    storage = nil
    textFormatter = nil

    configuration = nil
    sut = nil
  }

  func testWhenDidTapWidgetThenShouldPresentPaymentMethods() {
    sut.didTapWidget()
    XCTAssertGreaterThan(delegate.viewModelShouldPresentPaymentMethodsCallCount, 0)
    XCTAssertEqual(delegate.viewModelShouldPresentPaymentMethodsArgValues.last?.configuration, configuration)
  }

  func testWhenDidTapEnterNewBlikCodeWhenPaymentMethodIsNotSelectedThenShouldDoNothing() {
    sut.didTapEnterNewBlikCode()
    XCTAssertEqual(delegate.viewModelCallCount, 0)
  }

  func testWhenDidTapEnterNewBlikCodeWhenPaymentMethodIsSelectedThenShouldUpdateStateToBlikToken() {
    let paymentMethod = makeBlikToken()
    sut.didSelect(paymentMethod)
    sut.didTapEnterNewBlikCode()
    XCTAssertGreaterThan(delegate.viewModelCallCount, 0)
    XCTAssertTrue(delegate.viewModelArgValues.contains { $0.state == .blikCode(paymentMethod) })
  }

  func testWhenDidEnterNewBlikCodeWhenBlikAuthorizationCodeIsBlikCodeThenShouldSaveIt() {
    let blikAuthorizationText = "929600"
    let blikAuthorizationCode = "574987"

    textFormatter.formattedHandler = { _ in blikAuthorizationCode }
    sut.didEnterNewBlikCode(blikAuthorizationText)
    XCTAssertEqual(sut.blikAuthorizationCode, blikAuthorizationCode)
    XCTAssertGreaterThan(textFormatter.formattedCallCount, 0)
    XCTAssertEqual(textFormatter.formattedArgValues.last, blikAuthorizationText)
  }

  func testWhenDidEnterNewBlikCodeWhenBlikAuthorizationCodeIsNotBlikCodeThenNotShouldSaveIt() {
    let blikAuthorizationText = "929600"
    let blikAuthorizationCode = "57498"

    textFormatter.formattedHandler = { _ in blikAuthorizationCode }
    sut.didEnterNewBlikCode(blikAuthorizationText)
    XCTAssertEqual(sut.blikAuthorizationCode, nil)
    XCTAssertGreaterThan(textFormatter.formattedCallCount, 0)
    XCTAssertEqual(textFormatter.formattedArgValues.last, blikAuthorizationText)
  }

  func testWhenDidSelectPaymentMethodThenShouldUpdateSelectedPaymentMethod() {
    let paymentMethodOne = makePayByLink()
    sut.didSelect(paymentMethodOne)
    XCTAssertEqual(sut.selectedPaymentMethod?.value, paymentMethodOne.value)

    let paymentMethodTwo = makeBlikToken()
    sut.didSelect(paymentMethodTwo)
    XCTAssertEqual(sut.selectedPaymentMethod?.value, paymentMethodTwo.value)
  }

  func testWhenDidSelectBlikCodePaymentMethodThenShouldUpdateStateToBlikCode() {
    let paymentMethod = makeBlikCode()
    sut.didSelect(paymentMethod)

    let state = PaymentMethodsWidgetState.blikCode(paymentMethod)
    XCTAssertEqual(sut.state, state)
    XCTAssertGreaterThan(delegate.viewModelCallCount, 0)
    XCTAssertTrue(delegate.viewModelArgValues.contains { $0.state == state })
  }

  func testWhenDidSelectBlikTokenPaymentMethodThenShouldUpdateStateToBlikToken() {
    let paymentMethod = makeBlikToken()
    sut.didSelect(paymentMethod)

    let state = PaymentMethodsWidgetState.blikToken(paymentMethod)
    XCTAssertEqual(sut.state, state)
    XCTAssertGreaterThan(delegate.viewModelCallCount, 0)
    XCTAssertTrue(delegate.viewModelArgValues.contains { $0.state == state })
  }

  func testWhenDidSelectOtherPaymentMethodThenShouldUpdateStateToPaymentMethod() {
    let paymentMethod = makePayByLink()
    sut.didSelect(paymentMethod)

    let state = PaymentMethodsWidgetState.paymentMethod(paymentMethod)
    XCTAssertEqual(sut.state, state)
    XCTAssertGreaterThan(delegate.viewModelCallCount, 0)
    XCTAssertTrue(delegate.viewModelArgValues.contains { $0.state == state })
  }

  func testWhenDidSelectNilPaymentMethodThenShouldUpdateStateToInitial() {
    sut.didSelect(nil)

    let state = PaymentMethodsWidgetState.initial
    XCTAssertEqual(sut.state, state)
    XCTAssertGreaterThan(delegate.viewModelCallCount, 0)
    XCTAssertTrue(delegate.viewModelArgValues.contains { $0.state == state })
  }

  func testWhenDidDeletePaymentMethodWhenPaymentMethodIsSelectedThenShouldResetStateToInitial() {
    let paymentMethod = makePayByLink()
    sut.didSelect(paymentMethod)
    sut.didDelete(paymentMethod)

    let state = PaymentMethodsWidgetState.initial
    XCTAssertEqual(sut.state, state)
    XCTAssertGreaterThan(delegate.viewModelCallCount, 0)
    XCTAssertTrue(delegate.viewModelArgValues.contains { $0.state == state })
  }

  func testWhenDidDeletePaymentMethodWhenPaymentMethodIsNotSelectedThenShouldNotResetStateToInitial() {
    sut.didDelete(makePayByLink())
    XCTAssertEqual(delegate.viewModelCallCount, 0)
  }

  func testWhenFormattedBlikCodeThenShouldReturnValueFromTextFormatter() {
    textFormatter.formattedHandler = { _ in "1234" }
    XCTAssertEqual(sut.formattedBlikAuthorizationCode("AAAA"), "1234")
    XCTAssertGreaterThan(textFormatter.formattedCallCount, 0)
    XCTAssertEqual(textFormatter.formattedArgValues.last, "AAAA")

    textFormatter.formattedHandler = { _ in "9963" }
    XCTAssertEqual(sut.formattedBlikAuthorizationCode("BBBB"), "9963")
    XCTAssertGreaterThan(textFormatter.formattedCallCount, 0)
    XCTAssertEqual(textFormatter.formattedArgValues.last, "BBBB")
  }

  func testWhenPaymentMethodIsCalledWhenSelectedPaymentMethodIsBlikCodeThenShouldReturnItWithBlikAuthorizationCode() {
    let blikCodeOne = makeBlikCode()
    sut.didSelect(blikCodeOne)
    XCTAssertEqual(sut.paymentMethod?.value, blikCodeOne.value)
    XCTAssertEqual((sut.paymentMethod as? BlikCode)?.authorizationCode, nil)

    let blikAuthorizationText = "9 3 6 3 9 9"
    let blikAuthorizationCode = "936399"
    textFormatter.formattedHandler = { _ in blikAuthorizationCode }

    let blikCodeTwo = makeBlikCode()
    sut.didSelect(blikCodeTwo)
    sut.didEnterNewBlikCode(blikAuthorizationText)
    XCTAssertEqual(sut.paymentMethod?.value, blikCodeTwo.value)
    XCTAssertEqual((sut.paymentMethod as? BlikCode)?.authorizationCode, blikAuthorizationCode)
  }

  func testWhenPaymentMethodIsCalledWhenSelectedPaymentMethodThenShouldReturnIt() {
    let applePay = ApplePay(payByLink: makePayByLink(value: PaymentMethodValue.applePay))
    sut.didSelect(applePay)
    XCTAssertEqual(sut.paymentMethod?.value, applePay.value)

    let blikToken = makeBlikToken()
    sut.didSelect(blikToken)
    XCTAssertEqual(sut.paymentMethod?.value, blikToken.value)

    let cardToken = makeCardToken()
    sut.didSelect(cardToken)
    XCTAssertEqual(sut.paymentMethod?.value, cardToken.value)

    let installments = Installments(payByLink: makePayByLink(value: PaymentMethodValue.installments))
    sut.didSelect(installments)
    XCTAssertEqual(sut.paymentMethod?.value, installments.value)

    let payByLink = makePayByLink()
    sut.didSelect(payByLink)
    XCTAssertEqual(sut.paymentMethod?.value, payByLink.value)
  }
}

private extension PaymentMethodsWidgetViewModelTests {
  func makeBrandImageUrl() -> String {
    "https://www.payu.com/image_\(UUID().uuidString).jpg"
  }

  func makeBlikCode() -> BlikCode {
    BlikCode()
  }

  func makeBlikToken() -> BlikToken {
    BlikToken(
      brandImageUrl: makeBrandImageUrl(),
      type: "UID",
      value: "TOK_\(UUID().uuidString)")
  }

  func makeCardToken() -> CardToken {
    CardToken(
      brandImageUrl: makeBrandImageUrl(),
      cardExpirationMonth: Int.random(in: 1...12),
      cardExpirationYear: Int.random(in: Date().year + 1...Date().year + 10),
      cardNumberMasked: UUID().uuidString,
      cardScheme: UUID().uuidString,
      preferred: false,
      status: .active,
      value: UUID().uuidString
    )
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
