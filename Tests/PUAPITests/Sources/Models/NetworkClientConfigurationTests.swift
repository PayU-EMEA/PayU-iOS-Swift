//
//  NetworkClientConfigurationTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUAPI

final class NetworkClientConfigurationTests: XCTestCase {
  func testShouldHaveCorrectBaseUrlForProduction() throws {
    let sut = NetworkClientConfiguration(environment: .production)
    XCTAssertEqual(sut.baseUrl.absoluteString, "https://mobilesdk.secure.payu.com")
  }

  func testShouldHaveCorrectBaseUrlForSandbox() throws {
    let sut = NetworkClientConfiguration(environment: .sandbox)
    XCTAssertEqual(sut.baseUrl.absoluteString, "https://secure.snd.payu.com")
  }

  func testShouldHaveCorrectBaseUrlForSandboxBeta() throws {
    let sut = NetworkClientConfiguration(environment: .sandboxBeta)
    XCTAssertEqual(sut.baseUrl.absoluteString, "https://secure.sndbeta.payu.com")
  }
}
