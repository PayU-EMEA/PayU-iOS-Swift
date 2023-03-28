//
//  InstallmentProposalTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUMastercardInstallments

final class InstallmentProposalTests: XCTestCase {

  func testInstallmentProposalFormatHasCorrectValues() {
    XCTAssertEqual(InstallmentProposal.Format.varyingNumberOfInstallments.rawValue, "VARYING_NUMBER_OF_INSTALLMENTS")
    XCTAssertEqual(InstallmentProposal.Format.varyingNumberOfOptions.rawValue, "VARYING_NUMBER_OF_OPTIONS")
  }

  func testMapsCorrectly() throws {
    let sut = decode(type: InstallmentProposal.self, from: "installment_proposal")

    XCTAssertEqual(sut.id, "95fd7066-2bd7-4476-9555-99aed5cc6a5e")
    XCTAssertEqual(sut.cardScheme, "MC")
    XCTAssertEqual(sut.installmentOptionFormat, .varyingNumberOfOptions)
    XCTAssertEqual(sut.currencyCode, "PLN")

    XCTAssertEqual(sut.installmentOptions.count, 3)

    XCTAssertEqual(sut.installmentOptions[0].id, "1")
    XCTAssertEqual(sut.installmentOptions[0].interestRate, 5.4)
    XCTAssertEqual(sut.installmentOptions[0].installmentFeeAmount, 1000)
    XCTAssertEqual(sut.installmentOptions[0].annualPercentageRate, 17.93)
    XCTAssertEqual(sut.installmentOptions[0].totalAmountDue, 49440)
    XCTAssertEqual(sut.installmentOptions[0].firstInstallmentAmount, 16480)
    XCTAssertEqual(sut.installmentOptions[0].installmentAmount, 16480)
    XCTAssertEqual(sut.installmentOptions[0].numberOfInstallments, 3)

    XCTAssertEqual(sut.installmentOptions[1].id, "2")
    XCTAssertEqual(sut.installmentOptions[1].interestRate, 5.2)
    XCTAssertEqual(sut.installmentOptions[1].installmentFeeAmount, 1100)
    XCTAssertEqual(sut.installmentOptions[1].annualPercentageRate, 13.05)
    XCTAssertEqual(sut.installmentOptions[1].totalAmountDue, 49848)
    XCTAssertEqual(sut.installmentOptions[1].firstInstallmentAmount, 8308)
    XCTAssertEqual(sut.installmentOptions[1].installmentAmount, 8308)
    XCTAssertEqual(sut.installmentOptions[1].numberOfInstallments, 6)

    XCTAssertEqual(sut.installmentOptions[2].id, "3")
    XCTAssertEqual(sut.installmentOptions[2].interestRate, 5)
    XCTAssertEqual(sut.installmentOptions[2].installmentFeeAmount, 1200)
    XCTAssertEqual(sut.installmentOptions[2].annualPercentageRate, 9.64)
    XCTAssertEqual(sut.installmentOptions[2].totalAmountDue, 50544)
    XCTAssertEqual(sut.installmentOptions[2].firstInstallmentAmount, 4344)
    XCTAssertEqual(sut.installmentOptions[2].installmentAmount, 4200)
    XCTAssertEqual(sut.installmentOptions[2].numberOfInstallments, 12)
  }
}
