//
//  PaymentCardScannerTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUPaymentCardScanner

final class PaymentCardScannerTests: XCTestCase {

  func testIsAvailableReturnsCorrectValue() throws {
    if #available(iOS 13, *) {
      XCTAssertTrue(PaymentCardScanner.isAvailable())
    } else {
      XCTAssertFalse(PaymentCardScanner.isAvailable())
    }
  }

}
