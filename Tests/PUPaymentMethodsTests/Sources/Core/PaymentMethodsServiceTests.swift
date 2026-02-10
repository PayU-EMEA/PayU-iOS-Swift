//
//  PaymentMethodsServiceTests.swift
//
//  Copyright © PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUCore
@testable import PUPaymentMethods

final class PaymentMethodsServiceTests: XCTestCase {

  private var factory: PaymentMethodsItemFactoryProtocolMock!
  private var storage: PaymentMethodsStorageProtocolMock!
  private var sut: PaymentMethodsService!
  private var payU: PayU!

  override func setUp() {
    super.setUp()
    factory = mock(PaymentMethodsItemFactoryProtocol.self)
    storage = mock(PaymentMethodsStorageProtocol.self)
    sut = PaymentMethodsService(factory: factory, storage: storage)

    // stubbing
    given(factory.item(any())).will { paymentMethod in
      switch paymentMethod {
        case let applePay as ApplePay:
          return PaymentMethodItemApplePay(applePay: applePay)
        case let blikCode as BlikCode:
          return PaymentMethodItemBlikCode(blikCode: blikCode)
        case let blikToken as BlikToken:
          return PaymentMethodItemBlikToken(blikToken: blikToken)
        case let cardToken as CardToken:
          return PaymentMethodItemCardToken(cardToken: cardToken)
        case let insellments as Installments:
          return PaymentMethodItemInstallments(installments: insellments)
        case let payByLink as PayByLink:
          return PaymentMethodItemPayByLink(payByLink: payByLink)
        default:
          return nil
      }
    }
  }

  override func tearDown() {
    super.tearDown()
    reset(factory)
    reset(storage)
    sut = nil
  }

  func testWhenConfigurationContainsApplePayThenShouldAppendIt() {
    let payByLink = makePayByLink(value: PaymentMethodValue.applePay)

    let blikTokens: [BlikToken] = []
    let cardTokens: [CardToken] = []
    let payByLinks: [PayByLink] = [payByLink]

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemApplePay }.count, 1)
  }

  func testWhenConfigurationDoesNotContainApplePayThenShouldNotAppendIt() {
    let blikTokens: [BlikToken] = []
    let cardTokens: [CardToken] = []
    let payByLinks: [PayByLink] = [makePayByLink(), makePayByLink()]

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemApplePay }.count, 0)
  }

  func testWhenBlikCodeIsEnabledThenShouldAppendBlikCode() {
    assertBlikPaymentMethod(
        enableBlikCode: true,
        payByLinkValue: "blik",
        expectedBlikCodeCount: 1,
        expectedBlikTokenCount: 0,
        blikTokens: []
    )
    
  }

  func testWhenBlikCodeIsDisabledThenShouldNotAppendBlikCode() {
    assertBlikPaymentMethod(
        enableBlikCode: false,
        payByLinkValue: "blik",
        expectedBlikCodeCount: 0,
        expectedBlikTokenCount: 0,
        blikTokens: []
    )
  }
    
  func testWhenHasBlikTokenThenShouldNotAppendBlikCode() {
    assertBlikPaymentMethod(
        enableBlikCode: true,
        payByLinkValue: "blik",
        expectedBlikCodeCount: 0,
        expectedBlikTokenCount: 1,
        blikTokens: [makeBlikToken()]
    )
  }
    
  func testWhenNoBlikPblActiveThenShouldNotAppendBlik() {
    assertBlikPaymentMethod(
        enableBlikCode: true,
        payByLinkValue: nil,
        expectedBlikCodeCount: 0,
        expectedBlikTokenCount: 0,
        blikTokens: [makeBlikToken()]
    )
  }
    
  private func assertBlikPaymentMethod(
    enableBlikCode: Bool,
    payByLinkValue: String?,
    expectedBlikCodeCount: Int,
    expectedBlikTokenCount: Int,
    blikTokens: [BlikToken]? = []
  ) {
    let blikTokens: [BlikToken]? = blikTokens
    let cardTokens: [CardToken] = []
    let payByLinks: [PayByLink] = [makePayByLink(value: payByLinkValue)]

    let configuration = PaymentMethodsConfiguration(
        blikTokens: blikTokens,
        cardTokens: cardTokens,
        payByLinks: payByLinks
    )
          
    PayU.enableBlikCode = enableBlikCode
      
    let paymentItems = sut.makePaymentMethodItems(for: configuration)
        
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemBlikCode }.count, expectedBlikCodeCount)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemBlikToken }.count, expectedBlikTokenCount)
  }
    
    
  func testWhenConfigurationContainsNotEmptyBlikTokensThenShouldNotAppendBlikCode() {
    let blikTokens: [BlikToken] = [makeBlikToken(), makeBlikToken()]
    let cardTokens: [CardToken] = []
    let payByLinks: [PayByLink] = []

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemBlikCode }.count, 0)
  }

  func testWhenConfigurationDoesNotContainBlikTokensThenShouldNotAppendBlikCode() {
    let cardTokens: [CardToken] = []
    let payByLinks: [PayByLink] = []

    let configuration = PaymentMethodsConfiguration(
      blikTokens: nil,
      cardTokens: cardTokens,
      payByLinks: payByLinks)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemBlikCode }.count, 0)
  }

  func testWhenConfigurationContainsBlikTokensThenShouldReturnIt() {
    let blikTokens: [BlikToken] = [makeBlikToken(), makeBlikToken(), makeBlikToken()]
    let cardTokens: [CardToken] = []
    let payByLinks: [PayByLink] = [makePayByLink(value: "blik")]

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemBlikToken }.count, 3)
  }

  func testWhenConfigurationContainsCardTokenThenShouldReturnIt() {
    let blikTokens: [BlikToken] = []
    let cardTokens: [CardToken] = [makeCardToken(), makeCardToken()]
    let payByLinks: [PayByLink] = []

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemCardToken }.count, 2)
  }

  func testWhenConfigurationHasEnabledAddCardShouldReturnIt() {
    let blikTokens: [BlikToken] = []
    let cardTokens: [CardToken] = []
    let payByLinks: [PayByLink] = []

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks,
      enableAddCard: true)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemCard }.count, 1)
  }

  func testWhenConfigurationHasDisabledAddCardShouldNotReturnIt() {
    let blikTokens: [BlikToken] = []
    let cardTokens: [CardToken] = []
    let payByLinks: [PayByLink] = []

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks,
      enableAddCard: false)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemCard }.count, 0)
  }

  func testWhenConfigurationHasEnabledPayByLinksThenShouldReturnIt() {
    let blikTokens: [BlikToken] = []
    let cardTokens: [CardToken] = []
    let payByLinks: [PayByLink] = []

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks,
      enablePayByLinks: true)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemBankTransfer }.count, 1)
  }

  func testWhenConfigurationHasDisabledPayByLinksThenShouldNotReturnIt() {
    let blikTokens: [BlikToken] = []
    let cardTokens: [CardToken] = []
    let payByLinks: [PayByLink] = []

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks,
      enablePayByLinks: false)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemBankTransfer }.count, 0)
  }

  func testWhenConfigurationContainsPayByLinksThenShouldNotReturnIt() {
    let blikTokens: [BlikToken] = []
    let cardTokens: [CardToken] = []
    let payByLinks: [PayByLink] = [makePayByLink(), makePayByLink(), makePayByLink()]

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemPayByLink }.count, 0)
  }

  func testWhenConfigurationContainsGooglePayThenShouldNotReturnIt() {
    let blikTokens: [BlikToken] = []
    let cardTokens: [CardToken] = []
    let payByLinks: [PayByLink] = [makePayByLink(value: PaymentMethodValue.googlePay)]

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.filter { $0 is PaymentMethodItemPayByLink }.count, 0)
  }

  func testWhenStorageReturnsSelectedPaymentValueThenShouldPlaceItAsFirst() {
    let payByLink = makePayByLink()

    given(storage.getSelectedPaymentMethodValue()).willReturn(payByLink.value)

    let blikTokens: [BlikToken] = [makeBlikToken(), makeBlikToken()]
    let cardTokens: [CardToken] = [makeCardToken(), makeCardToken()]
    let payByLinks: [PayByLink] = [makePayByLink(), makePayByLink(), payByLink]

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks)

    let paymentItems = sut.makePaymentMethodItems(for: configuration)
    XCTAssertEqual(paymentItems.first?.value, payByLink.value)
  }

  func testWhenStorageReturnsNilThenShouldReturnEmptyPaymentMethod() {
    let payByLink = makePayByLink()

    given(storage.getSelectedPaymentMethodValue()).willReturn(nil)

    let blikTokens: [BlikToken] = [makeBlikToken(), makeBlikToken()]
    let cardTokens: [CardToken] = [makeCardToken(), makeCardToken()]
    let payByLinks: [PayByLink] = [makePayByLink(), makePayByLink(), payByLink]

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks)

    let paymentMethod = sut.getSavedPaymentMethod(for: configuration)
    XCTAssertNil(paymentMethod)
  }

  func testWhenStorageReturnsSelectedPaymentValueThenShouldReturnSavedPaymentMethod() {
    let payByLink = makePayByLink()

    given(storage.getSelectedPaymentMethodValue()).willReturn(payByLink.value)

    let blikTokens: [BlikToken] = [makeBlikToken(), makeBlikToken()]
    let cardTokens: [CardToken] = [makeCardToken(), makeCardToken()]
    let payByLinks: [PayByLink] = [makePayByLink(), makePayByLink(), payByLink]

    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks)

    let paymentMethod = sut.getSavedPaymentMethod(for: configuration)
    XCTAssertEqual(paymentMethod?.value, payByLink.value)
  }
}

private extension PaymentMethodsServiceTests {
  func makeBrandImageUrl() -> String {
    "https://www.payu.com/image_\(UUID().uuidString).jpg"
  }

  func makePayByLinkApplePay() -> PayByLink {
    makePayByLink()
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

  func makeBlikTokens() -> [BlikToken] {
    [BlikToken](
      repeating: makeBlikToken(),
      count: Int.random(in: 2...3))
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

  func makeInstallments() -> Installments {
    Installments(payByLink: makePayByLink())
  }

  func makePayByLink(value: String? = nil) -> PayByLink {
    PayByLink(
      brandImageUrl: makeBrandImageUrl(),
      name: UUID().uuidString,
      status: .enabled,
      value: value ?? UUID().uuidString
    )
  }

  func makePayByLinks() -> [PayByLink] {
    [PayByLink](
      repeating: makePayByLink(),
      count: Int.random(in: 2...3))
  }
}
