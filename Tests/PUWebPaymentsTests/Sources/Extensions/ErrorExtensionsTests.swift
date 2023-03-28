//
//  ErrorExtensionsTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUWebPayments

final class ErrorExtensionsTests: XCTestCase {

  func testIsSSLReturnsCorrectValue() throws {
    XCTAssertEqual(NSError(domain: "domain", code: NSURLErrorSecureConnectionFailed).isSSL, true)
    XCTAssertEqual(NSError(domain: "domain", code: NSURLErrorServerCertificateHasBadDate).isSSL, true)
    XCTAssertEqual(NSError(domain: "domain", code: NSURLErrorServerCertificateUntrusted).isSSL, true)
    XCTAssertEqual(NSError(domain: "domain", code: NSURLErrorServerCertificateHasUnknownRoot).isSSL, true)
    XCTAssertEqual(NSError(domain: "domain", code: NSURLErrorServerCertificateNotYetValid).isSSL, true)
    XCTAssertEqual(NSError(domain: "domain", code: NSURLErrorClientCertificateRejected).isSSL, true)
    XCTAssertEqual(NSError(domain: "domain", code: NSURLErrorClientCertificateRequired).isSSL, true)
  }

}
