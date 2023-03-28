//
//  SoftAcceptRequestTests.swift
//  
//  Created by PayU S.A. on 10/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUThreeDS

final class SoftAcceptRequestTests: XCTestCase {
  func testShouldNotChangeRedirectUrl() throws {
    let redirectUrl = URL(string: "https://www.payu.com?authenticationId=GH529b!0DLXy")!
    let sut = SoftAcceptRequest(redirectUrl: redirectUrl)
    XCTAssertEqual(sut.redirectUrl.absoluteString, "https://www.payu.com?authenticationId=GH529b!0DLXy")
  }
}
