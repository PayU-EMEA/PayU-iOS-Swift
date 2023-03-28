//
//  OptionsViewModelTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
import Mockingbird
@testable import PUMastercardInstallments

final class OptionsViewModelTests: XCTestCase {

  private var delegate: OptionsViewModelDelegateMock!
  private var percentFormatter: NumberFormatter!
  private var priceFormatter: NumberFormatter!
  private var factory: OptionsFactoryProtocol!
  private var proposal: InstallmentProposal!
  private var sut: OptionsViewModel!

  override func setUp() {
    super.setUp()
    delegate = mock(OptionsViewModelDelegate.self)
    percentFormatter = NumberFormatter.percent
    priceFormatter = NumberFormatter.price(currencyCode: "PLN")
    factory = OptionsFactory(percentFormatter: percentFormatter, priceFormatter: priceFormatter)
    proposal = decode(type: InstallmentProposal.self, from: "mastercard_installments_vnoo")
    sut = OptionsViewModel(factory: factory, proposal: proposal)
    sut.delegate = delegate
  }

  override func tearDown() {
    super.tearDown()
    reset(delegate)
    percentFormatter = nil
    priceFormatter = nil
    factory = nil
    proposal = nil
    sut = nil
  }

  func testNumberOfSectionsShouldReturnCorrectValue() throws {
    XCTAssertEqual(sut.numberOfSections(), 1)
  }

  func testNumberOfItemsShouldReturnCorrectValue() throws {
    XCTAssertEqual(sut.numberOfItems(in: 0), 3)
  }

  func testItemAtIndexPathShouldReturnCorrectValue() throws {
    XCTAssertEqual(sut.item(at: IndexPath(row: 0, section: 0)).option, proposal.installmentOptions[0])
    XCTAssertEqual(sut.item(at: IndexPath(row: 1, section: 0)).option, proposal.installmentOptions[1])
    XCTAssertEqual(sut.item(at: IndexPath(row: 2, section: 0)).option, proposal.installmentOptions[2])
  }

  func testShouldInformDelegateWhenDidSelectItem() throws {
    sut.didSelectItem(at: IndexPath(row: 0, section: 0))
    verify(delegate.optionsViewModel(
      any(),
      didComplete: InstallmentResult.from(
        proposal: proposal,
        option: proposal.installmentOptions[0])))
    .wasCalled()

    sut.didSelectItem(at: IndexPath(row: 1, section: 0))
    verify(delegate.optionsViewModel(
      any(),
      didComplete: InstallmentResult.from(
        proposal: proposal,
        option: proposal.installmentOptions[1])))
    .wasCalled()
  }
}
