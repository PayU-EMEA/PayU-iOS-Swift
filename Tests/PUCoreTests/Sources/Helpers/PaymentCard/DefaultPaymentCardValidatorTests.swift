//
//  DefaultPaymentCardValidatorTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUCore

final class DefaultPaymentCardValidatorTests: XCTestCase {

  private var dateFormatter: DateFormatter!
  private var dateParser: PaymentCardDateParserProtocolMock!
  private var luhnValidator: PaymentCardLuhnValidatorProtocolMock!
  private var providerFinder: PaymentCardProviderFinderProtocolMock!

  private var cvvValidator: DefaultPaymentCardCVVValidator!
  private var dateValidator: DefaultPaymentCardDateValidator!
  private var numberValidator: DefaultPaymentCardNumberValidator!

  override func setUp() {
    super.setUp()

    dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/yyyy"

    dateParser = mock(PaymentCardDateParserProtocol.self)
    luhnValidator = mock(PaymentCardLuhnValidatorProtocol.self)
    providerFinder = mock(PaymentCardProviderFinderProtocol.self)

    cvvValidator = DefaultPaymentCardCVVValidator()
    dateValidator = DefaultPaymentCardDateValidator(dateParser: dateParser)
    numberValidator = DefaultPaymentCardNumberValidator(providerFinder: providerFinder)
  }

  override func tearDown() {
    super.tearDown()
    reset(dateParser)
    reset(luhnValidator)
    reset(providerFinder)

    dateFormatter = nil
    cvvValidator = nil
    dateValidator = nil
    numberValidator = nil
  }

  func testCVVValidatorShouldValidateCorrectCVV() throws {
    XCTAssertNoThrow(try cvvValidator.validate("123"))
    XCTAssertNoThrow(try cvvValidator.validate("659"))
  }

  func testCVVValidatorShouldNotValidateIncorrectCVV() throws {
    XCTAssertThrowsError(try cvvValidator.validate(nil)) { e in XCTAssertEqual(e.localizedDescription, "enter_cvv") }
    XCTAssertThrowsError(try cvvValidator.validate("")) { e in XCTAssertEqual(e.localizedDescription, "enter_cvv") }
    XCTAssertThrowsError(try cvvValidator.validate("")) { e in XCTAssertEqual(e.localizedDescription, "enter_cvv") }
    XCTAssertThrowsError(try cvvValidator.validate("12")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_cvv") }
  }

  func testDateValidatorShouldValidateCorrectDateInFuture() throws {
    given(dateParser.parse(any())).will { self.dateFormatter.date(from: $0) }
    XCTAssertNoThrow(try dateValidator.validate("03/2030"))
    XCTAssertNoThrow(try dateValidator.validate("03/2035"))
  }

  func testDateValidatorShouldNotValidateCorrectDateInPast() throws {
    given(dateParser.parse(any())).will { self.dateFormatter.date(from: $0) }
    XCTAssertThrowsError(try dateValidator.validate("03/2000")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_card_date") }
    XCTAssertThrowsError(try dateValidator.validate("03/2022")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_card_date") }
  }

  func testDateValidatorShouldNotValidateIncorrectDate() throws {
    given(dateParser.parse(any())).will { self.dateFormatter.date(from: $0) }
    XCTAssertThrowsError(try dateValidator.validate(nil)) { e in XCTAssertEqual(e.localizedDescription, "enter_card_date") }
    XCTAssertThrowsError(try dateValidator.validate("")) { e in XCTAssertEqual(e.localizedDescription, "enter_card_date") }
    XCTAssertThrowsError(try dateValidator.validate("03")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_card_date") }
    XCTAssertThrowsError(try dateValidator.validate("0323")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_card_date") }
  }

  func testNumberValidatorShouldValidateCorrectNumber() throws {

    given(providerFinder.find(any())).willReturn(.maestro)
    XCTAssertNoThrow(try numberValidator.validate("6759 6498 2643 8453"))
    XCTAssertNoThrow(try numberValidator.validate("6799 9901 0000 0000 019"))

    given(providerFinder.find(any())).willReturn(.mastercard)
    XCTAssertNoThrow(try numberValidator.validate("5598 6148 1656 3766"))
    XCTAssertNoThrow(try numberValidator.validate("5555 5555 5555 4444"))

    given(providerFinder.find(any())).willReturn(.visa)
    XCTAssertNoThrow(try numberValidator.validate("4012 0010 3714 1112"))
    XCTAssertNoThrow(try numberValidator.validate("4245 7576 6634 9685"))
  }

  func testNumberValidatorShouldNotValidateIncorrectNumber() throws {
    XCTAssertThrowsError(try numberValidator.validate(nil)) { e in XCTAssertEqual(e.localizedDescription, "enter_card_number") }
    XCTAssertThrowsError(try numberValidator.validate("")) { e in XCTAssertEqual(e.localizedDescription, "enter_card_number") }
    XCTAssertThrowsError(try numberValidator.validate("6799")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_card_number") }
  }
}
