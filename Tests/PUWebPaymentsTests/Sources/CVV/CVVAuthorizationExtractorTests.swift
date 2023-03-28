//
//  CVVAuthorizationExtractorTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUWebPayments

final class CVVAuthorizationExtractorTests: XCTestCase {

  private var sut: CVVAuthorizationExtractor!

  override func setUp() {
    super.setUp()
    sut = CVVAuthorizationExtractor()
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testExtractRefReqIdShouldReturnCorrectValueIfExists() throws {
    let redirectUrl = URL(string: "https://www.payu.com?refReqId=46D1F68C-5BF9-488E-8C29-D8731EEAFB31")!
    XCTAssertEqual(sut.extractRefReqId(redirectUrl), "46D1F68C-5BF9-488E-8C29-D8731EEAFB31")
  }

  func testExtractRefReqIdShouldNotReturnCorrectValueIfDoesNotExist() throws {
    let redirectUrl = URL(string: "https://www.payu.com?ref_req_id=46D1F68C-5BF9-488E-8C29-D8731EEAFB31")!
    XCTAssertNil(sut.extractRefReqId(redirectUrl))
  }
}
