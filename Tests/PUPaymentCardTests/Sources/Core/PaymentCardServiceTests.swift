//
//  PaymentCardServiceTests.swift
//

import XCTest

@testable import PUCore
@testable import PUPaymentCard
@testable import PUPaymentCardScanner
@testable import PUTheme

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
    delegate = PaymentCardServiceDelegateMock()
    cvvValidator = PaymentCardValidatorProtocolMock()
    dateValidator = PaymentCardValidatorProtocolMock()
    numberValidator = PaymentCardValidatorProtocolMock()
    finder = PaymentCardProviderFinderProtocolMock()
    presenter = PaymentCardServicePresenterProtocolMock()
    repository = PaymentCardRepositoryProtocolMock()

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
    delegate = nil
    cvvValidator = nil
    dateValidator = nil
    numberValidator = nil
    finder = nil
    presenter = nil
    repository = nil
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
    finder.possibleHandler = { _ in .mastercard }
    sut.didChangeNumber("5434 0210 1682 4014")
    XCTAssertEqual(sut.paymentCardProvider, .mastercard)

    finder.possibleHandler = { _ in .maestro }
    sut.didChangeNumber("5598 6148 1656 3766")
    XCTAssertEqual(sut.paymentCardProvider, .maestro)

    XCTAssertTrue(finder.possibleArgValues.contains("5434 0210 1682 4014"))
    XCTAssertTrue(finder.possibleArgValues.contains("5598 6148 1656 3766"))
    XCTAssertEqual(finder.findCallCount, 0)
  }

  func testDidChangeNumberShouldCallDelegateToUpdateCardProvider() throws {
    finder.possibleHandler = { _ in .mastercard }
    sut.didChangeNumber("5434 0210 1682 4014")
    XCTAssertGreaterThan(delegate.paymentCardServiceShouldUpdatePaymentCardProviderCallCount, 0)
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
    XCTAssertGreaterThan(delegate.paymentCardServiceShouldUpdateCallCount, 0)
  }

  func testTokenizeShouldCallDelegateToValidate() throws {
    sut.tokenize(agreement: true, completionHandler: { e in })
    XCTAssertGreaterThan(delegate.paymentCardServiceShouldValidateCallCount, 0)
  }

  func testDeprecatedTokenizeWhenCanValidateThenShouldCallRepositoryToTokenize()
    throws
  {
    sut.didChangeNumber("5434 0210 1682 4014")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    sut.tokenize(
      agreement: true,
      completionHandler: { e in })

    XCTAssertGreaterThan(repository.tokenizeCallCount, 0)
    XCTAssertEqual(
      repository.tokenizeArgValues.last,
      TokenCreateRequest(
        posId: pos,
        type: TokenType.MULTI.rawValue,
        card: PaymentCard(
          number: "5434021016824014",
          expirationMonth: "04",
          expirationYear: "2025",
          cvv: "274"
        )
      )
    )
  }

  func testTokenizeWhenCanValidateThenShouldCallRepositoryToTokenize() throws {
    sut.didChangeNumber("5434 0210 1682 4014")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    sut.tokenize(
      type: TokenType.MULTI,
      completionHandler: { e in })

    XCTAssertGreaterThan(repository.tokenizeCallCount, 0)
    XCTAssertEqual(
      repository.tokenizeArgValues.last,
      TokenCreateRequest(
        posId: pos,
        type: TokenType.MULTI.rawValue,
        card: PaymentCard(
          number: "5434021016824014",
          expirationMonth: "04",
          expirationYear: "2025",
          cvv: "274"
        )
      )
    )
  }

  func
    testDeprecatedTokenizeWithAgreementWhenCanValidateThenShouldCallRepositoryToTokenizeWithExpectedAgreement()
    throws
  {
    sut.didChangeNumber("5598 6148 1656 3766")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    sut.tokenize(
      agreement: true,
      completionHandler: { e in })

    XCTAssertGreaterThan(repository.tokenizeCallCount, 0)
    XCTAssertEqual(
      repository.tokenizeArgValues.last,
      TokenCreateRequest(
        posId: pos,
        type: TokenType.MULTI.rawValue,
        card: PaymentCard(
          number: "5598614816563766",
          expirationMonth: "04",
          expirationYear: "2025",
          cvv: "274"
        )
      )
    )
  }

  func
    testTokenizeWithAgreementWhenCanValidateThenShouldCallRepositoryToTokenizeWithExpectedAgreement()
    throws
  {
    sut.didChangeNumber("5598 6148 1656 3766")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    sut.tokenize(
      type: TokenType.MULTI,
      completionHandler: { e in })

    XCTAssertGreaterThan(repository.tokenizeCallCount, 0)
    XCTAssertEqual(
      repository.tokenizeArgValues.last,
      TokenCreateRequest(
        posId: pos,
        type: TokenType.MULTI.rawValue,
        card: PaymentCard(
          number: "5598614816563766",
          expirationMonth: "04",
          expirationYear: "2025",
          cvv: "274"
        )
      )
    )
  }

  func
    testDeprecatedTokenizeWithoutAgreementWhenCanValidateThenShouldCallRepositoryToTokenizeWithExpectedAgreement()
    throws
  {
    sut.didChangeNumber("5598 6148 1656 3766")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    sut.tokenize(
      agreement: false,
      completionHandler: { e in })

    XCTAssertGreaterThan(repository.tokenizeCallCount, 0)
    XCTAssertEqual(
      repository.tokenizeArgValues.last,
      TokenCreateRequest(
        posId: pos,
        type: TokenType.SINGLE_LONGTERM.rawValue,
        card: PaymentCard(
          number: "5598614816563766",
          expirationMonth: "04",
          expirationYear: "2025",
          cvv: "274"
        )
      )
    )
  }

  func
    testTokenizeWithoutAgreementWhenCanValidateThenShouldCallRepositoryToTokenizeWithExpectedAgreement()
    throws
  {
    sut.didChangeNumber("5598 6148 1656 3766")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    sut.tokenize(
      type: TokenType.SINGLE_LONGTERM,
      completionHandler: { e in })

    XCTAssertGreaterThan(repository.tokenizeCallCount, 0)
    XCTAssertEqual(
      repository.tokenizeArgValues.last,
      TokenCreateRequest(
        posId: pos,
        type: TokenType.SINGLE_LONGTERM.rawValue,
        card: PaymentCard(
          number: "5598614816563766",
          expirationMonth: "04",
          expirationYear: "2025",
          cvv: "274"
        )
      )
    )
  }
  func
    testTokenizeWhenCanValidateWhenRepositoryCompleteWithSuccessThenShouldCompleteWithSuccess()
    throws
  {
    sut.didChangeNumber("5598 6148 1656 3766")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    let expectationTokenize = XCTestExpectation(
      description: "expectationTokenize")

    repository.tokenizeHandler = { tokenCreateRequest, completionHandler in
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

  func
    testTokenizeWhenCanValidateWhenRepositoryCompleteWithFailureThenShouldCompleteWithFailure()
    throws
  {
    struct ErrorMock: Error {}

    sut.didChangeNumber("5598 6148 1656 3766")
    sut.didChangeDate("04/2025")
    sut.didChangeCVV("274")

    let expectationTokenize = XCTestExpectation(
      description: "expectationTokenize")

    repository.tokenizeHandler = { tokenCreateRequest, completionHandler in
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

  func testDeprecatedTokenizeWhenCannotValidateThenShouldNotCallRepository()
    throws
  {
    struct ErrorMock: Error {}

    delegate.paymentCardServiceShouldValidateHandler = { _ in throw ErrorMock() }

    sut.tokenize(
      agreement: true,
      completionHandler: { e in })

    XCTAssertEqual(repository.tokenizeCallCount, 0)
  }

  func testTokenizeWhenCannotValidateThenShouldNotCallRepository() throws {
    struct ErrorMock: Error {}

    delegate.paymentCardServiceShouldValidateHandler = { _ in throw ErrorMock() }

    sut.tokenize(
      type: TokenType.MULTI,
      completionHandler: { e in })

    XCTAssertEqual(repository.tokenizeCallCount, 0)
  }

  func testScanWithNumberOptionShouldCallRepositoryWithTheSameOption() throws {
    sut.scan(option: .number, in: UIViewController())
    XCTAssertGreaterThan(presenter.presentPaymentCardScannerViewControllerCallCount, 0)
    XCTAssertEqual(
      presenter.presentPaymentCardScannerViewControllerArgValues.last?.option,
      .number)
  }

  func testScanWithNumberAndDateOptionShouldCallRepositoryWithTheSameOption()
    throws
  {
    sut.scan(option: .numberAndDate, in: UIViewController())
    XCTAssertGreaterThan(presenter.presentPaymentCardScannerViewControllerCallCount, 0)
    XCTAssertEqual(
      presenter.presentPaymentCardScannerViewControllerArgValues.last?.option,
      .numberAndDate)
  }

  func testScanWhenPresenterCompletesWithResultThenShouldUpdateData() throws {
    presenter.presentPaymentCardScannerViewControllerHandler = {
      option, presentingViewController, onComplete in
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

  func testScanWhenPresenterCompletesWithResultThenShouldCallDelegateToUpdate()
    throws
  {
    presenter.presentPaymentCardScannerViewControllerHandler = {
      option, presentingViewController, onComplete in
      onComplete(
        PaymentCardScannerResult(
          option: .number,
          cardNumber: "5598 6148 1656 3766",
          cardExpirationDate: "04/2025"
        )
      )
    }

    sut.scan(option: .numberAndDate, in: UIViewController())

    XCTAssertGreaterThan(delegate.paymentCardServiceShouldUpdateCallCount, 0)
  }
}
