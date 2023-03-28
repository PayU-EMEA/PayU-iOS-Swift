//
//  InstallmentOption.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Installment option
public struct InstallmentOption: Codable, Equatable {

  // MARK: - Public Properties

  /// Identifier of installment option.
  public let id: String

  /// Interest rate.
  public let interestRate: Double

  /// Installment fee amount in cents.
  public let installmentFeeAmount: Int

  /// Annual percentage rate (APR).
  public let annualPercentageRate: Double

  /// Total amount due in cents.
  public let totalAmountDue: Int

  /// First installment amount in cents.
  ///
  /// only for **VARYING_NUMBER_OF_OPTIONS**
  public let firstInstallmentAmount: Int?

  /// Subsequent installment amounts in cents
  ///
  /// only for **VARYING_NUMBER_OF_OPTIONS**
  public let installmentAmount: Int?

  /// Number of installments.
  ///
  /// only for **VARYING_NUMBER_OF_OPTIONS**
  public let numberOfInstallments: Int?

  // MARK: - Public Methods
  func copyWith(numberOfInstallments: Int) -> InstallmentOption {
    InstallmentOption(
      id: id,
      interestRate: interestRate,
      installmentFeeAmount: installmentFeeAmount,
      annualPercentageRate: annualPercentageRate,
      totalAmountDue: totalAmountDue,
      firstInstallmentAmount: firstInstallmentAmount,
      installmentAmount: installmentAmount,
      numberOfInstallments: numberOfInstallments)
  }

}
