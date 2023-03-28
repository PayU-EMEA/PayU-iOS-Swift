//
//  SoftAcceptConfigurationTests.swift
//  
//  Created by PayU S.A. on 10/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUThreeDS

final class SoftAcceptConfigurationTests: XCTestCase {
  func testShouldHaveCorrectOriginForProduction() throws {
    let sut = SoftAcceptConfiguration.Factory(environment: .production).make()
    XCTAssertEqual(sut.origin, "'https://secure.payu.com'")
  }

  func testShouldHaveCorrectOriginForSandbox() throws {
    let sut = SoftAcceptConfiguration.Factory(environment: .sandbox).make()
    XCTAssertEqual(sut.origin, "'https://merch-prod.snd.payu.com'")
  }

  func testShouldHaveCorrectOriginForSandboxBeta() throws {
    let sut = SoftAcceptConfiguration.Factory(environment: .sandboxBeta).make()
    XCTAssertEqual(sut.origin, "'https://secure.sndbeta.payu.com'")
  }

  func testShouldHaveCorrectJavascriptChannelName() throws {
    var sut = SoftAcceptConfiguration.Factory(environment: .production).make()
    XCTAssertEqual(sut.channelName, "javascriptChannelName")

    sut = SoftAcceptConfiguration.Factory(environment: .sandbox).make()
    XCTAssertEqual(sut.channelName, "javascriptChannelName")

    sut = SoftAcceptConfiguration.Factory(environment: .sandboxBeta).make()
    XCTAssertEqual(sut.channelName, "javascriptChannelName")
  }
}
