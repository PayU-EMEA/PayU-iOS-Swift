//
//  CVVAuthorizationNetworkClientTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUAPI
@testable import PUWebPayments

final class CVVAuthorizationNetworkClientTests: XCTestCase {

  private var networkClient: NetworkClientProtocolMock!
  private var sut: CVVAuthorizationNetworkClient!

  private var refReqId: String!
  private var cvv: String!

  override func setUp() {
    super.setUp()
    networkClient = mock(NetworkClientProtocol.self)
    sut = CVVAuthorizationNetworkClient(client: networkClient)

    refReqId = UUID().uuidString
    cvv = UUID().uuidString
  }

  override func tearDown() {
    super.tearDown()
    reset(networkClient)
    refReqId = nil
    cvv = nil
    sut = nil
  }

  func testShouldCompleteWithSuccessResultWhenNetworkClientCompleteWithSuccessResultAndSuccessStatus() throws {
    let cvvAuthorizationRequest = CVVAuthorizationRequest(
      data: CVVAuthorizationRequest.Data(
        refReqId: refReqId,
        cvv: cvv
      )
    )

    let cvvAuthorizationResponse = CVVAuthorizationResponse(
      status: NetworkClientStatus(
        statusCode: NetworkClientStatus.StatusCode.success,
        codeLiteral: "codeLiteral",
        code: "code"
      )
    )

    let expectationAuthorizeCVV = XCTestExpectation(description: "expectationAuthorizeCVV")

    given(
      networkClient
        .request(
          target: any(CVVAuthorizationNetworkTarget.self),
          type: any(type(of: CVVAuthorizationResponse.self)),
          completionHandler: any()))
    .will { target, type, completionHandler in
      completionHandler(.success(cvvAuthorizationResponse))
    }

    sut.authorizeCVV(
      cvvAuthorizationRequest: cvvAuthorizationRequest,
      completionHandler: { result in
        XCTAssertNotNil(try? result.get())
        switch result {
          case .success(let response) where response.status.statusCode == NetworkClientStatus.StatusCode.success:
            expectationAuthorizeCVV.fulfill()
          default:
            break
        }
      }
    )

    verify(
      networkClient
        .request(
          target: any(CVVAuthorizationNetworkTarget.self),
          type: any(type(of: CVVAuthorizationResponse.self)),
          completionHandler: any()))
    .wasCalled()

    wait(for: [expectationAuthorizeCVV], timeout: 1)
  }

  func testShouldCompleteWithFailureResultWhenNetworkClientCompleteWithSuccessResultAndOtherStatus() throws {
    let cvvAuthorizationRequest = CVVAuthorizationRequest(
      data: CVVAuthorizationRequest.Data(
        refReqId: refReqId,
        cvv: cvv
      )
    )

    let cvvAuthorizationResponse = CVVAuthorizationResponse(
      status: NetworkClientStatus(
        statusCode: "statusCode",
        codeLiteral: "codeLiteral",
        code: "code"
      )
    )

    let expectationAuthorizeCVV = XCTestExpectation(description: "expectationAuthorizeCVV")

    given(
      networkClient
        .request(
          target: any(CVVAuthorizationNetworkTarget.self),
          type: any(type(of: CVVAuthorizationResponse.self)),
          completionHandler: any()))
    .will { target, type, completionHandler in
      completionHandler(.success(cvvAuthorizationResponse))
    }

    sut.authorizeCVV(
      cvvAuthorizationRequest: cvvAuthorizationRequest,
      completionHandler: { result in
        XCTAssertNil(try? result.get())
        switch result {
          case .failure:
            expectationAuthorizeCVV.fulfill()
          default:
            break
        }
      }
    )

    verify(
      networkClient
        .request(
          target: any(CVVAuthorizationNetworkTarget.self),
          type: any(type(of: CVVAuthorizationResponse.self)),
          completionHandler: any()))
    .wasCalled()

    wait(for: [expectationAuthorizeCVV], timeout: 1)
  }

  func testShouldCompleteWithFailureResultWhenNetworkClientCompleteWithFailureResult() throws {
    struct ErrorMock: Error {  }

    let cvvAuthorizationRequest = CVVAuthorizationRequest(
      data: CVVAuthorizationRequest.Data(
        refReqId: refReqId,
        cvv: cvv
      )
    )

    let expectationAuthorizeCVV = XCTestExpectation(description: "expectationAuthorizeCVV")

    given(
      networkClient
        .request(
          target: any(CVVAuthorizationNetworkTarget.self),
          type: any(type(of: CVVAuthorizationResponse.self)),
          completionHandler: any()))
    .will { target, type, completionHandler in
      completionHandler(.failure(ErrorMock()))
    }

    sut.authorizeCVV(
      cvvAuthorizationRequest: cvvAuthorizationRequest,
      completionHandler: { result in
        XCTAssertNil(try? result.get())
        switch result {
          case .failure:
            expectationAuthorizeCVV.fulfill()
          default:
            break
        }
      }
    )

    verify(
      networkClient
        .request(
          target: any(CVVAuthorizationNetworkTarget.self),
          type: any(type(of: CVVAuthorizationResponse.self)),
          completionHandler: any()))
    .wasCalled()

    wait(for: [expectationAuthorizeCVV], timeout: 1)
  }
}
