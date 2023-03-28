//
//  SoftAcceptLogTests.swift
//  
//  Created by PayU S.A. on 10/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUThreeDS

final class SoftAcceptLogTests: XCTestCase {
  func testShouldMapCorrectly() throws {
    let id = ".id"
    let message = ".message"
    let sut = SoftAcceptLog(id: id, message: message)
    XCTAssertEqual(sut.id, id)
    XCTAssertEqual(sut.message, message)
    XCTAssertEqual(sut.event, "receivedMessage")
    XCTAssertEqual(sut.level, "INFO")
    XCTAssertEqual(sut.sender, "PUSDK")
  }
}
