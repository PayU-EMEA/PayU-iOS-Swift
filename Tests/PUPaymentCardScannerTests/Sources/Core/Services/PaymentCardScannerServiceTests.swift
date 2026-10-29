//
//  PaymentCardScannerServiceTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore
@testable import PUPaymentCardScanner

final class PaymentCardScannerServiceTests: XCTestCase {

  private var paymentCardDateFormatter: PaymentCardFormatterProtocolMock!
  private var paymentCardDateValidator: PaymentCardValidatorProtocolMock!
  private var paymentCardNumberFormatter: PaymentCardFormatterProtocolMock!
  private var paymentCardNumberValidator: PaymentCardValidatorProtocolMock!
  private var sut: PaymentCardScannerService!

  private let cardNumber: String = "4444 3333 2222 1111"
  private let cardExpirationDate: String = "09/29"

  override func setUp() {
    super.setUp()
    paymentCardDateFormatter = PaymentCardFormatterProtocolMock()
    paymentCardDateValidator = PaymentCardValidatorProtocolMock()
    paymentCardNumberFormatter = PaymentCardFormatterProtocolMock()
    paymentCardNumberValidator = PaymentCardValidatorProtocolMock()
    sut = makePaymentCardScannerService(option: .numberAndDate)
  }

  override func tearDown() {
    super.tearDown()
    paymentCardDateFormatter = nil
    paymentCardDateValidator = nil
    paymentCardNumberFormatter = nil
    paymentCardNumberValidator = nil
    sut = nil
  }

  func testShouldKeepPropertiesAfterBeingInitilized() throws {
    sut = makePaymentCardScannerService(option: .number)
    XCTAssertEqual(sut.result.option, .number)

    sut = makePaymentCardScannerService(option: .numberAndDate)
    XCTAssertEqual(sut.result.option, .numberAndDate)
  }

  func testIsProcessedShouldReturnTrueWhenResultIsProcessed() throws {
    paymentCardDateFormatter.formattedHandler = { _ in self.cardExpirationDate }

    paymentCardNumberFormatter.formattedHandler = { _ in self.cardNumber }

    sut.process(cardNumber)
    sut.process(cardExpirationDate)

    XCTAssertTrue(sut.isProcessed())
  }

  func testIsProcessedShouldReturnTrueWhenResultIsNotProcessed() throws {
    struct ErrorMock: Error {  }

    paymentCardDateValidator.validateHandler = { _ in throw ErrorMock() }
    paymentCardDateFormatter.formattedHandler = { _ in self.cardExpirationDate }

    paymentCardNumberValidator.validateHandler = { _ in throw ErrorMock() }
    paymentCardNumberFormatter.formattedHandler = { _ in self.cardNumber }

    sut.process(cardNumber)
    sut.process(cardExpirationDate)

    XCTAssertFalse(sut.isProcessed())
  }

  func testProcessShouldSaveCardNumberIfValid() throws {
    struct ErrorMock: Error {  }

    paymentCardDateValidator.validateHandler = { _ in throw ErrorMock() }
    paymentCardDateFormatter.formattedHandler = { _ in "" }

    paymentCardNumberFormatter.formattedHandler = { _ in self.cardNumber }

    XCTAssertNil(sut.result.cardNumber)
    sut.process(cardNumber)

    XCTAssertTrue(paymentCardNumberValidator.validateArgValues.contains(cardNumber))
    XCTAssertTrue(paymentCardNumberFormatter.formattedArgValues.contains(cardNumber))
    XCTAssertEqual(sut.result.cardNumber, cardNumber)
  }

  func testProcessShouldNotSaveCardNumberIfNotValid() throws {
    struct ErrorMock: Error {  }

    paymentCardDateValidator.validateHandler = { _ in throw ErrorMock() }
    paymentCardNumberValidator.validateHandler = { _ in throw ErrorMock() }

    sut.process(cardNumber)

    XCTAssertEqual(paymentCardDateFormatter.formattedCallCount, 0)
    XCTAssertEqual(paymentCardNumberFormatter.formattedCallCount, 0)
    XCTAssertNil(sut.result.cardNumber)
  }

  func testProcessShouldSaveCardExpirationDateIfValid() throws {
    struct ErrorMock: Error {  }

    paymentCardDateFormatter.formattedHandler = { _ in self.cardExpirationDate }

    paymentCardNumberValidator.validateHandler = { _ in throw ErrorMock() }
    paymentCardNumberFormatter.formattedHandler = { _ in "" }

    XCTAssertNil(sut.result.cardExpirationDate)
    sut.process(cardExpirationDate)
    XCTAssertTrue(paymentCardDateValidator.validateArgValues.contains(cardExpirationDate))
    XCTAssertTrue(paymentCardDateFormatter.formattedArgValues.contains(cardExpirationDate))
    XCTAssertEqual(sut.result.cardExpirationDate, cardExpirationDate)
  }

  func testProcessShouldNotSaveCardExpirationDateIfNotValid() throws {
    struct ErrorMock: Error {  }

    paymentCardDateValidator.validateHandler = { _ in throw ErrorMock() }
    paymentCardNumberValidator.validateHandler = { _ in throw ErrorMock() }

    sut.process(cardExpirationDate)

    XCTAssertEqual(paymentCardDateFormatter.formattedCallCount, 0)
    XCTAssertEqual(paymentCardNumberFormatter.formattedCallCount, 0)
    XCTAssertNil(sut.result.cardExpirationDate)
  }

}

private extension PaymentCardScannerServiceTests {
  func makePaymentCardScannerService(option: PaymentCardScannerOption) -> PaymentCardScannerService {
    PaymentCardScannerService(
      option: option,
      paymentCardDateFormatter: paymentCardDateFormatter,
      paymentCardDateValidator: paymentCardDateValidator,
      paymentCardNumberFormatter: paymentCardNumberFormatter,
      paymentCardNumberValidator: paymentCardNumberValidator
    )
  }
}
