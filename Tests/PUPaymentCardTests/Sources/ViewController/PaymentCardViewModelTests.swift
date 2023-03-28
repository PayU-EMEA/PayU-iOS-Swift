//
//  PaymentCardViewModelTests.swift
//  
//  Created by PayU S.A. on 15/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
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
          in: viewController))
    .wasCalled()
  }

  func testDidTapSaveAndUseShouldCallServiceToTokenizeWithAgreement() {
    sut.didTapSaveAndUse()

    verify(
      service
        .tokenize(
          agreement: true,
          completionHandler: any()))
    .wasCalled()
  }

  func testDidTapUseShouldCallServiceToTokenizeWithoutAgreement() {
    sut.didTapUse()
    
    verify(
      service
        .tokenize(
          agreement: false,
          completionHandler: any()))
    .wasCalled()
  }

}
