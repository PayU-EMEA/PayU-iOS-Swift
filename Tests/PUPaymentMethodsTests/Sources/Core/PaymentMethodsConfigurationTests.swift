//
//  PaymentMethodsConfigurationTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore
@testable import PUPaymentMethods

final class PaymentMethodsConfigurationTests: XCTestCase {

  private var blikTokens: [BlikToken]!
  private var cardTokens: [CardToken]!
  private var payByLinks: [PayByLink]!

  private var sut: PaymentMethodsConfiguration!

  override func setUp() {
    super.setUp()
    blikTokens = decode(type: [BlikToken].self, from: "blik_tokens")
    cardTokens = decode(type: [CardToken].self, from: "card_tokens")
    payByLinks = decode(type: [PayByLink].self, from: "pay_by_links")
  }

  override func tearDown() {
    super.tearDown()
    blikTokens = nil
    cardTokens = nil
    payByLinks = nil
  }

  func testBlikTokensAreCorrectAfterBeingInitilized() {
    sut = PaymentMethodsConfiguration(blikTokens: blikTokens)
    XCTAssertEqual(sut.blikTokens, blikTokens)
  }

  func testCardTokensAreCorrectAfterBeingInitilized() {
    sut = PaymentMethodsConfiguration(cardTokens: cardTokens, showExpiredCards: true)
    XCTAssertEqual(sut.cardTokens.count, cardTokens.count)

    sut = PaymentMethodsConfiguration(cardTokens: cardTokens, showExpiredCards: false)
    XCTAssertEqual(sut.cardTokens.count, cardTokens.filter { $0.status == .active }.count )
  }

  func testPayByLinksAreCorrectAfterBeingInitilized() {
    sut = PaymentMethodsConfiguration(payByLinks: payByLinks, showDisabledPayByLinks: true)
    XCTAssertEqual(sut.payByLinks.count, payByLinks.count)

    sut = PaymentMethodsConfiguration(payByLinks: payByLinks, showDisabledPayByLinks: false)
    XCTAssertEqual(sut.payByLinks.count, payByLinks.filter { $0.status == .enabled }.count )
  }

  func testEnableAddCardIsCorrectAfterBeingInitilized() {
    sut = PaymentMethodsConfiguration()
    XCTAssertTrue(sut.enableAddCard)

    sut = PaymentMethodsConfiguration(enableAddCard: true)
    XCTAssertTrue(sut.enableAddCard)

    sut = PaymentMethodsConfiguration(enableAddCard: false)
    XCTAssertFalse(sut.enableAddCard)
  }

  func testEnablePayByLinksIsCorrectAfterBeingInitilized() {
    sut = PaymentMethodsConfiguration()
    XCTAssertTrue(sut.enablePayByLinks)

    sut = PaymentMethodsConfiguration(enablePayByLinks: true)
    XCTAssertTrue(sut.enablePayByLinks)

    sut = PaymentMethodsConfiguration(enablePayByLinks: false)
    XCTAssertFalse(sut.enablePayByLinks)
  }

  func testShowExpiredCardsIsCorrectAfterBeingInitilized() {
    sut = PaymentMethodsConfiguration()
    XCTAssertTrue(sut.enablePayByLinks)

    sut = PaymentMethodsConfiguration(enablePayByLinks: true)
    XCTAssertTrue(sut.enablePayByLinks)

    sut = PaymentMethodsConfiguration(enablePayByLinks: false)
    XCTAssertFalse(sut.enablePayByLinks)
  }

  func testCopyWithCardTokenAppendsCardTokenToCardTokens() {
    let configuration = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks,
      enableAddCard: true,
      enablePayByLinks: true
    )

    let sut = configuration.copyWith(makeCardToken())

    XCTAssertEqual(sut.blikTokens?.count, configuration.blikTokens?.count)
    XCTAssertEqual(sut.cardTokens.count, configuration.cardTokens.count + 1)
    XCTAssertEqual(sut.payByLinks.count, configuration.payByLinks.count)

    XCTAssertEqual(sut.enableAddCard, true)
    XCTAssertEqual(sut.enablePayByLinks, true)
  }

  func testCopyWithCardTokenReturnsCorrectPaymentMethodsConfiguration() {
    let sutOne = PaymentMethodsConfiguration(
      blikTokens: blikTokens,
      cardTokens: cardTokens,
      payByLinks: payByLinks,
      enableAddCard: true,
      enablePayByLinks: true,
      showExpiredCards: true,
      showDisabledPayByLinks: true
    ).copyWith(makeCardToken())

    XCTAssertEqual(sutOne.blikTokens, blikTokens)
    XCTAssertEqual(sutOne.cardTokens.count, cardTokens.count + 1)
    XCTAssertEqual(sutOne.payByLinks, payByLinks)
    XCTAssertEqual(sutOne.enableAddCard, true)
    XCTAssertEqual(sutOne.enablePayByLinks, true)

    let sutTwo = PaymentMethodsConfiguration(
      blikTokens: [],
      cardTokens: [],
      payByLinks: [],
      enableAddCard: false,
      enablePayByLinks: false,
      showExpiredCards: false,
      showDisabledPayByLinks: false
    ).copyWith(makeCardToken())

    XCTAssertEqual(sutTwo.blikTokens, [])
    XCTAssertEqual(sutTwo.cardTokens.count, 1)
    XCTAssertEqual(sutTwo.payByLinks, [])
    XCTAssertEqual(sutTwo.enableAddCard, false)
    XCTAssertEqual(sutTwo.enablePayByLinks, false)
  }

}

private extension PaymentMethodsConfigurationTests {
  func makeBrandImageUrl() -> String {
    "https://www.payu.com/image_\(UUID().uuidString).jpg"
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
}
