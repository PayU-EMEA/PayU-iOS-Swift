//
//  CVVAuthorizationRepositoryTests.swift
//  
//  Created by PayU S.A. on 14/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUAPI
@testable import PUWebPayments

final class CVVAuthorizationRepositoryTests: XCTestCase {

  private var networkClient: CVVAuthorizationNetworkClientProtocolMock!
  private var sut: CVVAuthorizationRepository!

  private var refReqId: String!
  private var cvv: String!

  override func setUp() {
    super.setUp()
    networkClient = mock(CVVAuthorizationNetworkClientProtocol.self)
    sut = CVVAuthorizationRepository(client: networkClient)

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

  func testShouldCompleteWithSuccessResultWhenNetworkClientCompleteWithSuccessResult() throws {
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
        .authorizeCVV(
          cvvAuthorizationRequest: any(CVVAuthorizationRequest.self),
          completionHandler: any()))
    .will { cvvAuthorizationRequest, completionHandler in
      completionHandler(.success(cvvAuthorizationResponse))
    }

    sut.authorizeCVV(
      cvvAuthorizationRequest: cvvAuthorizationRequest,
      completionHandler: { result in
        XCTAssertNotNil(try? result.get())
        switch result {
          case .success:
            expectationAuthorizeCVV.fulfill()
          default:
            break
        }
      }
    )

    verify(
      networkClient
        .authorizeCVV(
          cvvAuthorizationRequest: cvvAuthorizationRequest,
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
        .authorizeCVV(
          cvvAuthorizationRequest: any(CVVAuthorizationRequest.self),
          completionHandler: any()))
    .will { cvvAuthorizationRequest, completionHandler in
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
        .authorizeCVV(
          cvvAuthorizationRequest: cvvAuthorizationRequest,
          completionHandler: any()))
    .wasCalled()

    wait(for: [expectationAuthorizeCVV], timeout: 1)
  }
}
