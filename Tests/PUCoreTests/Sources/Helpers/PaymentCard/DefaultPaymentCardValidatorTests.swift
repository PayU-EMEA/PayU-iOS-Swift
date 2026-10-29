//
//  DefaultPaymentCardValidatorTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
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

    dateParser = PaymentCardDateParserProtocolMock()
    luhnValidator = PaymentCardLuhnValidatorProtocolMock()
    providerFinder = PaymentCardProviderFinderProtocolMock()

    cvvValidator = DefaultPaymentCardCVVValidator()
    dateValidator = DefaultPaymentCardDateValidator(dateParser: dateParser)
    numberValidator = DefaultPaymentCardNumberValidator(providerFinder: providerFinder)
  }

  override func tearDown() {
    super.tearDown()
    dateParser = nil
    luhnValidator = nil
    providerFinder = nil

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
    dateParser.parseHandler = { self.dateFormatter.date(from: $0) }
    XCTAssertNoThrow(try dateValidator.validate("03/2030"))
    XCTAssertNoThrow(try dateValidator.validate("03/2035"))
  }

  func testDateValidatorShouldNotValidateCorrectDateInPast() throws {
    dateParser.parseHandler = { self.dateFormatter.date(from: $0) }
    XCTAssertThrowsError(try dateValidator.validate("03/2000")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_card_date") }
    XCTAssertThrowsError(try dateValidator.validate("03/2022")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_card_date") }
  }

  func testDateValidatorShouldNotValidateIncorrectDate() throws {
    dateParser.parseHandler = { self.dateFormatter.date(from: $0) }
    XCTAssertThrowsError(try dateValidator.validate(nil)) { e in XCTAssertEqual(e.localizedDescription, "enter_card_date") }
    XCTAssertThrowsError(try dateValidator.validate("")) { e in XCTAssertEqual(e.localizedDescription, "enter_card_date") }
    XCTAssertThrowsError(try dateValidator.validate("03")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_card_date") }
    XCTAssertThrowsError(try dateValidator.validate("0323")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_card_date") }
  }

  func testNumberValidatorShouldValidateCorrectNumber() throws {

    providerFinder.findHandler = { _ in .maestro }
    XCTAssertNoThrow(try numberValidator.validate("6759 6498 2643 8453"))
    XCTAssertNoThrow(try numberValidator.validate("6799 9901 0000 0000 019"))

    providerFinder.findHandler = { _ in .mastercard }
    XCTAssertNoThrow(try numberValidator.validate("5598 6148 1656 3766"))
    XCTAssertNoThrow(try numberValidator.validate("5555 5555 5555 4444"))

    providerFinder.findHandler = { _ in .visa }
    XCTAssertNoThrow(try numberValidator.validate("4012 0010 3714 1112"))
    XCTAssertNoThrow(try numberValidator.validate("4245 7576 6634 9685"))
  }

  func testNumberValidatorShouldNotValidateIncorrectNumber() throws {
    XCTAssertThrowsError(try numberValidator.validate(nil)) { e in XCTAssertEqual(e.localizedDescription, "enter_card_number") }
    XCTAssertThrowsError(try numberValidator.validate("")) { e in XCTAssertEqual(e.localizedDescription, "enter_card_number") }
    XCTAssertThrowsError(try numberValidator.validate("6799")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_card_number") }
  }
    
  func testNumberCardValidatorShouldCanBeCompleted() throws {
    
    XCTAssertThrowsError(try numberValidator.canBeCompleted("6799")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_card_number") }
    providerFinder.findHandler = { _ in .visa }
    XCTAssertTrue(try numberValidator.canBeCompleted("4012 0010 3714 1112"))
    XCTAssertFalse(try numberValidator.canBeCompleted("4012 0010 3714 3"))
      
    providerFinder.findHandler = { _ in .maestro }
    XCTAssertTrue(try numberValidator.canBeCompleted("6759 6498 2643 8453"))
    XCTAssertTrue(try numberValidator.canBeCompleted("6799 9901 0000 0000 019"))

      
    providerFinder.findHandler = { _ in .mastercard }
    XCTAssertTrue(try numberValidator.canBeCompleted("5598 6148 1656 3766"))
    XCTAssertTrue(try numberValidator.canBeCompleted("5555 5555"))
  }
    
  func testCvvValidatorShouldCanBeCompleted() throws {
      
      XCTAssertThrowsError(try cvvValidator.validate("12")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_cvv") }
      XCTAssertTrue(try cvvValidator.canBeCompleted("123"))
      XCTAssertTrue(try cvvValidator.canBeCompleted("999"))
  }
    
  func testDateValidatorShouldCanBeCompleted() throws {
      
      XCTAssertThrowsError(try dateValidator.canBeCompleted("03")) { e in XCTAssertEqual(e.localizedDescription, "enter_valid_card_date") }
      
      dateParser.parseHandler = { self.dateFormatter.date(from: $0) }
      XCTAssertTrue(try dateValidator.canBeCompleted("03/2035"))
  }
}
