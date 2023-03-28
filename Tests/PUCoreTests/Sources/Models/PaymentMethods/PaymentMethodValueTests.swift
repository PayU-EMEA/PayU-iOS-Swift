//
//  PaymentMethodValueTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class PaymentMethodValueTests: XCTestCase {

  func testHasCorrectValueForApplePay() throws {
    XCTAssertEqual(PaymentMethodValue.applePay, "jp")
  }

  func testHasCorrectValueForBlikCode() throws {
    XCTAssertEqual(PaymentMethodValue.blikCode, "blik_code")
  }

  func testHasCorrectValueForGooglePay() throws {
    XCTAssertEqual(PaymentMethodValue.googlePay, "ap")
  }

  func testHasCorrectValueForMastercardInstallments() throws {
    XCTAssertEqual(PaymentMethodValue.mastercardInstallments, "ai")
  }
}
