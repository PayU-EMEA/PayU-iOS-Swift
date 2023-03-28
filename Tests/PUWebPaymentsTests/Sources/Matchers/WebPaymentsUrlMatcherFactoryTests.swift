//
//  WebPaymentsUrlMatcherFactoryTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUWebPayments

final class WebPaymentsUrlMatcherFactoryTests: XCTestCase {

  private var continueUrl: URL!
  private var sut: WebPaymentsUrlMatcherFactory!

  override func setUp() {
    super.setUp()
    sut = WebPaymentsUrlMatcherFactory()
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testMakeForPayByLinkShouldReturnCorrectMatcher() throws {
    let continueUrl = URL(string: "https://www.payu.com")!
    let redirectUrl = URL(string: "https://www.payu.com")!

    let request = WebPaymentsRequest(
      requestType: .payByLink,
      redirectUrl: redirectUrl,
      continueUrl: continueUrl)

    let matcher = sut.make(for: request)
    XCTAssertTrue(matcher is PayByLinkUrlMatcher)
  }

  func testMakeForThreeDSShouldReturnCorrectMatcher() throws {
    let continueUrl = URL(string: "https://www.payu.com")!
    let redirectUrl = URL(string: "https://www.payu.com")!

    let request = WebPaymentsRequest(
      requestType: .threeDS,
      redirectUrl: redirectUrl,
      continueUrl: continueUrl)

    let matcher = sut.make(for: request)
    XCTAssertTrue(matcher is ThreeDSUrlMatcher)
  }

}
