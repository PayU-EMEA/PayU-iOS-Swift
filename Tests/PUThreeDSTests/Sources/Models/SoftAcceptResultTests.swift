//
//  SoftAcceptResultTests.swift
//  
//  Created by PayU S.A. on 10/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import Foundation

import XCTest
@testable import PUThreeDS

final class SoftAcceptResultTests: XCTestCase {
  func testShouldMapMessageCorrectly() throws {
    let message = """
          {
            "data":"AUTHENTICATION_CANCELED",
            "href":"about:blank",
            "userAgent":"Mozilla/5.0 (iPhone; CPU iPhone OS 16_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
        }
        """
    let sut = SoftAcceptResult.from(message: message)
    XCTAssertNotNil(sut)
    XCTAssertEqual(sut?.data, "AUTHENTICATION_CANCELED")
    XCTAssertEqual(sut?.href, "about:blank")
    XCTAssertEqual(sut?.userAgent, "Mozilla/5.0 (iPhone; CPU iPhone OS 16_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148")
    XCTAssertEqual(sut?.status, .authenticationCanceled)
  }
}
