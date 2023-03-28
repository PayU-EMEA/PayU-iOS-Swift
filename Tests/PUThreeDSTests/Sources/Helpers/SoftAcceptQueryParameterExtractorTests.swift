//
//  SoftAcceptQueryParameterExtractorTests.swift
//  
//  Created by PayU S.A. on 10/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUThreeDS

final class SoftAcceptQueryParameterExtractorTests: XCTestCase {
  func testShouldExtractAuthenticationIdWhenUrlIsCorrent() throws {
    let sut = SoftAcceptQueryParameterExtractor()
    let authenticationId = "GH529b!0DLXy"
    let url = URL(string: "https://www.payu.com?authenticationId=\(authenticationId)")!
    let result = sut.extractAuthenticationId(url)
    XCTAssertEqual(result, authenticationId)
  }

  func testShouldNotExtractAuthenticationIdWhenUrlIsNotCorrect() throws {
    let sut = SoftAcceptQueryParameterExtractor()
    let authenticationId = "GH529b!0DLXy"
    let url = URL(string: "https://www.payu.com?uthenticationId=\(authenticationId)")!
    let result = sut.extractAuthenticationId(url)
    XCTAssertNil(result)
  }

  func testShouldExtractQueryParameterWhenExists() throws {
    let sut = SoftAcceptQueryParameterExtractor()
    let queryParameterName = "queryParameterName"
    let queryParameterValue = "queryParameterValue"
    let url = URL(string: "https://www.payu.com?\(queryParameterName)=\(queryParameterValue)")!
    let result = sut.extractQueryParameter(url, queryParameterName)
    XCTAssertEqual(result, queryParameterValue)
  }

  func testShouldNotExtractQueryParameterWhenDoesNotExist() throws {
    let sut = SoftAcceptQueryParameterExtractor()
    let queryParameterName = "queryParameterName"
    let queryParameterValue = "queryParameterValue"
    let url = URL(string: "https://www.payu.com?ueryParameterName=\(queryParameterValue)")!
    let result = sut.extractQueryParameter(url, queryParameterName)
    XCTAssertNil(result)
  }
}

