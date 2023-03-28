//
//  POSTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUCore

final class POSTests: XCTestCase {

  func testShouldInitializeCorrectly() throws {
    let prod = POS(id: "123456", environment: .production)
    XCTAssertEqual(prod.id, "123456")
    XCTAssertEqual(prod.environment, .production)

    let sandbox = POS(id: "357902", environment: .sandbox)
    XCTAssertEqual(sandbox.id, "357902")
    XCTAssertEqual(sandbox.environment, .sandbox)

    let sandboxBeta = POS(id: "354902", environment: .sandboxBeta)
    XCTAssertEqual(sandboxBeta.id, "354902")
    XCTAssertEqual(sandboxBeta.environment, .sandboxBeta)
  }
}

