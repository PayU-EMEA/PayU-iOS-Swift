//
//  PaymentCardProviderTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class PaymentCardProviderTests: XCTestCase {

  func testMaestroPaymentCardProviderReturnsCorrectScheme() throws {
    XCTAssertEqual(PaymentCardProvider.maestro.scheme, "MC")
    XCTAssertEqual(PaymentCardProvider.maestro.type, .maestro)
  }

  func testMastercardPaymentCardProviderReturnsCorrectScheme() throws {
    XCTAssertEqual(PaymentCardProvider.mastercard.scheme, "MC")
    XCTAssertEqual(PaymentCardProvider.mastercard.type, .mastercard)
  }

  func testVisaPaymentCardProviderReturnsCorrectScheme() throws {
    XCTAssertEqual(PaymentCardProvider.visa.scheme, "VS")
    XCTAssertEqual(PaymentCardProvider.visa.type, .visa)
  }
}
