//
//  DefaultPaymentCardLuhnValidatorTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class DefaultPaymentCardLuhnValidatorTests: XCTestCase {

  private var sut: DefaultPaymentCardLuhnValidator!

  override func setUp() {
    super.setUp()
    sut = DefaultPaymentCardLuhnValidator()
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testReturnsTrueForCorrectPaymentCardNumber() throws {
    XCTAssertTrue(sut.matches("4444333322221111"))
    XCTAssertTrue(sut.matches("5434021016824014"))
    XCTAssertTrue(sut.matches("5598614816563766"))
    XCTAssertTrue(sut.matches("5150030090050083"))
  }

  func testReturnsFalseForIncorrectPaymentCardNumber() throws {
    XCTAssertFalse(sut.matches("4444333322221112"))
    XCTAssertFalse(sut.matches("5434021016824012"))
    XCTAssertFalse(sut.matches("5598614816563762"))
    XCTAssertFalse(sut.matches("5150030090050082"))
  }
}

