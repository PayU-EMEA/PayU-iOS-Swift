//
//  CVVAuthorizationNetworkTargetTests.swift
//

import XCTest

@testable import PUWebPayments

final class CVVAuthorizationNetworkTargetTests: XCTestCase {

  private var sut: CVVAuthorizationNetworkTarget!

  override func setUp() {
    super.setUp()
    sut = .authorizeCVV(
      CVVAuthorizationRequest(
        cvv: "123",
        refReqId: "refReqId"
      )
    )
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testShouldHaveCorrectRequest() throws {
    XCTAssertEqual(sut.path, "api/front/card-authorizations/refReqId/cvv")
    XCTAssertEqual(sut.httpMethod, "POST")
    XCTAssertEqual(sut.httpHeaders["Content-Type"], "application/json")
    XCTAssertEqual(sut.httpBody, "123".data(using: .utf8))
  }
}
