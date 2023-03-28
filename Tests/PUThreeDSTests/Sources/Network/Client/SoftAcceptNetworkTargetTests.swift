//
//  SoftAcceptNetworkTargetTests.swift
//  
//  Created by PayU S.A. on 10/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUThreeDS

final class SoftAcceptNetworkTargetTests: XCTestCase {
  func testShouldHaveCorrectPath() throws {
    let log = SoftAcceptLog(id: ".id", message: ".message")
    let sut = SoftAcceptNetworkTarget.create(log)
    XCTAssertEqual(sut.path, "front/logger")
  }

  func testShouldHaveCorrectHTTPMethod() throws {
    let log = SoftAcceptLog(id: ".id", message: ".message")
    let sut = SoftAcceptNetworkTarget.create(log)
    XCTAssertEqual(sut.httpMethod, "POST")
  }

  func testShouldHaveCorrectHTTPBody() throws {
    let log = SoftAcceptLog(id: ".id", message: ".message")
    let sut = SoftAcceptNetworkTarget.create(log)
    XCTAssertNotNil(sut.httpBody)
  }

  func testShouldHaveCorrectHTTPHeaders() throws {
    let log = SoftAcceptLog(id: ".id", message: ".message")
    let sut = SoftAcceptNetworkTarget.create(log)
    XCTAssertEqual(sut.httpHeaders["Content-Type"], "application/vnd.payu+json")
  }
}

