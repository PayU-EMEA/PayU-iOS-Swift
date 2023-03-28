//
//  InstallmentOptionTests.swift
//  
//  Created by PayU S.A. on 13/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUMastercardInstallments

final class InstallmentOptionTests: XCTestCase {

  func testMapsCorrectly() throws {
    let sut = decode(type: InstallmentOption.self, from: "installment_option")

    XCTAssertEqual(sut.id, "1")
    XCTAssertEqual(sut.interestRate, 5.4)
    XCTAssertEqual(sut.installmentFeeAmount, 1000)
    XCTAssertEqual(sut.annualPercentageRate, 17.93)
    XCTAssertEqual(sut.totalAmountDue, 49440)
    XCTAssertEqual(sut.firstInstallmentAmount, 16480)
    XCTAssertEqual(sut.installmentAmount, 16480)
    XCTAssertEqual(sut.numberOfInstallments, 3)
  }
}
