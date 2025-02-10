//
//  PaymentCardNetworkClientTests.swift
//

import Mockingbird
import XCTest

@testable import PUAPI
@testable import PUCore
@testable import PUPaymentCard

final class PaymentCardNetworkClientTests: XCTestCase {

  private var client: NetworkClientProtocolMock!
  private var sut: PaymentCardNetworkClient!

  override func setUp() {
    super.setUp()
    client = mock(NetworkClientProtocol.self)
    sut = PaymentCardNetworkClient(client: client)
  }

  override func tearDown() {
    super.tearDown()
    reset(client)
    sut = nil
  }

  func
    testTokenizeWhenClientCompletesWithSuccessAndDataThenShouldCompleteWithSuccess()
  {
    let expectation = XCTestExpectation()

    given(
      client
        .request(
          target: any(PaymentCardNetworkTarget.self),
          type: any(type(of: TokenCreateResponse.self)),
          completionHandler: any())
    )
    .will { target, type, completionHandler in
      completionHandler(.success(self.makeTokenCreateResponse()))
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

    given(
      client
        .request(
          target: any(PaymentCardNetworkTarget.self),
          type: any(type(of: TokenCreateResponse.self)),
          completionHandler: any())
    )
    .will { target, type, completionHandler in
      completionHandler(.failure(ErrorMock()))
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
