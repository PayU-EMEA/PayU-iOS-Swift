//
//  PayByLinkUrlMatcherTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUWebPayments

final class PayByLinkUrlMatcherTests: XCTestCase {

  private var continueUrl: URL!
  private var sut: PayByLinkUrlMatcher!

  override func setUp() {
    super.setUp()
    continueUrl = URL(string: "https://www.payu.com")!
    sut = PayByLinkUrlMatcher(continueUrl: continueUrl)
  }

  override func tearDown() {
    super.tearDown()
    continueUrl = nil
    sut = nil
  }

  func testWhenUrlIsEmptyRedirectionThenShouldReturnNotMatchedResult() throws {
    XCTAssertEqual(sut.result(URL(string: "about:blank")!), .notMatched)
  }

  func testWhenUrlIsExternalRedirectionThenShouldReturnExternalApplicationResult() throws {
    XCTAssertEqual(sut.result(URL(string: "mtm:another.app/key=value")!), .externalApplication)
  }

  func testWhenUrlIsNotTheSameAsContinueUrlThenShouldReturnNotMatchedResult() throws {
    XCTAssertEqual(sut.result(URL(string: "https://www.another.payu.com")!), .notMatched)
  }

  func testWhenUrlContainsErrorQueryItemThenShouldReturnFailureResult() throws {
    XCTAssertEqual(sut.result(URL(string: "https://www.payu.com?error=ERROR_CODE")!), .failure)
  }

  func testWhenUrlIsTheSameAsContinueUrlThenShouldReturnSuccessResult() throws {
    XCTAssertEqual(sut.result(continueUrl!), .success)
  }

  func testShouldMatchEmptyRedirectionsCorrectly() throws {
    XCTAssertEqual(sut.matchAboutBlank(URL(string: "about:blank")!), true)
    XCTAssertEqual(sut.matchAboutBlank(URL(string: "https://www.pay.com")!), false)
  }

  func testShouldMatchExternalSchemeCorrectly() throws {
    XCTAssertEqual(sut.matchExternalScheme(URL(string: "http://www.pay.com")!), false)
    XCTAssertEqual(sut.matchExternalScheme(URL(string: "mtm://hello.world")!), true)
  }

  func testShouldMatchStatusCodeQueryItemCorrectly() throws {
    XCTAssertEqual(sut.matchStatusCode(URL(string: "https://www.pay.com?statusCode=STATUS_CODE")!), true)
    XCTAssertEqual(sut.matchStatusCode(URL(string: "https://www.pay.com?invalidStatusCode=STATUS_CODE")!), false)
    XCTAssertEqual(sut.matchStatusCode(URL(string: "https://www.pay.com")!), false)
  }

  func testShouldMatchContinueUrlCorrectly() throws {
    XCTAssertEqual(sut.matchContinueUrl(URL(string: "https://www.mock.com")!, URL(string: "https://www.payu.com")!), false)
    XCTAssertEqual(sut.matchContinueUrl(URL(string: "https://www.payu.com")!, URL(string: "https://www.payu.com")!), true)
    XCTAssertEqual(sut.matchContinueUrl(URL(string: "https://www.payu.com/")!, URL(string: "https://www.payu.com")!), true)
    XCTAssertEqual(sut.matchContinueUrl(URL(string: "https://www.payu.com")!, URL(string: "https://www.payu.com/")!), true)
  }

  func testShouldMatchContinueUrlWithErrorQueryItemCorrectly() throws {
    XCTAssertEqual(sut.matchContinueUrlWithError(URL(string: "https://www.payu.com")!), false)
    XCTAssertEqual(sut.matchContinueUrlWithError(URL(string: "https://www.pay.com?invalidStatusCode=STATUS_CODE")!), false)
    XCTAssertEqual(sut.matchContinueUrlWithError(URL(string: "https://www.pay.com?error=ERROR_CODE")!), true)
    XCTAssertEqual(sut.matchContinueUrlWithError(URL(string: "https://www.pay.com?failure=FAILURE_CODE")!), true)
  }

}
