//
//  DefaultPaymentCardProviderMatcherTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class DefaultPaymentCardProviderMatcherTests: XCTestCase {

  func testPaymentCardProviderMatcherMatchesMaestroNumbers() throws {
    let sut = PaymentCardProviderMatcherFactory().makeMaestro()
    XCTAssertTrue(sut.matches("6759 6498 2643 8453"))
    XCTAssertTrue(sut.matches("6799 9901 0000 0000 019"))
    XCTAssertTrue(sut.matches("5099 8022 1116 5618"))
    XCTAssertTrue(sut.matches("5000 1050 1812 65958"))
    XCTAssertTrue(sut.matches("6771 7980 2100 0008"))
  }

  func testPaymentCardProviderMatcherMatchesMastercardNumbers() throws {
    let sut = PaymentCardProviderMatcherFactory().makeMastercard()
    XCTAssertTrue(sut.matches("5598 6148 1656 3766"))
    XCTAssertTrue(sut.matches("5555 5555 5555 4444"))
    XCTAssertTrue(sut.matches("5454 5454 5454 5454"))
    XCTAssertTrue(sut.matches("2223 0000 4841 0010"))
  }

  func testPaymentCardProviderMatcherMatchesVisaNumbers() throws {
    let sut = PaymentCardProviderMatcherFactory().makeVisa()
    XCTAssertTrue(sut.matches("4012 0010 3714 1112"))
    XCTAssertTrue(sut.matches("4444 3333 2222 1111"))
    XCTAssertTrue(sut.matches("4245 7576 6634 9685"))
    XCTAssertTrue(sut.matches("4988 0800 0000 0000"))
  }

  func testPaymentCardProviderMatcherPossibleMaestroNumbers() throws {
    let sut = PaymentCardProviderMatcherFactory().makeMaestro()
    XCTAssertTrue(sut.possible("675"))
    XCTAssertTrue(sut.possible("679"))
    XCTAssertTrue(sut.possible("509"))
    XCTAssertTrue(sut.possible("500"))
    XCTAssertTrue(sut.possible("677"))
  }

  func testPaymentCardProviderMatcherPossibleMastercardNumbers() throws {
    let sut = PaymentCardProviderMatcherFactory().makeMastercard()
    XCTAssertTrue(sut.possible("559"))
    XCTAssertTrue(sut.possible("555"))
    XCTAssertTrue(sut.possible("545"))
    XCTAssertTrue(sut.possible("222"))
  }

  func testPaymentCardProviderMatcherPossibleVisaNumbers() throws {
    let sut = PaymentCardProviderMatcherFactory().makeVisa()
    XCTAssertTrue(sut.possible("401"))
    XCTAssertTrue(sut.possible("444"))
    XCTAssertTrue(sut.possible("4245"))
    XCTAssertTrue(sut.possible("498"))
  }
}
