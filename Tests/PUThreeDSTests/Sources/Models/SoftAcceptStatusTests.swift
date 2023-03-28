//
//  SoftAcceptStatusTests.swift
//  
//  Created by PayU S.A. on 10/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUThreeDS

final class SoftAcceptStatusTests: XCTestCase {
  func testShouldHaveCorrectRawValue() throws {
    XCTAssertEqual(SoftAcceptStatus.displayFrame.rawValue, "DISPLAY_FRAME")
    XCTAssertEqual(SoftAcceptStatus.authenticationSuccessful.rawValue, "AUTHENTICATION_SUCCESSFUL")
    XCTAssertEqual(SoftAcceptStatus.authenticationCanceled.rawValue, "AUTHENTICATION_CANCELED")
    XCTAssertEqual(SoftAcceptStatus.authenticationNotRequired.rawValue, "AUTHENTICATION_NOT_REQUIRED")
    XCTAssertEqual(SoftAcceptStatus.unexpected.rawValue, "UNEXPECTED")
  }
}

