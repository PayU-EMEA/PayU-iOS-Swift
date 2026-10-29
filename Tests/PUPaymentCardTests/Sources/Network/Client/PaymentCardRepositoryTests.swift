//
//  PaymentCardRepositoryTests.swift
//

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
    client = PaymentCardNetworkClientProtocolMock()
    finder = PaymentCardProviderFinderProtocolMock()
    sut = PaymentCardRepository(client: client, finder: finder)
  }

  override func tearDown() {
    super.tearDown()
    client = nil
    finder = nil
    sut = nil
  }

  func
    testTokenizeWhenClientCompletesWithSuccessWhenFinderCanFindPaymentCardProviderThenShouldCompleteWithSuccess()
  {
    let paymentCardProvider = PaymentCardProvider.mastercard
    let expectation = XCTestExpectation()

    client.tokenizeHandler = { tokenCreateRequest, completionHandler in
      completionHandler(.success(self.makeTokenCreateResponse()))
    }

    finder.findHandler = { _ in paymentCardProvider }

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

    XCTAssertGreaterThan(client.tokenizeCallCount, 0)
    XCTAssertEqual(
      client.tokenizeArgValues.last,
      makeTokenCreateRequest())

    XCTAssertGreaterThan(finder.findCallCount, 0)
    XCTAssertEqual(finder.findArgValues.last, makeTokenCreateRequest().card.number)

    wait(for: [expectation], timeout: 1)
  }

  func
    testTokenizeWhenClientCompletesWithSuccessWhenFinderCannotFindPaymentCardProviderThenShouldCompleteWithSuccess()
  {
    let paymentCardProvider: PaymentCardProvider? = nil
    let expectation = XCTestExpectation()

    client.tokenizeHandler = { tokenCreateRequest, completionHandler in
      completionHandler(.success(self.makeTokenCreateResponse()))
    }

    finder.findHandler = { _ in nil }

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

    XCTAssertGreaterThan(client.tokenizeCallCount, 0)
    XCTAssertEqual(
      client.tokenizeArgValues.last,
      makeTokenCreateRequest())

    XCTAssertGreaterThan(finder.findCallCount, 0)
    XCTAssertEqual(finder.findArgValues.last, makeTokenCreateRequest().card.number)

    wait(for: [expectation], timeout: 1)
  }

  func testTokenizeWhenClientCompletesWithFailureThenShouldCompleteWithFailure()
  {
    struct ErrorMock: Error {}

    let expectation = XCTestExpectation()

    client.tokenizeHandler = { tokenCreateRequest, completionHandler in
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

    XCTAssertGreaterThan(client.tokenizeCallCount, 0)
    XCTAssertEqual(
      client.tokenizeArgValues.last,
      makeTokenCreateRequest())

    XCTAssertEqual(finder.findCallCount, 0)

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
