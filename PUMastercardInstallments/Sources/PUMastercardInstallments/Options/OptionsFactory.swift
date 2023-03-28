//
//  OptionsFactory.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTranslations)
import PUTranslations
#endif

protocol OptionsFactoryProtocol {
  func items(proposal: InstallmentProposal) -> [OptionsItem]
}

struct OptionsFactory: OptionsFactoryProtocol {

  // MARK: - Private Properties
  private let percentFormatter: NumberFormatter
  private let priceFormatter: NumberFormatter

  // MARK: - Initialization
  init(percentFormatter: NumberFormatter, priceFormatter: NumberFormatter) {
    self.percentFormatter = percentFormatter
    self.priceFormatter = priceFormatter
  }

  // MARK: - OptionsFactoryProtocol
  func items(proposal: InstallmentProposal) -> [OptionsItem] {
    switch proposal.installmentOptionFormat {
      case .varyingNumberOfInstallments:
        return mapVaryingNumberOfInstallments(proposal: proposal)
      case .varyingNumberOfOptions:
        return mapVaryingNumberOfOptions(proposal: proposal)
    }
  }

  // MARK: - Private Methods
  private func mapVaryingNumberOfInstallments(proposal: InstallmentProposal) -> [OptionsItem] {
    guard let minNumberOfInstallments = proposal.minNumberOfInstallments,
          let maxNumberOfInstallments = proposal.maxNumberOfInstallments,
          let installmentOption = proposal.installmentOptions.first else { return [] }

    return Array(stride(
      from: minNumberOfInstallments,
      through: maxNumberOfInstallments,
      by: 1))
    .map { installmentOption.copyWith(numberOfInstallments: $0) }
    .map { OptionsItem(
      option: $0,
      title: formattedNumberOfInstallments($0.numberOfInstallments!),
      accessoryPrefix: nil,
      accessoryTitle: formattedInterestRate($0),
      accessorySubtitle: formattedTotal($0))
    }
  }

  private func mapVaryingNumberOfOptions(proposal: InstallmentProposal) -> [OptionsItem] {
    proposal.installmentOptions
      .map { OptionsItem(
        option: $0,
        title: formattedNumberOfInstallments($0.numberOfInstallments!),
        accessoryPrefix: "1_st_installment".localized(),
        accessoryTitle: formattedFirstInstallmentAmount($0),
        accessorySubtitle: formattedTotal($0))
      }
  }

  // MARK: - Formatting
  private func formattedNumberOfInstallments(_ numberOfInstallments: Int) -> String {
    String(format: "number_of_installments".localized(numberCategory: .plural), numberOfInstallments)
  }

  private func formattedInterestRate(_ option: InstallmentOption) -> String {
    percentFormatter.string(from: NSNumber(value: option.interestRate)) ?? ""
  }

  private func formattedFirstInstallmentAmount(_ option: InstallmentOption) -> String {
    priceFormatter.string(from: NSNumber(value: option.firstInstallmentAmount!)) ?? ""
  }

  private func formattedTotal(_ option: InstallmentOption) -> String {
    let left = "total".localized() + " "
    let right = priceFormatter.string(from: NSNumber(value: option.totalAmountDue)) ?? ""
    return left + right
  }
}
