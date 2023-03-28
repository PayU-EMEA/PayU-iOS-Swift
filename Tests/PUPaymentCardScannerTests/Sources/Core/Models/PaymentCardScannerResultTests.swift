//
//  PaymentCardScannerResultTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUPaymentCardScanner

final class PaymentCardScannerResultTests: XCTestCase {

  private var cardNumber: String!
  private var cardExpirationDate: String!

  override func setUp() {
    super.setUp()
    cardNumber = UUID().uuidString
    cardExpirationDate = UUID().uuidString
  }

  override func tearDown() {
    super.tearDown()
    cardNumber = nil
    cardExpirationDate = nil
  }

  func testShouldKeepPropertiesAfterBeingInitilized() throws {
    let sut = PaymentCardScannerResult(
      option: .number,
      cardNumber: cardNumber,
      cardExpirationDate: cardExpirationDate)

    XCTAssertEqual(sut.option, .number)
    XCTAssertEqual(sut.cardNumber, cardNumber)
    XCTAssertEqual(sut.cardExpirationDate, cardExpirationDate)
  }


  func testIsProcessedForNumberOptionReturnsTrueWhenHasCardNumberAndCardExpirationDate() throws {
    XCTAssertTrue(
      PaymentCardScannerResult(
        option: .number,
        cardNumber: cardNumber,
        cardExpirationDate: cardExpirationDate)
      .isProcessed
    )
  }

  func testIsProcessedForNumberOptionReturnsTrueWhenHasCardNumberAndNoCardExpirationDate() throws {
    XCTAssertTrue(
      PaymentCardScannerResult(
        option: .number,
        cardNumber: cardNumber,
        cardExpirationDate: nil)
      .isProcessed
    )
  }

  func testIsProcessedForNumberOptionReturnsFalseWhenHasNoCardNumberAndCardExpirationDate() throws {
    XCTAssertFalse(
      PaymentCardScannerResult(
        option: .number,
        cardNumber: nil,
        cardExpirationDate: cardExpirationDate)
      .isProcessed
    )
  }

  func testIsProcessedForNumberOptionReturnsFalseWhenHasNoCardNumberAndNoCardExpirationDate() throws {
    XCTAssertFalse(
      PaymentCardScannerResult(
        option: .number,
        cardNumber: nil,
        cardExpirationDate: nil)
      .isProcessed
    )
  }


  func testIsProcessedForNumberAndDateOptionReturnsTrueWhenHasCardNumberAndCardExpirationDate() throws {
    XCTAssertTrue(
      PaymentCardScannerResult(
        option: .numberAndDate,
        cardNumber: cardNumber,
        cardExpirationDate: cardExpirationDate)
      .isProcessed
    )
  }

  func testIsProcessedForNumberAndDateOptionReturnsFalseWhenHasCardNumberAndNoCardExpirationDate() throws {
    XCTAssertFalse(
      PaymentCardScannerResult(
        option: .numberAndDate,
        cardNumber: cardNumber,
        cardExpirationDate: nil)
      .isProcessed
    )
  }

  func testIsProcessedForNumberAndDateOptionReturnsFalseWhenHasNoCardNumberAndCardExpirationDate() throws {
    XCTAssertFalse(
      PaymentCardScannerResult(
        option: .numberAndDate,
        cardNumber: nil,
        cardExpirationDate: cardExpirationDate)
      .isProcessed
    )
  }

  func testIsProcessedForNumberAndDateOptionReturnsFalseWhenHasNoCardNumberAndNoCardExpirationDate() throws {
    XCTAssertFalse(
      PaymentCardScannerResult(
        option: .numberAndDate,
        cardNumber: nil,
        cardExpirationDate: nil)
      .isProcessed
    )
  }

  func testIsProcessedAtLeastOneParameterReturnsTrueWhenHasCardNumberAndCardExpirationDate() throws {
    XCTAssertTrue(
      PaymentCardScannerResult(
        option: .numberAndDate,
        cardNumber: cardNumber,
        cardExpirationDate: cardExpirationDate)
      .isProcessedAtLeastOneParameter
    )
  }

  func testIsProcessedAtLeastOneParameterReturnsTrueWhenHasCardNumberAndNoCardExpirationDate() throws {
    XCTAssertTrue(
      PaymentCardScannerResult(
        option: .numberAndDate,
        cardNumber: cardNumber,
        cardExpirationDate: nil)
      .isProcessedAtLeastOneParameter
    )
  }

  func testIsProcessedAtLeastOneParameterReturnsTrueWhenHasNoCardNumberAndCardExpirationDate() throws {
    XCTAssertTrue(
      PaymentCardScannerResult(
        option: .numberAndDate,
        cardNumber: nil,
        cardExpirationDate: cardExpirationDate)
      .isProcessedAtLeastOneParameter
    )
  }

  func testIsProcessedAtLeastOneParameterReturnsFalseWhenHasNoCardNumberAndNoCardExpirationDate() throws {
    XCTAssertFalse(
      PaymentCardScannerResult(
        option: .numberAndDate,
        cardNumber: nil,
        cardExpirationDate: nil)
      .isProcessedAtLeastOneParameter
    )
  }

  func testCopyWithCardNumberReturnsCorrect() throws {
    let updatedCardNumber = UUID().uuidString

    let originalResult = PaymentCardScannerResult(
      option: .numberAndDate,
      cardNumber: cardNumber,
      cardExpirationDate: cardExpirationDate)

    let modifiedResult = originalResult.copyWith(
      cardNumber: updatedCardNumber)

    XCTAssertEqual(modifiedResult.option, originalResult.option)
    XCTAssertEqual(modifiedResult.cardNumber, updatedCardNumber)
    XCTAssertEqual(modifiedResult.cardExpirationDate, originalResult.cardExpirationDate)
  }

  func testCopyWithCardExpirationDateReturnsCorrect() throws {
    let updatedCardExpirationDate = UUID().uuidString

    let originalResult = PaymentCardScannerResult(
      option: .numberAndDate,
      cardNumber: cardNumber,
      cardExpirationDate: cardExpirationDate)

    let modifiedResult = originalResult.copyWith(
      cardExpirationDate: updatedCardExpirationDate)

    XCTAssertEqual(modifiedResult.option, originalResult.option)
    XCTAssertEqual(modifiedResult.cardNumber, originalResult.cardNumber)
    XCTAssertEqual(modifiedResult.cardExpirationDate, updatedCardExpirationDate)
  }
}
