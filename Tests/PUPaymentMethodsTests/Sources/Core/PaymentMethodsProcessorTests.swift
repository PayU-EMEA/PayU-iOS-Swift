//
//  PaymentMethodsProcessorTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
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
    applePayPaymentRequestProvider = PaymentMethodsProcessorApplePayPaymentRequestProviderMock()
    blikAuthorizationCodePresenter = PaymentMethodsProcessorBlikAuthorizationCodePresenterMock()

    applePayService = ApplePayServiceProtocolMock()
    blikAlertViewControllerPresenter = BlikAlertViewControllerPresenterProtocolMock()

    sut = PaymentMethodsProcessor(
      applePayService: applePayService,
      blikAlertViewControllerPresenter: blikAlertViewControllerPresenter)

    sut.applePayPaymentRequestProvider = applePayPaymentRequestProvider
    sut.blikAuthorizationCodePresenter = blikAuthorizationCodePresenter
  }

  override func tearDown() {
    super.tearDown()
    applePayPaymentRequestProvider = nil
    blikAuthorizationCodePresenter = nil

    applePayService = nil
    blikAlertViewControllerPresenter = nil

    sut = nil
  }

  func testProcessPaymentMethodWhenApplePayThenShouldCallApplePayServiceToAuthorize() {
    let paymentMethod = makeApplePay()

    let stubbedPaymentRequest = makePaymentRequest()
    applePayPaymentRequestProvider.paymentRequestHandler = { stubbedPaymentRequest }

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in },
      onDidFail: { error in })

    XCTAssertGreaterThan(applePayService.makePaymentCallCount, 0)
  }

  func testProcessPaymentMethodWhenApplePayWhenApplePayServiceDidAuthorizeThenShouldComplete() {
    let paymentMethod = makeApplePay()
    let paymentDataToken = UUID().uuidString
    let expectation = XCTestExpectation()

    let expectedPayMethod = PayMethod(
      type: .pbl,
      value: PaymentMethodValue.applePay,
      authorizationCode: paymentDataToken)

    let stubbedPaymentRequest = makePaymentRequest()
    applePayPaymentRequestProvider.paymentRequestHandler = { stubbedPaymentRequest }

    applePayService.makePaymentHandler = { paymentRequest, onDidAuthorize, onDidCancel, onDidFail in
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

    let stubbedPaymentRequest = makePaymentRequest()
    applePayPaymentRequestProvider.paymentRequestHandler = { stubbedPaymentRequest }

    applePayService.makePaymentHandler = { paymentRequest, onDidAuthorize, onDidCancel, onDidFail in
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

    let stubbedPaymentRequest = makePaymentRequest()
    applePayPaymentRequestProvider.paymentRequestHandler = { stubbedPaymentRequest }

    applePayService.makePaymentHandler = { paymentRequest, onDidAuthorize, onDidCancel, onDidFail in
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

    blikAuthorizationCodePresenter.presentingViewControllerHandler = { viewController }

    sut.process(
      paymentMethod: paymentMethod,
      onDidProcess: { payMethod in },
      onDidFail: { error in })

    XCTAssertGreaterThan(blikAlertViewControllerPresenter.presentBlikAlertViewControllerCallCount, 0)
    XCTAssertTrue(
      (blikAlertViewControllerPresenter.presentBlikAlertViewControllerArgValues.last ?? nil) === viewController)
  }

  func testProcessPaymentMethodWhenBlikCodeWhenAuthorizationCodeIsNilWhenDidConfirmThenShouldComplete() {
    let paymentMethod = makeBlikCode(authorizationCode: nil)
    let authorizationCode = UUID().uuidString
    let viewController = UIViewController()
    let expectation = XCTestExpectation()

    let expectedPayMethod = PayMethod(
      type: .blikToken,
      authorizationCode: authorizationCode)

    blikAuthorizationCodePresenter.presentingViewControllerHandler = { viewController }

    blikAlertViewControllerPresenter.presentBlikAlertViewControllerHandler = { from, onDidConfirm, onDidCancel in
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

    blikAuthorizationCodePresenter.presentingViewControllerHandler = { viewController }

    blikAlertViewControllerPresenter.presentBlikAlertViewControllerHandler = { from, onDidConfirm, onDidCancel in
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

    blikAuthorizationCodePresenter.presentingViewControllerHandler = { viewController }

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
