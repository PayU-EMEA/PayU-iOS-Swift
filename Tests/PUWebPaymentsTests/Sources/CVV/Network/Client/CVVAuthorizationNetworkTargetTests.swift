//
//  CVVAuthorizationNetworkTargetTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUWebPayments

final class CVVAuthorizationNetworkTargetTests: XCTestCase {

  private var sut: CVVAuthorizationNetworkTarget!

  override func setUp() {
    super.setUp()
    sut = .authorizeCVV(
      CVVAuthorizationRequest(
        data: CVVAuthorizationRequest.Data(
          refReqId: "refReqId",
          cvv: "123")
      )
    )
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testShouldHaveCorrectPath() throws {
    XCTAssertEqual(sut.path, "api/v2/token/token.json")
  }

  func testShouldHaveCorrectHTTPMethod() throws {
    XCTAssertEqual(sut.httpMethod, "POST")
  }

  // TODO: fix problem with data order
  func skipped_testShouldHaveCorrectHTTPBody() throws {
    let httpBody =
"""
data={"request":"auth.cvv","data":{"cvv":"123","refReqId":"refReqId"}}
"""
    XCTAssertEqual(sut.httpBody, httpBody.data(using: .utf8))
  }

  func testShouldHaveCorrectHTTPHeaders() throws {
    XCTAssertEqual(sut.httpHeaders["Content-Type"], "application/x-www-form-urlencoded")
  }
}
