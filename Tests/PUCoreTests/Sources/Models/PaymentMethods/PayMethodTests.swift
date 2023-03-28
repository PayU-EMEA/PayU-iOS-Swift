//
//  PayMethodTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class PayMethodTests: XCTestCase {

  func testHasCorrectValueForBlikPayMethodType() throws {
    XCTAssertEqual(PayMethod.PayMethodType.blik.rawValue, "BLIK")
  }

  func testHasCorrectValueForBlikTokenPayMethodType() throws {
    XCTAssertEqual(PayMethod.PayMethodType.blikToken.rawValue, "BLIK_TOKEN")
  }

  func testHasCorrectValueForCardTokenPayMethodType() throws {
    XCTAssertEqual(PayMethod.PayMethodType.cardToken.rawValue, "CARD_TOKEN")
  }

  func testHasCorrectValueForInstallmentsPayMethodType() throws {
    XCTAssertEqual(PayMethod.PayMethodType.installmenst.rawValue, "INSTALLMENTS")
  }

  func testHasCorrectValueForPBLPayMethodType() throws {
    XCTAssertEqual(PayMethod.PayMethodType.pbl.rawValue, "PBL")
  }

  func testShouldInitializeCorrectly() throws {
    let cardToken = PayMethod(type: .cardToken, value: "TOKC_QPY10DEHHLWPOMJIV5LWUZHG2DG")
    XCTAssertEqual(cardToken.type, .cardToken)
    XCTAssertEqual(cardToken.value, "TOKC_QPY10DEHHLWPOMJIV5LWUZHG2DG")
    XCTAssertNil(cardToken.authorizationCode)

    let blik = PayMethod(type: .blik, authorizationCode: "123456")
    XCTAssertEqual(blik.type, .blik)
    XCTAssertEqual(blik.authorizationCode, "123456")
    XCTAssertNil(blik.value)
  }
}
