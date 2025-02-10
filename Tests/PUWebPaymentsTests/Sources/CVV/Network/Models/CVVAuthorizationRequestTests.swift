//
//  CVVAuthorizationRequestTests.swift
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
      cvv: cvv,
      refReqId: refReqId
    )
  }

  override func tearDown() {
    super.tearDown()
    refReqId = nil
    cvv = nil
    sut = nil
  }

  func testMapsCorrectly() throws {
    XCTAssertEqual(sut.refReqId, refReqId)
    XCTAssertEqual(sut.cvv, cvv)
  }
}
