//
//  PKPaymentNetworkExtensionsTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import PassKit
@testable import PUApplePay

final class PKPaymentNetworkExtensionsTests: XCTestCase {
  func testShouldHaveExpectedNetworks() throws {
    let sut = PKPaymentNetwork.networks()

    if #available(iOS 12.0, *) {
      XCTAssertTrue(sut.contains(.maestro))
      XCTAssertTrue(sut.contains(.masterCard))
      XCTAssertTrue(sut.contains(.visa))
    } else {
      XCTAssertTrue(sut.contains(.masterCard))
      XCTAssertTrue(sut.contains(.visa))
    }
  }
}
