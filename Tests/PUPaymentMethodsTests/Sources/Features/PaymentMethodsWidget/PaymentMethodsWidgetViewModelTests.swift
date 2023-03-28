//
//  PaymentMethodsWidgetViewModelTests.swift
//  
//  Created by PayU S.A. on 21/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
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
    delegate = mock(PaymentMethodsWidgetViewModelDelegate.self)
    storage = mock(PaymentMethodsStorageProtocol.self)
    textFormatter = mock(TextFormatterProtocol.self)

    sut = PaymentMethodsWidgetViewModel(
      configuration: configuration,
      storage: storage,
      textFormatter: textFormatter)

    sut.delegate = delegate
  }

  override func tearDown() {
    super.tearDown()
    reset(delegate)
    reset(storage)
    reset(textFormatter)

    configuration = nil
    sut = nil
  }

  func testWhenDidTapWidgetThenShouldPresentPaymentMethods() {
    sut.didTapWidget()
    verify(
      delegate.viewModel(
        any(),
        shouldPresentPaymentMethods: configuration,
        storage: any()))
    .wasCalled()
  }

  func testWhenDidTapEnterNewBlikCodeWhenPaymentMethodIsNotSelectedThenShouldDoNothing() {
    sut.didTapEnterNewBlikCode()
    verify(
      delegate.viewModel(
        any(),
        didUpdateState: any()))
    .wasNeverCalled()
  }

  func testWhenDidTapEnterNewBlikCodeWhenPaymentMethodIsSelectedThenShouldUpdateStateToBlikToken() {
    let paymentMethod = makeBlikCode()
    sut.didSelect(paymentMethod)
    sut.didTapEnterNewBlikCode()
    verify(
      delegate.viewModel(
        any(),
        didUpdateState: .blikToken(paymentMethod)))
    .wasCalled()
  }

  func testWhenDidEnterNewBlikCodeWhenBlikAuthorizationCodeIsBlikCodeThenShouldSaveIt() {
    let blikAuthorizationText = "929600"
    let blikAuthorizationCode = "574987"

    given(textFormatter.formatted(any())).willReturn(blikAuthorizationCode)
    sut.didEnterNewBlikCode(blikAuthorizationText)
    XCTAssertEqual(sut.blikAuthorizationCode, blikAuthorizationCode)
    verify(textFormatter.formatted(blikAuthorizationText)).wasCalled()
  }

  func testWhenDidEnterNewBlikCodeWhenBlikAuthorizationCodeIsNotBlikCodeThenNotShouldSaveIt() {
    let blikAuthorizationText = "929600"
    let blikAuthorizationCode = "57498"

    given(textFormatter.formatted(any())).willReturn(blikAuthorizationCode)
    sut.didEnterNewBlikCode(blikAuthorizationText)
    XCTAssertEqual(sut.blikAuthorizationCode, nil)
    verify(textFormatter.formatted(blikAuthorizationText)).wasCalled()
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
    verify(delegate.viewModel(any(), didUpdateState: state)).wasCalled()
  }

  func testWhenDidSelectBlikTokenPaymentMethodThenShouldUpdateStateToBlikToken() {
    let paymentMethod = makeBlikToken()
    sut.didSelect(paymentMethod)

    let state = PaymentMethodsWidgetState.blikToken(paymentMethod)
    XCTAssertEqual(sut.state, state)
    verify(delegate.viewModel(any(), didUpdateState: state)).wasCalled()
  }

  func testWhenDidSelectOtherPaymentMethodThenShouldUpdateStateToPaymentMethod() {
    let paymentMethod = makePayByLink()
    sut.didSelect(paymentMethod)

    let state = PaymentMethodsWidgetState.paymentMethod(paymentMethod)
    XCTAssertEqual(sut.state, state)
    verify(delegate.viewModel(any(), didUpdateState: state)).wasCalled()
  }

  func testWhenDidSelectNilPaymentMethodThenShouldUpdateStateToInitial() {
    sut.didSelect(nil)

    let state = PaymentMethodsWidgetState.initial
    XCTAssertEqual(sut.state, state)
    verify(delegate.viewModel(any(), didUpdateState: state)).wasCalled()
  }

  func testWhenDidDeletePaymentMethodWhenPaymentMethodIsSelectedThenShouldResetStateToInitial() {
    let paymentMethod = makePayByLink()
    sut.didSelect(paymentMethod)
    sut.didDelete(paymentMethod)

    let state = PaymentMethodsWidgetState.initial
    XCTAssertEqual(sut.state, state)
    verify(delegate.viewModel(any(), didUpdateState: state)).wasCalled()
  }

  func testWhenDidDeletePaymentMethodWhenPaymentMethodIsNotSelectedThenShouldNotResetStateToInitial() {
    sut.didDelete(makePayByLink())
    verify(delegate.viewModel(any(), didUpdateState: any())).wasNeverCalled()
  }

  func testWhenFormattedBlikCodeThenShouldReturnValueFromTextFormatter() {
    given(textFormatter.formatted(any())).willReturn("1234")
    XCTAssertEqual(sut.formattedBlikAuthorizationCode("AAAA"), "1234")
    verify(textFormatter.formatted("AAAA")).wasCalled()

    given(textFormatter.formatted(any())).willReturn("9963")
    XCTAssertEqual(sut.formattedBlikAuthorizationCode("BBBB"), "9963")
    verify(textFormatter.formatted("BBBB")).wasCalled()
  }

  func testWhenPaymentMethodIsCalledWhenSelectedPaymentMethodIsBlikCodeThenShouldReturnItWithBlikAuthorizationCode() {
    let blikCodeOne = makeBlikCode()
    sut.didSelect(blikCodeOne)
    XCTAssertEqual(sut.paymentMethod?.value, blikCodeOne.value)
    XCTAssertEqual((sut.paymentMethod as? BlikCode)?.authorizationCode, nil)

    let blikAuthorizationText = "9 3 6 3 9 9"
    let blikAuthorizationCode = "936399"
    given(textFormatter.formatted(any())).willReturn(blikAuthorizationCode)

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

    let installments = Installments(payByLink: makePayByLink(value: PaymentMethodValue.mastercardInstallments))
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
