//
//  SoftAcceptUrlModifierTests.swift
//  
//  Created by PayU S.A. on 10/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUThreeDS

final class SoftAcceptUrlModifierTests: XCTestCase {
  func testShouldModifyRedirectUrl() throws {
    let sut = SoftAcceptUrlModifier()
    let redirectUrl = URL(string: "https://www.payu.com?authenticationId=GH529b!0DLXy")!
    let result = sut.modify(redirectUrl)
    XCTAssertEqual(result.absoluteString, "https://www.payu.com?authenticationId=GH529b!0DLXy&sendCreq=false")
  }
}

