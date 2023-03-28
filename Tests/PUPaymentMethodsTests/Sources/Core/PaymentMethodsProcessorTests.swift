//
//  PaymentMethodsProcessorTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUApplePay
@testable import PUCore
@testable import PUPaymentMethods

final class PaymentMethodsProcessorTests: XCTestCase {

  private var applePayPaymentRequestProvider: PaymentMethodsProcessorApplePayPaymentRequestProviderMock!
  private var blikAuthorizationCodePresenter: PaymentMethodsProcessorBlikAuthorizationCodePresenterMock!

  private var applePayService: ApplePayServiceProtocolMock!
  private var blikAlertViewControllerPresenter: BlikAlertViewControllerPresenterProtocolMock!

  private var sut: PaymentMethodsProcessor!

  override func setUp() {
    super.setUp()
    applePayPaymentRequestProvider = mock(PaymentMethodsProcessorApplePayPaymentRequestProvider.self)
    blikAuthorizationCodePresenter = mock(PaymentMethodsProcessorBlikAuthorizationCodePresenter.self)

    applePayService = mock(ApplePayServiceProtocol.self)
    blikAlertViewControllerPresenter = mock(BlikAlertViewControllerPresenterProtocol.self)

    sut = PaymentMethodsProcessor(
      applePayService: applePayService,
      blikAlertViewControllerPresenter: blikAlertViewControllerPresenter)

    sut.applePayPaymentRequestProvider = applePayPaymentRequestProvider
    sut.blikAuthorizationCodePresenter = blikAuthorizationCodePresenter
  }

  override func tearDown() {
    super.tearDown()
    reset(applePayPaymentRequestProvider)
    reset(blikAuthorizationCodePresenter)

    reset(applePayService)
    reset(blikAlertViewControllerPresenter)

    sut = nil
  }

  func testProcessPaymentMethodWhenApplePayThenShouldCallApplePayServiceToAuthorize() {
    let paymentMethod = makeApplePay()

    given(
      applePayPaymentRequestProvider.paymentRequest())
    .willReturn(makePaymentRequest())

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in },
      onDidFail: { error in })

    verify(
      applePayService.makePayment(
        paymentRequest: any(),
        onDidAuthorize: any(),
        onDidCancel: any(),
        onDidFail: any()))
    .wasCalled()
  }

  func testProcessPaymentMethodWhenApplePayWhenApplePayServiceDidAuthorizeThenShouldComplete() {
    let paymentMethod = makeApplePay()
    let paymentDataToken = UUID().uuidString
    let expectation = XCTestExpectation()

    let expectedPayMethod = PayMethod(
      type: .pbl,
      value: PaymentMethodValue.applePay,
      authorizationCode: paymentDataToken)

    given(
      applePayPaymentRequestProvider.paymentRequest())
    .willReturn(makePaymentRequest())

    given(
      applePayService
        .makePayment(
          paymentRequest: any(),
          onDidAuthorize: any(),
          onDidCancel: any(),
          onDidFail: any()))
    .will { paymentRequest, onDidAuthorize, onDidCancel, onDidFail in
      onDidAuthorize(paymentDataToken)
    }

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in if expectedPayMethod == payMethod { expectation.fulfill() } },
      onDidFail: { error in })

    wait(for: [expectation], timeout: 1)
  }

  func testProcessPaymentMethodWhenApplePayWhenApplePayServiceDidCancelThenShouldNotComplete() {
    let paymentMethod = makeApplePay()
    let expectation = XCTestExpectation()
    expectation.isInverted = true

    given(
      applePayPaymentRequestProvider.paymentRequest())
    .willReturn(makePaymentRequest())

    given(
      applePayService
        .makePayment(
          paymentRequest: any(),
          onDidAuthorize: any(),
          onDidCancel: any(),
          onDidFail: any()))
    .will { paymentRequest, onDidAuthorize, onDidCancel, onDidFail in
      onDidCancel()
    }

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in expectation.fulfill() },
      onDidFail: { error in expectation.fulfill() })

    wait(for: [expectation], timeout: 1)
  }

  func testProcessPaymentMethodWhenApplePayWhenApplePayServiceDidFaileThenShouldFail() {
    struct ErrorMock: Error {  }

    let paymentMethod = makeApplePay()
    let expectation = XCTestExpectation()

    given(
      applePayPaymentRequestProvider.paymentRequest())
    .willReturn(makePaymentRequest())

    given(
      applePayService
        .makePayment(
          paymentRequest: any(),
          onDidAuthorize: any(),
          onDidCancel: any(),
          onDidFail: any()))
    .will { paymentRequest, onDidAuthorize, onDidCancel, onDidFail in
      onDidFail(ErrorMock())
    }

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in },
      onDidFail: { error in expectation.fulfill() })

    wait(for: [expectation], timeout: 1)
  }

  func testProcessPaymentMethodWhenBlikCodeWhenAuthorizationCodeIsNilThenShouldCallBlikAlertViewControllerPresenter() {
    let paymentMethod = makeBlikCode(authorizationCode: nil)
    let viewController = UIViewController()

    given(
      blikAuthorizationCodePresenter.presentingViewController())
    .willReturn(viewController)

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in },
      onDidFail: { error in })

    verify(
      blikAlertViewControllerPresenter
        .presentBlikAlertViewController(
          from: viewController,
          onDidConfirm: any(),
          onDidCancel: any()))
    .wasCalled()
  }

  func testProcessPaymentMethodWhenBlikCodeWhenAuthorizationCodeIsNilWhenDidConfirmThenShouldComplete() {
    let paymentMethod = makeBlikCode(authorizationCode: nil)
    let authorizationCode = UUID().uuidString
    let viewController = UIViewController()
    let expectation = XCTestExpectation()

    let expectedPayMethod = PayMethod(
      type: .blikToken,
      authorizationCode: authorizationCode)

    given(
      blikAuthorizationCodePresenter.presentingViewController())
    .willReturn(viewController)

    given(
      blikAlertViewControllerPresenter
        .presentBlikAlertViewController(
          from: any(),
          onDidConfirm: any(),
          onDidCancel: any()))
    .will { from, onDidConfirm, onDidCancel in
      onDidConfirm(authorizationCode)
    }

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in if expectedPayMethod == payMethod { expectation.fulfill() } },
      onDidFail: { error in  })

    wait(for: [expectation], timeout: 1)
  }

  func testProcessPaymentMethodWhenBlikCodeWhenAuthorizationCodeIsNilWhenDidCancelThenShouldNotComplete() {
    let paymentMethod = makeBlikCode(authorizationCode: nil)
    let viewController = UIViewController()
    let expectation = XCTestExpectation()
    expectation.isInverted = true

    given(
      blikAuthorizationCodePresenter.presentingViewController())
    .willReturn(viewController)

    given(
      blikAlertViewControllerPresenter
        .presentBlikAlertViewController(
          from: any(),
          onDidConfirm: any(),
          onDidCancel: any()))
    .will { from, onDidConfirm, onDidCancel in
      onDidCancel()
    }

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in expectation.fulfill() },
      onDidFail: { error in expectation.fulfill() })

    wait(for: [expectation], timeout: 1)
  }

  func testProcessPaymentMethodWhenBlikCodeWhenAuthorizationCodeExistsThenShouldComplete() {
    let authorizationCode = UUID().uuidString
    let paymentMethod = makeBlikCode(authorizationCode: authorizationCode)
    let viewController = UIViewController()
    let expectation = XCTestExpectation()

    let expectedPayMethod = PayMethod(
      type: .blikToken,
      authorizationCode: authorizationCode)

    given(
      blikAuthorizationCodePresenter.presentingViewController())
    .willReturn(viewController)

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in if expectedPayMethod == payMethod { expectation.fulfill() } },
      onDidFail: { error in })

    wait(for: [expectation], timeout: 1)
  }

  func testProcessPaymentMethodWhenBlikTokenThenShouldComplete() {
    let paymentMethod = makeBlikToken()
    let expectation = XCTestExpectation()

    let expectedPayMethod = PayMethod(
      type: .blikToken,
      value: paymentMethod.value)

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in if expectedPayMethod == payMethod { expectation.fulfill() } },
      onDidFail: { error in })

    wait(for: [expectation], timeout: 1)
  }

  func testProcessPaymentMethodWhenCardTokenThenShouldComplete() {
    let paymentMethod = makeCardToken()
    let expectation = XCTestExpectation()

    let expectedPayMethod = PayMethod(
      type: .cardToken,
      value: paymentMethod.value)

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in if expectedPayMethod == payMethod { expectation.fulfill() } },
      onDidFail: { error in })

    wait(for: [expectation], timeout: 1)
  }

  func testProcessPaymentMethodWhenInstallmentsThenShouldComplete() {
    let paymentMethod = makeInstallments()
    let expectation = XCTestExpectation()

    let expectedPayMethod = PayMethod(
      type: .pbl,
      value: paymentMethod.value)

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in if expectedPayMethod == payMethod { expectation.fulfill() } },
      onDidFail: { error in })

    wait(for: [expectation], timeout: 1)
  }

  func testProcessPaymentMethodWhenPayByLinkThenShouldComplete() {
    let paymentMethod = makePayByLink()
    let expectation = XCTestExpectation()

    let expectedPayMethod = PayMethod(
      type: .pbl,
      value: paymentMethod.value)

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in if expectedPayMethod == payMethod { expectation.fulfill() } },
      onDidFail: { error in })

    wait(for: [expectation], timeout: 1)
  }

  func testProcessPaymentMethodWhenOtherThenShouldNotComplete() {
    struct UnknownPaymentMethod: PaymentMethod {
      public var brandImageProvider: BrandImageProvider { .blik }
      public let description: String? = nil
      public let enabled: Bool = true
      public let name: String = "UnknownPaymentMethod"
      public let value: String = "UnknownPaymentMethod"
    }

    let paymentMethod = UnknownPaymentMethod()
    let expectation = XCTestExpectation()
    expectation.isInverted = true

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in expectation.fulfill() },
      onDidFail: { error in expectation.fulfill() })

    wait(for: [expectation], timeout: 1)
  }

}

private extension PaymentMethodsProcessorTests {
  func makeBrandImageUrl() -> String {
    "https://www.payu.com/image_\(UUID().uuidString).jpg"
  }

  func makeApplePay() -> ApplePay {
    ApplePay(payByLink: makePayByLink())
  }

  func makeBlikCode(authorizationCode: String?) -> BlikCode {
    BlikCode(authorizationCode: authorizationCode)
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

  func makePaymentRequest() -> PaymentRequest {
    PaymentRequest(
      countryCode: "PL",
      currencyCode: "PLN",
      merchantIdentifier: "merchantIdentifier",
      paymentSummaryItems: [
        PaymentRequest.SummaryItem(label: "Futomaki", amount: 1599),
        PaymentRequest.SummaryItem(label: "Napkin", amount: 49),
        PaymentRequest.SummaryItem(label: "Order", amount: 1599 + 49)
      ],
      shippingContact: PaymentRequest.Contact(
        emailAddress: "email@address.com")
    )
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
