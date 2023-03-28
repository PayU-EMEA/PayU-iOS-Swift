//
//  CVVAuthorizationResultTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUWebPayments

final class CVVAuthorizationResultTests: XCTestCase {

  func testSuccessHasCorrectRawValue() throws {
    XCTAssertEqual(CVVAuthorizationResult.success.rawValue, "SUCCESS")
  }

  func testCancelledHasCorrectRawValue() throws {
    XCTAssertEqual(CVVAuthorizationResult.cancelled.rawValue, "CANCELLED")
  }
}
