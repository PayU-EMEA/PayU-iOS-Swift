//
//  URLComponentsTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUWebPayments

final class URLComponentsTests: XCTestCase {

  func testIsHTTPReturnsCorrectResult() throws {
    XCTAssertEqual(URL(string: "http://www.payu.com?refReqId=refReqId")?.components?.isHTTP(), true)
    XCTAssertEqual(URL(string: "https://www.payu.com?refReqId=refReqId")?.components?.isHTTP(), false)
    XCTAssertEqual(URL(string: "mtm:payu?refReqId=refReqId")?.components?.isHTTP(), false)
  }

  func testIsHTTPSReturnsCorrectResult() throws {
    XCTAssertEqual(URL(string: "https://www.payu.com?refReqId=refReqId")?.components?.isHTTPS(), true)
    XCTAssertEqual(URL(string: "http://www.payu.com?refReqId=refReqId")?.components?.isHTTPS(), false)
    XCTAssertEqual(URL(string: "mtm:payu?refReqId=refReqId")?.components?.isHTTP(), false)
  }

  func testHasQueryItemReturnsCorrectResult() throws {
    XCTAssertEqual(URL(string: "https://www.payu.com?refReqId=refReqId")?.components?.hasQueryItem("refReqId"), true)
    XCTAssertEqual(URL(string: "https://www.payu.com?authenticationId=authenticationId")?.components?.hasQueryItem("authenticationId"), true)
    XCTAssertEqual(URL(string: "https://www.payu.com?authenticationId=authenticationId")?.components?.hasQueryItem("refReqId"), false)
  }

  func testQueryItemReturnsCorrectResult() throws {
    XCTAssertEqual(URL(string: "https://www.payu.com?refReqId=refReqId")?.components?.queryItem("refReqId")?.value, "refReqId")
    XCTAssertEqual(URL(string: "https://www.payu.com?authenticationId=authenticationId")?.components?.queryItem("authenticationId")?.value, "authenticationId")
    XCTAssertEqual(URL(string: "https://www.payu.com?authenticationId=authenticationId")?.components?.queryItem("refReqId")?.value, nil)
  }
  
}
