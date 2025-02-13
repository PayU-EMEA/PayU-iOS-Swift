//
//  PaymentCardRepositoryTests.swift
//

import Mockingbird
import XCTest

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

  func
    testTokenizeWhenClientCompletesWithSuccessWhenFinderCanFindPaymentCardProviderThenShouldCompleteWithSuccess()
  {
    let paymentCardProvider = PaymentCardProvider.mastercard
    let expectation = XCTestExpectation()

    given(
      client
        .tokenize(
          tokenCreateRequest: any(),
          completionHandler: any())
    )
    .will { tokenCreateRequest, completionHandler in
      completionHandler(.success(self.makeTokenCreateResponse()))
    }

    given(
      finder.find(any())
    )
    .willReturn(paymentCardProvider)

    sut.tokenize(
      tokenCreateRequest: makeTokenCreateRequest(),
      completionHandler: { result in
        switch result {
        case .success(let cardToken)
        where cardToken == self.makeCardToken(paymentCardProvider):
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
          completionHandler: any())
    )
    .wasCalled()

    verify(
      finder.find(
        makeTokenCreateRequest().card.number)
    )
    .wasCalled()

    wait(for: [expectation], timeout: 1)
  }

  func
    testTokenizeWhenClientCompletesWithSuccessWhenFinderCannotFindPaymentCardProviderThenShouldCompleteWithSuccess()
  {
    let paymentCardProvider: PaymentCardProvider? = nil
    let expectation = XCTestExpectation()

    given(
      client
        .tokenize(
          tokenCreateRequest: any(),
          completionHandler: any())
    )
    .will { tokenCreateRequest, completionHandler in
      completionHandler(.success(self.makeTokenCreateResponse()))
    }

    given(
      finder.find(any())
    )
    .willReturn(nil)

    sut.tokenize(
      tokenCreateRequest: makeTokenCreateRequest(),
      completionHandler: { result in
        switch result {
        case .success(let cardToken)
        where cardToken == self.makeCardToken(paymentCardProvider):
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
          completionHandler: any())
    )
    .wasCalled()

    verify(
      finder.find(
        makeTokenCreateRequest().card.number)
    )
    .wasCalled()

    wait(for: [expectation], timeout: 1)
  }

  func testTokenizeWhenClientCompletesWithFailureThenShouldCompleteWithFailure()
  {
    struct ErrorMock: Error {}

    let expectation = XCTestExpectation()

    given(
      client
        .tokenize(
          tokenCreateRequest: any(),
          completionHandler: any())
    )
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
          completionHandler: any())
    )
    .wasCalled()

    verify(
      finder.find(any())
    )
    .wasNeverCalled()

    wait(for: [expectation], timeout: 1)
  }

}

extension PaymentCardRepositoryTests {
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

  fileprivate func makeCardToken(_ paymentCardProvider: PaymentCardProvider?)
    -> CardToken
  {
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
