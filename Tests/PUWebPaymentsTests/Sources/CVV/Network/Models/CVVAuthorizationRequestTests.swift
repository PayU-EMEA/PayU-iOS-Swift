//
//  CVVAuthorizationRequestTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUWebPayments

final class CVVAuthorizationRequestTests: XCTestCase {

  private var sut: CVVAuthorizationRequest!
  private var refReqId: String!
  private var cvv: String!

  override func setUp() {
    super.setUp()
    refReqId = UUID().uuidString
    cvv = UUID().uuidString
    sut = CVVAuthorizationRequest(
      data: CVVAuthorizationRequest.Data(
        refReqId: refReqId,
        cvv: cvv
      )
    )
  }

  override func tearDown() {
    super.tearDown()
    refReqId = nil
    cvv = nil
    sut = nil
  }

  func testMapsCorrectly() throws {
    XCTAssertEqual(sut.request, "auth.cvv")
    XCTAssertEqual(sut.data.refReqId, refReqId)
    XCTAssertEqual(sut.data.cvv, cvv)
  }
}

