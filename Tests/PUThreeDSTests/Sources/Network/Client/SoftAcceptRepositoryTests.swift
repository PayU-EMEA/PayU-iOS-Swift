//
//  SoftAcceptRepositoryTests.swift
//  
//  Created by PayU S.A. on 10/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUAPI
@testable import PUThreeDS

final class SoftAcceptRepositoryTests: XCTestCase {

  private var networkClient: NetworkClientProtocolMock!
  private var sut: SoftAcceptRepository!

  override func setUp() {
    super.setUp()
    self.networkClient = mock(NetworkClientProtocol.self)
    self.sut = SoftAcceptRepository(client: networkClient)
  }

  override func tearDown() {
    super.tearDown()
    reset(networkClient)
    sut = nil
  }

  func testShouldCompleteWithSuccessResultWhenNetworkClientCompleteWithSuccessResult() {
    let log = SoftAcceptLog(id: ".id", message: ".message")
    let expectationCreate = XCTestExpectation(description: "expectationCreate")

    given(
      networkClient
        .request(
          target: any(SoftAcceptNetworkTarget.self),
          type: any(SoftAcceptResponse.Type.self),
          completionHandler: any()))
    .will { target, type, completionHandler in
      completionHandler(.success(SoftAcceptResponse()))
    }

    sut.create(log: log) { result in
      XCTAssertNotNil(try? result.get())
      expectationCreate.fulfill()
    }

    verify(
      networkClient
        .request(
          target: any(SoftAcceptNetworkTarget.self),
          type: SoftAcceptResponse.self,
          completionHandler: any()))
    .wasCalled()

    wait(for: [expectationCreate], timeout: 1)
  }

  func testShouldCompleteWithFailureResultWhenNetworkClientCompleteWithFailureResult() {
    struct ErrorMock: Error {  }

    let log = SoftAcceptLog(id: ".id", message: ".message")
    let expectationCreate = XCTestExpectation(description: "expectationCreate")

    given(
      networkClient
        .request(
          target: any(SoftAcceptNetworkTarget.self),
          type: any(SoftAcceptResponse.Type.self),
          completionHandler: any()))
    .will { target, type, completionHandler in
      completionHandler(.failure(ErrorMock()))
    }

    sut.create(log: log) { result in
      XCTAssertNil(try? result.get())
      expectationCreate.fulfill()
    }

    verify(
      networkClient
        .request(
          target: any(SoftAcceptNetworkTarget.self),
          type: SoftAcceptResponse.self,
          completionHandler: any()))
    .wasCalled()

    wait(for: [expectationCreate], timeout: 1)
  }
}
