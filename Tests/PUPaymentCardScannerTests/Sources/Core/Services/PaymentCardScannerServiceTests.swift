//
//  PaymentCardScannerServiceTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
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
    paymentCardDateFormatter = mock(PaymentCardFormatterProtocol.self)
    paymentCardDateValidator = mock(PaymentCardValidatorProtocol.self)
    paymentCardNumberFormatter = mock(PaymentCardFormatterProtocol.self)
    paymentCardNumberValidator = mock(PaymentCardValidatorProtocol.self)
    sut = makePaymentCardScannerService(option: .numberAndDate)
  }

  override func tearDown() {
    super.tearDown()
    reset(paymentCardDateFormatter)
    reset(paymentCardDateValidator)
    reset(paymentCardNumberFormatter)
    reset(paymentCardNumberValidator)
    sut = nil
  }

  func testShouldKeepPropertiesAfterBeingInitilized() throws {
    sut = makePaymentCardScannerService(option: .number)
    XCTAssertEqual(sut.result.option, .number)

    sut = makePaymentCardScannerService(option: .numberAndDate)
    XCTAssertEqual(sut.result.option, .numberAndDate)
  }

  func testIsProcessedShouldReturnTrueWhenResultIsProcessed() throws {
    given(paymentCardDateValidator.validate(any())).willReturn(())
    given(paymentCardDateFormatter.formatted(any())).willReturn(cardExpirationDate)

    given(paymentCardNumberValidator.validate(any())).willReturn(())
    given(paymentCardNumberFormatter.formatted(any())).willReturn(cardNumber)

    sut.process(cardNumber)
    sut.process(cardExpirationDate)

    XCTAssertTrue(sut.isProcessed())
  }

  func testIsProcessedShouldReturnTrueWhenResultIsNotProcessed() throws {
    struct ErrorMock: Error {  }

    given(paymentCardDateValidator.validate(any())).willThrow(ErrorMock())
    given(paymentCardDateFormatter.formatted(any())).willReturn(cardExpirationDate)

    given(paymentCardNumberValidator.validate(any())).willThrow(ErrorMock())
    given(paymentCardNumberFormatter.formatted(any())).willReturn(cardNumber)

    sut.process(cardNumber)
    sut.process(cardExpirationDate)

    XCTAssertFalse(sut.isProcessed())
  }

  func testProcessShouldSaveCardNumberIfValid() throws {
    struct ErrorMock: Error {  }

    given(paymentCardDateValidator.validate(any())).willThrow(ErrorMock())
    given(paymentCardDateFormatter.formatted(any())).willReturn("")

    given(paymentCardNumberValidator.validate(any())).willReturn(())
    given(paymentCardNumberFormatter.formatted(any())).willReturn(cardNumber)

    XCTAssertNil(sut.result.cardNumber)
    sut.process(cardNumber)

    verify(paymentCardNumberValidator.validate(cardNumber)).wasCalled()
    verify(paymentCardNumberFormatter.formatted(cardNumber)).wasCalled()
    XCTAssertEqual(sut.result.cardNumber, cardNumber)
  }

  func testProcessShouldNotSaveCardNumberIfNotValid() throws {
    struct ErrorMock: Error {  }

    given(paymentCardDateValidator.validate(any())).willThrow(ErrorMock())
    given(paymentCardNumberValidator.validate(any())).willThrow(ErrorMock())

    sut.process(cardNumber)

    verify(paymentCardDateFormatter.formatted(any())).wasNeverCalled()
    verify(paymentCardNumberFormatter.formatted(any())).wasNeverCalled()
    XCTAssertNil(sut.result.cardNumber)
  }

  func testProcessShouldSaveCardExpirationDateIfValid() throws {
    struct ErrorMock: Error {  }

    given(paymentCardDateValidator.validate(any())).willReturn(())
    given(paymentCardDateFormatter.formatted(any())).willReturn(cardExpirationDate)

    given(paymentCardNumberValidator.validate(any())).willThrow(ErrorMock())
    given(paymentCardNumberFormatter.formatted(any())).willReturn("")

    XCTAssertNil(sut.result.cardExpirationDate)
    sut.process(cardExpirationDate)
    verify(paymentCardDateValidator.validate(cardExpirationDate)).wasCalled()
    verify(paymentCardDateFormatter.formatted(cardExpirationDate)).wasCalled()
    XCTAssertEqual(sut.result.cardExpirationDate, cardExpirationDate)
  }

  func testProcessShouldNotSaveCardExpirationDateIfNotValid() throws {
    struct ErrorMock: Error {  }

    given(paymentCardDateValidator.validate(any())).willThrow(ErrorMock())
    given(paymentCardNumberValidator.validate(any())).willThrow(ErrorMock())

    sut.process(cardExpirationDate)

    verify(paymentCardDateFormatter.formatted(any())).wasNeverCalled()
    verify(paymentCardNumberFormatter.formatted(any())).wasNeverCalled()
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
