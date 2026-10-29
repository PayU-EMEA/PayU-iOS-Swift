//
//  SoftAcceptRepositoryTests.swift
//  
//  Created by PayU S.A. on 10/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUAPI
@testable import PUThreeDS

final class SoftAcceptRepositoryTests: XCTestCase {

  private var networkClient: NetworkClientProtocolMock!
  private var sut: SoftAcceptRepository!

  override func setUp() {
    super.setUp()
    self.networkClient = NetworkClientProtocolMock()
    self.sut = SoftAcceptRepository(client: networkClient)
  }

  override func tearDown() {
    super.tearDown()
    networkClient = nil
    sut = nil
  }

  func testShouldCompleteWithSuccessResultWhenNetworkClientCompleteWithSuccessResult() {
    let log = SoftAcceptLog(id: ".id", message: ".message")
    let expectationCreate = XCTestExpectation(description: "expectationCreate")

    networkClient.requestHandler = { _, _, completion in
      (completion as! (Result<SoftAcceptResponse, Error>) -> Void)(.success(SoftAcceptResponse()))
    }

    sut.create(log: log) { result in
      XCTAssertNotNil(try? result.get())
      expectationCreate.fulfill()
    }

    XCTAssertGreaterThan(networkClient.requestCallCount, 0)
    XCTAssertTrue(networkClient.requestArgValues.last?.target is SoftAcceptNetworkTarget)
    XCTAssertTrue(networkClient.requestArgValues.last?.type is SoftAcceptResponse.Type)

    wait(for: [expectationCreate], timeout: 1)
  }

  func testShouldCompleteWithFailureResultWhenNetworkClientCompleteWithFailureResult() {
    struct ErrorMock: Error {  }

    let log = SoftAcceptLog(id: ".id", message: ".message")
    let expectationCreate = XCTestExpectation(description: "expectationCreate")

    networkClient.requestHandler = { _, _, completion in
      (completion as! (Result<SoftAcceptResponse, Error>) -> Void)(.failure(ErrorMock()))
    }

    sut.create(log: log) { result in
      XCTAssertNil(try? result.get())
      expectationCreate.fulfill()
    }

    XCTAssertGreaterThan(networkClient.requestCallCount, 0)
    XCTAssertTrue(networkClient.requestArgValues.last?.target is SoftAcceptNetworkTarget)
    XCTAssertTrue(networkClient.requestArgValues.last?.type is SoftAcceptResponse.Type)

    wait(for: [expectationCreate], timeout: 1)
  }
}
