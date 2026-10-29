//
//  PaymentCardNetworkClientTests.swift
//

import XCTest

@testable import PUAPI
@testable import PUCore
@testable import PUPaymentCard

final class PaymentCardNetworkClientTests: XCTestCase {

  private var client: NetworkClientProtocolMock!
  private var sut: PaymentCardNetworkClient!

  override func setUp() {
    super.setUp()
    client = NetworkClientProtocolMock()
    sut = PaymentCardNetworkClient(client: client)
  }

  override func tearDown() {
    super.tearDown()
    client = nil
    sut = nil
  }

  func
    testTokenizeWhenClientCompletesWithSuccessAndDataThenShouldCompleteWithSuccess()
  {
    let expectation = XCTestExpectation()

    client.requestHandler = { _, _, completion in
      (completion as! (Result<TokenCreateResponse, Error>) -> Void)(.success(self.makeTokenCreateResponse()))
    }

    sut.tokenize(
      tokenCreateRequest: makeTokenCreateRequest(),
      completionHandler: { result in
        switch result {
        case .success(let response)
        where response == self.makeTokenCreateResponse():
          expectation.fulfill()
        default:
          break
        }
      }
    )

    wait(for: [expectation], timeout: 1)
  }

  func testTokenizeWhenClientCompletesWithFailureThenShouldCompleteWithFailure()
  {
    struct ErrorMock: Error {}

    let expectation = XCTestExpectation()

    client.requestHandler = { _, _, completion in
      (completion as! (Result<TokenCreateResponse, Error>) -> Void)(.failure(ErrorMock()))
    }

    sut.tokenize(
      tokenCreateRequest: makeTokenCreateRequest(),
      completionHandler: { result in
        switch result {
        case .failure:
          expectation.fulfill()
        default:
          break
        }
      }
    )

    wait(for: [expectation], timeout: 1)
  }
}

extension PaymentCardNetworkClientTests {
  fileprivate func makeTokenCreateRequest() -> TokenCreateRequest {
    TokenCreateRequest(
      posId: "453872304",
      type: TokenType.MULTI.rawValue,
      card: PaymentCard(
        number: "5405 8609 3727 0285",
        expirationMonth: "03",
        expirationYear: "2023",
        cvv: "827"
      )
    )
  }

  fileprivate func makeTokenCreateResponse() -> TokenCreateResponse {
    TokenCreateResponse(
      value: "TOKC_QPY10DEHHLWPOMJIV5LWUZHG2DG",
      maskedCard: "5405 **** **** 0285"
    )
  }

}
