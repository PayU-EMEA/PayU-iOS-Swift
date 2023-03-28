//
//  PKMerchantCapabilityExtensionsTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import PassKit
@testable import PUApplePay

final class NetworkClientCertificateTests: XCTestCase {
  func testShouldHaveExpectedCapabilities() throws {
    let sut = PKMerchantCapability.capabilities()
    XCTAssertTrue(sut == [.capabilityCredit, .capabilityDebit, .capability3DS])
  }
}
