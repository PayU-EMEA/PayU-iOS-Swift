//
//  PaymentCardServiceTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUCore
@testable import PUTheme
@testable import PUPaymentCard
@testable import PUPaymentCardScanner

final class PaymentCardServiceTests: XCTestCase {

  private var delegate: PaymentCardServiceDelegateMock!
  private var cvvValidator: PaymentCardValidatorProtocolMock!
  private var dateValidator: PaymentCardValidatorProtocolMock!
  private var numberValidator: PaymentCardValidatorProtocolMock!
  private var finder: PaymentCardProviderFinderProtocolMock!
  private var presenter: PaymentCardServicePresenterProtocolMock!
  private var repository: PaymentCardRepositoryProtocolMock!

  private var sut: PaymentCardService!

  private let pos = "82394724"

  override func setUp() {
    super.setUp()
    delegate = mock(PaymentCardServiceDelegate.self)
    cvvValidator = mock(PaymentCardValidatorProtocol.self)
    dateValidator = mock(PaymentCardValidatorProtocol.self)
    numberValidator = mock(PaymentCardValidatorProtocol.self)
    finder = mock(PaymentCardProviderFinderProtocol.self)
    presenter = mock(PaymentCardServicePresenterProtocol.self)
    repository = mock(PaymentCardRepositoryProtocol.self)

    sut = PaymentCardService(
      cvvValidator: cvvValidator,
      dateValidator: dateValidator,
      numberValidator: numberValidator,
      finder: finder,
      presenter: presenter,
      repository: repository
    )

    sut.delegate = delegate

    PayU.pos = POS(id: pos, environment: .sandbox)
  }

  override func tearDown() {
    super.tearDown()
    reset(delegate)
    reset(cvvValidator)
    reset(dateValidator)
    reset(numberValidator)
    reset(finder)
    reset(presenter)
    reset(repository)
    sut = nil
  }

  func testPaymentCardIsNilAfterBeingInitilized() throws {
    XCTAssertNil(sut.paymentCardProvider)
  }

  func testCVVIsEmptyAfterBeingInitilized() throws {
    XCTAssertEqual(sut.cvv, "")
  }

  func testDateIsEmptyAfterBeingInitilized() throws {
    XCTAssertEqual(sut.date, "")
  }

  func testNumberIsEmptyAfterBeingInitilized() throws {
    XCTAssertEqual(sut.number, "")
  }

  func testDidChangeCVVShouldChangeCVV() throws {
    sut.didChangeCVV("123")
    XCTAssertEqual(sut.cvv, "123")

    sut.didChangeCVV("456")
    XCTAssertEqual(sut.cvv, "456")
  }

  func testDidChangeDateShouldChangeDate() throws {
    sut.didChangeDate("03/23")
    XCTAssertEqual(sut.date, "03/23")

    sut.didChangeDate("04/2025")
    XCTAssertEqual(sut.date, "04/2025")
  }

  func testDidChangeNumberShouldChangeNumber() throws {
    sut.didChangeNumber("5434 0210 1682 4014")
    XCTAssertEqual(sut.number, "5434 0210 1682 4014")

    sut.didChangeNumber("5598 6148 1656 3766")
    XCTAssertEqual(sut.number, "5598 6148 1656 3766")
  }

  func testDidChangeNumberShouldSetProviderIfCardNumberIsCorrect() throws {
    given(finder.possible(any())).willReturn(.mastercard)
    sut.didChangeNumber("5434 0210 1682 4014")
    XCTAssertEqual(sut.paymentCardProvider, .mastercard)

    given(finder.possible(any())).willReturn(.maestro)
    sut.didChangeNumber("5598 6148 1656 3766")
    XCTAssertEqual(sut.paymentCardProvider, .maestro)

    verify(finder.possible("5434 0210 1682 4014")).wasCalled()
    verify(finder.possible("5598 6148 1656 3766")).wasCalled()
    verify(finder.find(any())).wasNeverCalled()
  }

  func testDidChangeNumberShouldCallDelegateToUpdateCardProvider() throws {
    given(finder.possible(any())).willReturn(.mastercard)
    sut.didChangeNumber("5434 0210 1682 4014")
    verify(delegate.paymentCardServiceShouldUpdatePaymentCardProvider(any())).wasCalled()
  }

  func testDidChangePaymentCardShouldChangePaymentCard() throws {
    sut.didChangePaymentCard(
      PaymentCard(
        number: "5434 0210 1682 4014",
        expirationMonth: "03",
        expirationYear: "23",
        cvv: "123")
    )

    XCTAssertEqual(sut.cvv, "123")
    XCTAssertEqual(sut.date, "03/23")
    XCTAssertEqual(sut.number, "5434 0210 1682 4014")

    sut.didChangePaymentCard(
      PaymentCard(
        number: "5598 6148 1656 3766",
        expirationMonth: "06",
        expirationYear: "25",
        cvv: "456")
    )

    XCTAssertEqual(sut.cvv, "456")
    XCTAssertEqual(sut.date, "06/25")
    XCTAssertEqual(sut.number, "5598 6148 1656 3766")
  }

  func testDidChangePaymentCardShouldCallDelegateToUpdate() throws {
    sut.didChangePaymentCard(
      PaymentCard(
        number: "5434 0210 1682 4014",
        expirationMonth: "03",
        expirationYear: "23",
        cvv: "123")
    )
    verify(delegate.paymentCardServiceShouldUpdate(any())).wasCalled()
  }

  func testTokenizeShouldCallDelegateToValidate() throws {
    sut.tokenize(agreement: true, completionHandler: { e in })
    verify(delegate.paymentCardServiceShouldValidate(any())).wasCalled()
  }

  func testTokenizeWhenCanValidateThenShouldCallRepositoryToTokenize() throws {
    sut.didChangeNumber("5434 0210 1682 4014")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    given(delegate.paymentCardServiceShouldValidate(any())).willReturn(())

    sut.tokenize(
      agreement: true,
      completionHandler: { e in })

    verify(
      repository
        .tokenize(
          tokenCreateRequest: TokenCreateRequest(
            sender: pos,
            data: TokenCreateRequest.Data(
              agreement: true,
              card: TokenCreateRequest.Data.Card(
                number: "5434021016824014",
                expirationMonth: "04",
                expirationYear: "2025",
                cvv: "274"
              )
            )
          ),
          completionHandler: any()))
    .wasCalled()
  }

  func testTokenizeWithAgreementWhenCanValidateThenShouldCallRepositoryToTokenizeWithExpectedAgreement() throws {
    sut.didChangeNumber("5598 6148 1656 3766")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    given(delegate.paymentCardServiceShouldValidate(any())).willReturn(())

    sut.tokenize(
      agreement: true,
      completionHandler: { e in })

    verify(
      repository
        .tokenize(
          tokenCreateRequest: TokenCreateRequest(
            sender: pos,
            data: TokenCreateRequest.Data(
              agreement: true,
              card: TokenCreateRequest.Data.Card(
                number: "5598614816563766",
                expirationMonth: "04",
                expirationYear: "2025",
                cvv: "274"
              )
            )
          ),
          completionHandler: any()))
    .wasCalled()
  }

  func testTokenizeWithoutAgreementWhenCanValidateThenShouldCallRepositoryToTokenizeWithExpectedAgreement() throws {
    sut.didChangeNumber("5598 6148 1656 3766")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    given(delegate.paymentCardServiceShouldValidate(any())).willReturn(())

    sut.tokenize(
      agreement: false,
      completionHandler: { e in })

    verify(
      repository
        .tokenize(
          tokenCreateRequest: TokenCreateRequest(
            sender: pos,
            data: TokenCreateRequest.Data(
              agreement: false,
              card: TokenCreateRequest.Data.Card(
                number: "5598614816563766",
                expirationMonth: "04",
                expirationYear: "2025",
                cvv: "274"
              )
            )
          ),
          completionHandler: any()))
    .wasCalled()
  }

  func testTokenizeWhenCanValidateWhenRepositoryCompleteWithSuccessThenShouldCompleteWithSuccess() throws {
    sut.didChangeNumber("5598 6148 1656 3766")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    let expectationTokenize = XCTestExpectation(description: "expectationTokenize")

    given(delegate.paymentCardServiceShouldValidate(any())).willReturn(())
    given(
      repository
        .tokenize(
          tokenCreateRequest: any(),
          completionHandler: any()))
    .will { tokenCreateRequest, completionHandler in
      completionHandler(
        .success(
          CardToken(
            brandImageUrl: "",
            cardExpirationMonth: 3,
            cardExpirationYear: 2023,
            cardNumberMasked: "5598 **** **** 3766",
            cardScheme: "MC",
            preferred: true,
            status: .active,
            value: "TOK_HHAJDKASJH897SDASD9LKH"
          )
        )
      )
    }

    sut.tokenize(
      agreement: true,
      completionHandler: { result in
        expectationTokenize.fulfill()
        let cardToken = try? result.get()
        XCTAssertEqual(cardToken?.value, "TOK_HHAJDKASJH897SDASD9LKH")
        XCTAssertNotNil(cardToken)
      }
    )

    wait(for: [expectationTokenize], timeout: 2)
  }

  func testTokenizeWhenCanValidateWhenRepositoryCompleteWithFailureThenShouldCompleteWithFailure() throws {
    struct ErrorMock: Error {  }

    sut.didChangeNumber("5598 6148 1656 3766")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    let expectationTokenize = XCTestExpectation(description: "expectationTokenize")

    given(delegate.paymentCardServiceShouldValidate(any())).willReturn(())
    given(
      repository
        .tokenize(
          tokenCreateRequest: any(),
          completionHandler: any()))
    .will { tokenCreateRequest, completionHandler in
      completionHandler(.failure(ErrorMock()))
    }

    sut.tokenize(
      agreement: true,
      completionHandler: { result in
        expectationTokenize.fulfill()
        XCTAssertNil(try? result.get())
      }
    )

    wait(for: [expectationTokenize], timeout: 2)
  }

  func testTokenizeWhenCannotValidateThenShouldNotCallRepository() throws {
    struct ErrorMock: Error {  }

    given(delegate.paymentCardServiceShouldValidate(any())).willThrow(ErrorMock())

    sut.tokenize(
      agreement: true,
      completionHandler: { e in })

    verify(
      repository
        .tokenize(
          tokenCreateRequest: any(),
          completionHandler: any()))
    .wasNeverCalled()
  }

  func testScanWithNumberOptionShouldCallRepositoryWithTheSameOption() throws {
    sut.scan(option: .number, in: UIViewController())
    verify(
      presenter
        .presentPaymentCardScannerViewController(
          option: .number,
          presentingViewController: any(),
          onComplete: any()))
    .wasCalled()
  }

  func testScanWithNumberAndDateOptionShouldCallRepositoryWithTheSameOption() throws {
    sut.scan(option: .numberAndDate, in: UIViewController())
    verify(
      presenter
        .presentPaymentCardScannerViewController(
          option: .numberAndDate,
          presentingViewController: any(),
          onComplete: any()))
    .wasCalled()
  }

  func testScanWhenPresenterCompletesWithResultThenShouldUpdateData() throws {
    given(
      presenter
        .presentPaymentCardScannerViewController(
          option: any(),
          presentingViewController: any(),
          onComplete: any()))
    .will { option, presentingViewController, onComplete in
      onComplete(
        PaymentCardScannerResult(
          option: .number,
          cardNumber: "5598 6148 1656 3766",
          cardExpirationDate: "04/2025"
        )
      )
    }

    sut.scan(option: .numberAndDate, in: UIViewController())

    XCTAssertEqual(sut.date, "04/2025")
    XCTAssertEqual(sut.number, "5598 6148 1656 3766")
  }

  func testScanWhenPresenterCompletesWithResultThenShouldCallDelegateToUpdate() throws {
    given(
      presenter
        .presentPaymentCardScannerViewController(
          option: any(),
          presentingViewController: any(),
          onComplete: any()))
    .will { option, presentingViewController, onComplete in
      onComplete(
        PaymentCardScannerResult(
          option: .number,
          cardNumber: "5598 6148 1656 3766",
          cardExpirationDate: "04/2025"
        )
      )
    }

    sut.scan(option: .numberAndDate, in: UIViewController())

    verify(delegate.paymentCardServiceShouldUpdate(any())).wasCalled()
  }
}
