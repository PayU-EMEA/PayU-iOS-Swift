//
//  InstallmentResult.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Data that uniquely identifies selected installment option
public struct InstallmentResult: Equatable {

  /// Identifier of installment option.
  ///
  /// required for **VARYING_NUMBER_OF_OPTIONS** format
  public let optionId: String?

  /// Number of installments.
  ///
  /// required for **VARYING_NUMBER_OF_INSTALLMENTS** format
  public let numberOfInstallments: Int?

  // MARK: - Initialization
  init(optionId: String? = nil, numberOfInstallments: Int? = nil) {
    self.optionId = optionId
    self.numberOfInstallments = numberOfInstallments
  }

  // MARK: - Public Methods
  static func from(proposal: InstallmentProposal, option: InstallmentOption) -> InstallmentResult {
    switch proposal.installmentOptionFormat {
      case .varyingNumberOfInstallments:
        return .init(numberOfInstallments: option.numberOfInstallments)
      case .varyingNumberOfOptions:
        return .init(optionId: option.id)
    }
  }
}
