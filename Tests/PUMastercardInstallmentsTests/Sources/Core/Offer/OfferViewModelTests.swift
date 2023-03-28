//
//  OfferViewModelTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUMastercardInstallments

final class OfferViewModelTests: XCTestCase {

  private var delegate: OfferViewModelDelegateMock!
  private var proposal: InstallmentProposal!
  private var sut: OfferViewModel!

  override func setUp() {
    super.setUp()
    delegate = mock(OfferViewModelDelegate.self)
    proposal = decode(type: InstallmentProposal.self, from: "installment_proposal")
    sut = OfferViewModel(proposal: proposal)
    sut.delegate = delegate
  }

  override func tearDown() {
    super.tearDown()
    reset(delegate)
    proposal = nil
    sut = nil
  }

  func testShouldInformDelegateWhenDidTapSplitIntoInstallments() throws {
    sut.didTapSplitIntoInstallments()
    verify(delegate.offerViewModel(any(), shouldNavigateToOptions: proposal)).wasCalled()
  }

  func testShouldInformDelegateWhenDidTapNoCancel() throws {
    sut.didTapNoThanks()
    verify(delegate.offerViewModelDidCancel(any())).wasCalled()
  }

  func testShouldInformDelegateWhenDidSelectInstallmentResult() throws {
    let installmentOption = proposal.installmentOptions[2]
    let installmentResult = InstallmentResult.from(proposal: proposal, option: installmentOption)
    
    sut.didSelect(result: installmentResult)
    verify(delegate.offerViewModel(any(), didComplete: installmentResult)).wasCalled()
  }
}
