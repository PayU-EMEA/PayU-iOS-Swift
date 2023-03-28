//
//  InstallmentProposal.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Installment proposal with options in one out of two possible formats: ``InstallmentProposal/Format``
public struct InstallmentProposal: Codable, Equatable {

  // MARK: - Format

  /// One out of two possible formats
  public enum Format: String, Codable {

    /// format with single installment option, number of installments to choose
    case varyingNumberOfInstallments = "VARYING_NUMBER_OF_INSTALLMENTS"

    /// format with multiple installment options (1 to 12), single option to choose
    case varyingNumberOfOptions = "VARYING_NUMBER_OF_OPTIONS"
  }

  // MARK: - Public Properties

  /// Unique identifier of installment proposal.
  public let id: String

  /// Card scheme (MC – Mastercard).
  public let cardScheme: String

  /// Installment option format
  public let installmentOptionFormat: InstallmentProposal.Format

  /// 3-letter currency code.
  public let currencyCode: String

  public let installmentOptions: [InstallmentOption]

  /// Minimum number of installments allowed, values from 2 to 99.
  ///
  /// only for **VARYING_NUMBER_OF_OPTIONS**
  public let minNumberOfInstallments: Int?

  /// Maximum number of installments allowed, values from 2 to 99.
  ///
  /// only for **VARYING_NUMBER_OF_OPTIONS**
  public let maxNumberOfInstallments: Int?
}
