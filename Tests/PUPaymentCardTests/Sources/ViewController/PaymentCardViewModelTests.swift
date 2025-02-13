//
//  PaymentCardViewModelTests.swift
//

import Mockingbird
import XCTest

@testable import PUCore
@testable import PUPaymentCard

final class PaymentCardViewModelTests: XCTestCase {

  private var delegate: PaymentCardViewModelDelegateMock!
  private var service: PaymentCardServiceProtocolMock!
  private var sut: PaymentCardViewModel!

  override func setUp() {
    super.setUp()
    delegate = mock(PaymentCardViewModelDelegate.self)
    service = mock(PaymentCardServiceProtocol.self)
    sut = PaymentCardViewModel(service: service)
    sut.delegate = delegate
  }

  override func tearDown() {
    super.tearDown()
    reset(delegate)
    reset(service)
    sut = nil
  }

  func testDidTapScanCardShouldCallServiceToScanWithNumberAndDateOption() {
    let viewController = UIViewController()
    sut.didTapScanCard(in: viewController)

    verify(
      service
        .scan(
          option: .numberAndDate,
          in: viewController)
    )
    .wasCalled()
  }

  func testDidTapSaveAndUseShouldCallServiceToTokenizeWithAgreement() {
    sut.didTapSaveAndUse()

    verify(
      service
        .tokenize(
          type: TokenType.MULTI,
          completionHandler: any())
    )
    .wasCalled()
  }

  func testDidTapUseShouldCallServiceToTokenizeWithoutAgreementLongTerm() {
    sut.didTapUse(shortLifespandForUse: false)

    verify(
      service
        .tokenize(
          type: TokenType.SINGLE_LONGTERM,
          completionHandler: any())
    )
    .wasCalled()
  }

  func testDidTapUseShouldCallServiceToTokenizeWithoutAgreement() {
    sut.didTapUse(shortLifespandForUse: true)

    verify(
      service
        .tokenize(
          type: TokenType.SINGLE,
          completionHandler: any())
    )
    .wasCalled()
  }
}
