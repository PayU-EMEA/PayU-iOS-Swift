//
//  NetworkClientCertificateTests.swift
//
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUAPI

final class NetworkClientCertificateTests: XCTestCase {

  private var sut: [NetworkClientCertificate]!

  override func setUp() {
    super.setUp()
    sut = NetworkClientCertificate.certificates()
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testShouldHaveDigicertCertificate() throws {
    XCTAssertTrue(sut.contains(where: { $0.name == "digicert-g2-tls-eu-rsa4096-sha384-2022-ca1" }))
  }

  func testShouldHaveSectigoCertificate() throws {
    XCTAssertTrue(sut.contains(where: { $0.name == "sectigo-R46" }))
  }

  func testShouldHaveRootCertificate() throws {
    XCTAssertTrue(sut.contains(where: { $0.name == "payu-root-ca-01" }))
  }
}

