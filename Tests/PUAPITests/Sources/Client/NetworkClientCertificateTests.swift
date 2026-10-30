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

  func testShouldHaveDigicertGlobalRootCACertificate() throws {
    XCTAssertTrue(sut.contains(where: { $0.name == "digicert-global-root-ca" }))
  }

  func testShouldHaveDigicertTLSECCP384RootG5Certificate() throws {
    XCTAssertTrue(sut.contains(where: { $0.name == "digicert-tls-ecc-p384-root-g5" }))
  }

  func testShouldHaveDigicertTLSRSA4096RootG5Certificate() throws {
    XCTAssertTrue(sut.contains(where: { $0.name == "digicert-tls-rsa4096-root-g5" }))
  }

  func testShouldHaveDigicertCertificate() throws {
    XCTAssertTrue(sut.contains(where: { $0.name == "digicert-global-root-g2" }))
  }

  func testShouldHaveDigicertG3Certificate() throws {
    XCTAssertTrue(sut.contains(where: { $0.name == "digicert-global-root-g3" }))
  }

  func testShouldHaveSectigoCertificate() throws {
    XCTAssertTrue(sut.contains(where: { $0.name == "sectigo-R46" }))
  }

  func testShouldHaveRootCertificate() throws {
    XCTAssertTrue(sut.contains(where: { $0.name == "payu-root-ca-01" }))
  }
}

