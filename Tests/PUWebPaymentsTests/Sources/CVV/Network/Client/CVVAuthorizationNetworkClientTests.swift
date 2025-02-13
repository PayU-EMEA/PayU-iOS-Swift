//
//  CVVAuthorizationNetworkClientTests.swift
//

import Mockingbird
import XCTest

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

  func testShouldCompleteWithSuccessResultWhenNetworkClientCompleteWithSuccess()
    throws
  {
    let cvvAuthorizationRequest = CVVAuthorizationRequest(
      cvv: cvv,
      refReqId: refReqId
    )

    let cvvAuthorizationResponse = EmptyResponse()

    let expectationAuthorizeCVV = XCTestExpectation(
      description: "expectationAuthorizeCVV"
    )

    given(
      networkClient
        .request(
          target: any(CVVAuthorizationNetworkTarget.self),
          type: any(type(of: EmptyResponse.self)),
          completionHandler: any())
    )
    .will { target, type, completionHandler in
      completionHandler(.success(cvvAuthorizationResponse))
    }

    sut.authorizeCVV(
      cvvAuthorizationRequest: cvvAuthorizationRequest,
      completionHandler: { result in
        XCTAssertNotNil(try? result.get())
        switch result {
        case .success(_):
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
          type: any(type(of: EmptyResponse.self)),
          completionHandler: any())
    )
    .wasCalled()

    wait(for: [expectationAuthorizeCVV], timeout: 1)
  }

  func testShouldCompleteWithFailureResultWhenNetworkClientCompleteWithFailure()
    throws
  {
    struct ErrorMock: Error {}

    let cvvAuthorizationRequest = CVVAuthorizationRequest(
      cvv: cvv,
      refReqId: refReqId
    )

    let expectationAuthorizeCVV = XCTestExpectation(
      description: "expectationAuthorizeCVV"
    )

    given(
      networkClient
        .request(
          target: any(CVVAuthorizationNetworkTarget.self),
          type: any(type(of: EmptyResponse.self)),
          completionHandler: any())
    )
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
          type: any(type(of: EmptyResponse.self)),
          completionHandler: any())
    )
    .wasCalled()

    wait(for: [expectationAuthorizeCVV], timeout: 1)
  }
}
