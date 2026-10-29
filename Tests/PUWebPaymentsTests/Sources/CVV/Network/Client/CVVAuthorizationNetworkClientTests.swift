//
//  CVVAuthorizationNetworkClientTests.swift
//

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
    networkClient = NetworkClientProtocolMock()
    sut = CVVAuthorizationNetworkClient(client: networkClient)

    refReqId = UUID().uuidString
    cvv = UUID().uuidString
  }

  override func tearDown() {
    super.tearDown()
    networkClient = nil
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

    networkClient.requestHandler = { _, _, completion in
      (completion as! (Result<EmptyResponse, Error>) -> Void)(.success(cvvAuthorizationResponse))
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

    XCTAssertGreaterThan(networkClient.requestCallCount, 0)
    XCTAssertTrue(networkClient.requestArgValues.last?.target is CVVAuthorizationNetworkTarget)
    XCTAssertTrue(networkClient.requestArgValues.last?.type is EmptyResponse.Type)

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

    networkClient.requestHandler = { _, _, completion in
      (completion as! (Result<EmptyResponse, Error>) -> Void)(.failure(ErrorMock()))
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

    XCTAssertGreaterThan(networkClient.requestCallCount, 0)
    XCTAssertTrue(networkClient.requestArgValues.last?.target is CVVAuthorizationNetworkTarget)
    XCTAssertTrue(networkClient.requestArgValues.last?.type is EmptyResponse.Type)

    wait(for: [expectationAuthorizeCVV], timeout: 1)
  }
}
