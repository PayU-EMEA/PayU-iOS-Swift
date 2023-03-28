//
//  InstallmentResultTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUMastercardInstallments

final class InstallmentResultTests: XCTestCase {

  func testInstallmentResultReturnsCorrectModelForVaryingNumberOfInstallments() throws {
    let numberOfInstallments = 8
    let proposal = decode(type: InstallmentProposal.self, from: "mastercard_installments_vnoi")
    let option = proposal.installmentOptions.first!.copyWith(numberOfInstallments: numberOfInstallments)

    let sut = InstallmentResult.from(proposal: proposal, option: option)
    XCTAssertEqual(sut.numberOfInstallments, numberOfInstallments)
    XCTAssertNil(sut.optionId)
  }

  func testInstallmentResultReturnsCorrectModelForVaryingNumberOfOptions() throws {
    let proposal = decode(type: InstallmentProposal.self, from: "mastercard_installments_vnoo")
    let option = proposal.installmentOptions[2]

    let sut = InstallmentResult.from(proposal: proposal, option: option)
    XCTAssertEqual(sut.optionId, option.id)
    XCTAssertNil(sut.numberOfInstallments)
  }
}
