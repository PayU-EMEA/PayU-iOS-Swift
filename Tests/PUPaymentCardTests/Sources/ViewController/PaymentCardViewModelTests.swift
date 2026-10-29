//
//  PaymentCardViewModelTests.swift
//

import XCTest

@testable import PUCore
@testable import PUPaymentCard

final class PaymentCardViewModelTests: XCTestCase {

  private var delegate: PaymentCardViewModelDelegateMock!
  private var service: PaymentCardServiceProtocolMock!
  private var sut: PaymentCardViewModel!

  override func setUp() {
    super.setUp()
    delegate = PaymentCardViewModelDelegateMock()
    service = PaymentCardServiceProtocolMock()
    sut = PaymentCardViewModel(service: service)
    sut.delegate = delegate
  }

  override func tearDown() {
    super.tearDown()
    delegate = nil
    service = nil
    sut = nil
  }

  func testDidTapScanCardShouldCallServiceToScanWithNumberAndDateOption() {
    let viewController = UIViewController()
    sut.didTapScanCard(in: viewController)

    XCTAssertGreaterThan(service.scanCallCount, 0)
    XCTAssertEqual(service.scanArgValues.last?.option, .numberAndDate)
    XCTAssertTrue(service.scanArgValues.last?.presentingViewController === viewController)
  }

  func testDidTapSaveAndUseShouldCallServiceToTokenizeWithAgreement() {
    sut.didTapSaveAndUse()

    XCTAssertGreaterThan(service.tokenizeTypeCallCount, 0)
    XCTAssertEqual(service.tokenizeTypeArgValues.last, TokenType.MULTI)
  }

  func testDidTapUseShouldCallServiceToTokenizeWithoutAgreementLongTerm() {
    sut.didTapUse(shortLifespandForUse: false)

    XCTAssertGreaterThan(service.tokenizeTypeCallCount, 0)
    XCTAssertEqual(service.tokenizeTypeArgValues.last, TokenType.SINGLE_LONGTERM)
  }

  func testDidTapUseShouldCallServiceToTokenizeWithoutAgreement() {
    sut.didTapUse(shortLifespandForUse: true)

    XCTAssertGreaterThan(service.tokenizeTypeCallCount, 0)
    XCTAssertEqual(service.tokenizeTypeArgValues.last, TokenType.SINGLE)
  }
}
