//
//  PaymentCardNetworkClientTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
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

  func testTokenizeWhenClientCompletesWithSuccessAndDataThenShouldCompleteWithSuccess() {
    let expectation = XCTestExpectation()

    given(
      client
      .request(
        target: any(PaymentCardNetworkTarget.self),
        type: any(type(of: TokenCreateResponse.self)),
        completionHandler: any()))
    .will { target, type, completionHandler in
      completionHandler(.success(self.makeTokenCreateResponseWithData()))
    }

    sut.tokenize(
      tokenCreateRequest: makeTokenCreateRequest(),
      completionHandler: { result in
        switch result {
          case .success(let response) where response == self.makeTokenCreateResponseWithData().data:
            expectation.fulfill()
          default:
            break
        }
      }
    )

    wait(for: [expectation], timeout: 1)
  }

  func testTokenizeWhenClientCompletesWithSuccessAndWitoutDataThenShouldCompleteWithFailure() {
    let expectation = XCTestExpectation()

    given(
      client
      .request(
        target: any(PaymentCardNetworkTarget.self),
        type: any(type(of: TokenCreateResponse.self)),
        completionHandler: any()))
    .will { target, type, completionHandler in
      completionHandler(.success(self.makeTokenCreateResponseWithoutData()))
    }

    sut.tokenize(
      tokenCreateRequest: makeTokenCreateRequest(),
      completionHandler: { result in
        switch result {
          case .failure(let error) where error is NetworkClientError:
            expectation.fulfill()
          default:
            break
        }
      }
    )

    wait(for: [expectation], timeout: 1)
  }

  func testTokenizeWhenClientCompletesWithFailureThenShouldCompleteWithFailure() {
    struct ErrorMock: Error { }

    let expectation = XCTestExpectation()

    given(
      client
      .request(
        target: any(PaymentCardNetworkTarget.self),
        type: any(type(of: TokenCreateResponse.self)),
        completionHandler: any()))
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

private extension PaymentCardNetworkClientTests {
  func makeTokenCreateRequest() -> TokenCreateRequest {
    TokenCreateRequest(
      sender: "453872304",
      data: TokenCreateRequest.Data(
        agreement: true,
        card: TokenCreateRequest.Data.Card(
          number: "5405 8609 3727 0285",
          expirationMonth: "03",
          expirationYear: "2023",
          cvv: "827"
        )
      )
    )
  }

  func makeTokenCreateResponseWithData() -> TokenCreateResponse {
    TokenCreateResponse(
      status: NetworkClientStatus(
        statusCode: NetworkClientStatus.StatusCode.success,
        codeLiteral: "codeLiteral",
        code: "code"
      ),
      data: TokenCreateResponse.Result(
        token: "TOKC_QPY10DEHHLWPOMJIV5LWUZHG2DG",
        mask: "5405 **** **** 0285",
        type: "MC"
      )
    )
  }

  func makeTokenCreateResponseWithoutData() -> TokenCreateResponse {
    TokenCreateResponse(
      status: NetworkClientStatus(
        statusCode: NetworkClientStatus.StatusCode.success,
        codeLiteral: "codeLiteral",
        code: "code"
      ),
      data: nil
    )
  }
}
