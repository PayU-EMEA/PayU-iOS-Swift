//
//  OptionsFactoryTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUMastercardInstallments

final class OptionsFactoryTests: XCTestCase {

  private var percentFormatter: NumberFormatter!
  private var priceFormatter: NumberFormatter!
  private var proposalVNOI: InstallmentProposal!
  private var proposalVNOO: InstallmentProposal!
  private var sut: OptionsFactory!

  override func setUp() {
    super.setUp()
    percentFormatter = NumberFormatter.percent
    priceFormatter = NumberFormatter.price(currencyCode: "PLN")
    sut = OptionsFactory(percentFormatter: percentFormatter, priceFormatter: priceFormatter)
  }

  override func tearDown() {
    super.tearDown()
    percentFormatter = nil
    priceFormatter = nil
    sut = nil
  }

  func testProposalWithVaryingNumberOfInstallmentsOptionFormatShouldReturnCorrectItems() throws {
    let proposal = decode(type: InstallmentProposal.self, from: "mastercard_installments_vnoi")
    let option = proposal.installmentOptions[0]
    let items = sut.items(proposal: proposal)

    XCTAssertEqual(items.count, 7)

    XCTAssertEqual(items[0].option, option.copyWith(numberOfInstallments: 6))
    XCTAssertEqual(items[0].title, "6 installments")
    XCTAssertEqual(items[0].accessoryPrefix, nil)
    XCTAssertEqual(items[0].accessoryTitle, "0.0%")
    XCTAssertEqual(items[0].accessorySubtitle, "total PLN 480.00")

    XCTAssertEqual(items[1].option, option.copyWith(numberOfInstallments: 7))
    XCTAssertEqual(items[1].title, "7 installments")
    XCTAssertEqual(items[1].accessoryPrefix, nil)
    XCTAssertEqual(items[1].accessoryTitle, "0.0%")
    XCTAssertEqual(items[1].accessorySubtitle, "total PLN 480.00")

    XCTAssertEqual(items[2].option, option.copyWith(numberOfInstallments: 8))
    XCTAssertEqual(items[2].title, "8 installments")
    XCTAssertEqual(items[2].accessoryPrefix, nil)
    XCTAssertEqual(items[2].accessoryTitle, "0.0%")
    XCTAssertEqual(items[2].accessorySubtitle, "total PLN 480.00")

    XCTAssertEqual(items[3].option, option.copyWith(numberOfInstallments: 9))
    XCTAssertEqual(items[3].title, "9 installments")
    XCTAssertEqual(items[3].accessoryPrefix, nil)
    XCTAssertEqual(items[3].accessoryTitle, "0.0%")
    XCTAssertEqual(items[3].accessorySubtitle, "total PLN 480.00")

    XCTAssertEqual(items[4].option, option.copyWith(numberOfInstallments: 10))
    XCTAssertEqual(items[4].title, "10 installments")
    XCTAssertEqual(items[4].accessoryPrefix, nil)
    XCTAssertEqual(items[4].accessoryTitle, "0.0%")
    XCTAssertEqual(items[4].accessorySubtitle, "total PLN 480.00")

    XCTAssertEqual(items[5].option, option.copyWith(numberOfInstallments: 11))
    XCTAssertEqual(items[5].title, "11 installments")
    XCTAssertEqual(items[5].accessoryPrefix, nil)
    XCTAssertEqual(items[5].accessoryTitle, "0.0%")
    XCTAssertEqual(items[5].accessorySubtitle, "total PLN 480.00")

    XCTAssertEqual(items[6].option, option.copyWith(numberOfInstallments: 12))
    XCTAssertEqual(items[6].title, "12 installments")
    XCTAssertEqual(items[6].accessoryPrefix, nil)
    XCTAssertEqual(items[6].accessoryTitle, "0.0%")
    XCTAssertEqual(items[6].accessorySubtitle, "total PLN 480.00")
  }

  func testProposalWithVaryingNumberOfOptionsOptionFormatShouldReturnCorrectItems() throws {
    let proposal = decode(type: InstallmentProposal.self, from: "mastercard_installments_vnoo")
    let items = sut.items(proposal: proposal)

    XCTAssertEqual(items.count, 3)

    XCTAssertEqual(items[0].option, proposal.installmentOptions[0])
    XCTAssertEqual(items[0].title, "3 installments")
    XCTAssertEqual(items[0].accessoryPrefix, "1st installment")
    XCTAssertEqual(items[0].accessoryTitle, "PLN 164.00")
    XCTAssertEqual(items[0].accessorySubtitle, "total PLN 494.00")

    XCTAssertEqual(items[1].option, proposal.installmentOptions[1])
    XCTAssertEqual(items[1].title, "6 installments")
    XCTAssertEqual(items[1].accessoryPrefix, "1st installment")
    XCTAssertEqual(items[1].accessoryTitle, "PLN 83.00")
    XCTAssertEqual(items[1].accessorySubtitle, "total PLN 498.00")

    XCTAssertEqual(items[2].option, proposal.installmentOptions[2])
    XCTAssertEqual(items[2].title, "12 installments")
    XCTAssertEqual(items[2].accessoryPrefix, "1st installment")
    XCTAssertEqual(items[2].accessoryTitle, "PLN 43.00")
    XCTAssertEqual(items[2].accessorySubtitle, "total PLN 505.00")
  }
}
