//
//  PaymentCardRepositoryTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUAPI
@testable import PUCore
@testable import PUPaymentCard

final class PaymentCardRepositoryTests: XCTestCase {

  private var client: PaymentCardNetworkClientProtocolMock!
  private var finder: PaymentCardProviderFinderProtocolMock!
  private var sut: PaymentCardRepository!

  override func setUp() {
    super.setUp()
    client = mock(PaymentCardNetworkClientProtocol.self)
    finder = mock(PaymentCardProviderFinderProtocol.self)
    sut = PaymentCardRepository(client: client, finder: finder)
  }

  override func tearDown() {
    super.tearDown()
    reset(client)
    reset(finder)
    sut = nil
  }

  func testTokenizeWhenClientCompletesWithSuccessWhenFinderCanFindPaymentCardProviderThenShouldCompleteWithSuccess() {
    let paymentCardProvider = PaymentCardProvider.mastercard
    let expectation = XCTestExpectation()

    given(
      client
        .tokenize(
          tokenCreateRequest: any(),
          completionHandler: any()))
    .will { tokenCreateRequest, completionHandler in
      completionHandler(.success(self.makeTokenCreateResponse().data!))
    }

    given(
      finder.find(any()))
    .willReturn(paymentCardProvider)

    sut.tokenize(
      tokenCreateRequest: makeTokenCreateRequest(),
      completionHandler: { result in
        switch result {
          case .success(let cardToken) where cardToken == self.makeCardToken(paymentCardProvider):
            expectation.fulfill()
          default:
            break
        }
      }
    )

    verify(
      client
        .tokenize(
          tokenCreateRequest: makeTokenCreateRequest(),
          completionHandler: any()))
    .wasCalled()

    verify(
      finder.find(
        makeTokenCreateRequest().data.card.number))
    .wasCalled()

    wait(for: [expectation], timeout: 1)
  }

  func testTokenizeWhenClientCompletesWithSuccessWhenFinderCannotFindPaymentCardProviderThenShouldCompleteWithSuccess() {
    let paymentCardProvider: PaymentCardProvider? = nil
    let expectation = XCTestExpectation()

    given(
      client
        .tokenize(
          tokenCreateRequest: any(),
          completionHandler: any()))
    .will { tokenCreateRequest, completionHandler in
      completionHandler(.success(self.makeTokenCreateResponse().data!))
    }

    given(
      finder.find(any()))
    .willReturn(nil)

    sut.tokenize(
      tokenCreateRequest: makeTokenCreateRequest(),
      completionHandler: { result in
        switch result {
          case .success(let cardToken) where cardToken == self.makeCardToken(paymentCardProvider):
            expectation.fulfill()
          default:
            break
        }
      }
    )

    verify(
      client
        .tokenize(
          tokenCreateRequest: makeTokenCreateRequest(),
          completionHandler: any()))
    .wasCalled()

    verify(
      finder.find(
        makeTokenCreateRequest().data.card.number))
    .wasCalled()

    wait(for: [expectation], timeout: 1)
  }

  func testTokenizeWhenClientCompletesWithFailureThenShouldCompleteWithFailure() {
    struct ErrorMock: Error {  }

    let expectation = XCTestExpectation()

    given(
      client
        .tokenize(
          tokenCreateRequest: any(),
          completionHandler: any()))
    .will { tokenCreateRequest, completionHandler in
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

    verify(
      client
        .tokenize(
          tokenCreateRequest: makeTokenCreateRequest(),
          completionHandler: any()))
    .wasCalled()

    verify(
      finder.find(any()))
    .wasNeverCalled()

    wait(for: [expectation], timeout: 1)
  }
  
}

private extension PaymentCardRepositoryTests {
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

  func makeTokenCreateResponse() -> TokenCreateResponse {
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

  func makeCardToken(_ paymentCardProvider: PaymentCardProvider?) -> CardToken {
    CardToken(
      brandImageUrl: paymentCardProvider?.brandImageProvider.url ?? "",
      cardExpirationMonth: 3,
      cardExpirationYear: 2023,
      cardNumberMasked: "5405 **** **** 0285",
      cardScheme: paymentCardProvider?.scheme,
      preferred: false,
      status: CardToken.Status.active,
      value: "TOKC_QPY10DEHHLWPOMJIV5LWUZHG2DG"
    )
  }
}
