//
//  MastercardInstallmentsAssembler.swift
//  
//  Created by PayU S.A. on 23/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

struct MastercardInstallmentsAssembler {

  // MARK: - Public Methods
  func makePercentFormatter() -> NumberFormatter {
    NumberFormatter.percent
  }

  func makePriceFormatter(currencyCode: String) -> NumberFormatter {
    NumberFormatter.price(currencyCode: currencyCode)
  }

  func makeOfferViewController(proposal: InstallmentProposal) -> OfferViewController {
    OfferViewController(viewModel: makeOfferViewModel(proposal: proposal))
  }

  func makeOfferViewModel(proposal: InstallmentProposal) -> OfferViewModel {
    OfferViewModel(proposal: proposal)
  }
  
  func makeOptionsFactory(proposal: InstallmentProposal) -> OptionsFactory {
    OptionsFactory(
      percentFormatter: makePercentFormatter(),
      priceFormatter: makePriceFormatter(currencyCode: proposal.currencyCode)
    )
  }

  func makeOptionsViewController(proposal: InstallmentProposal) -> OptionsViewController {
    OptionsViewController(viewModel: makeOptionsViewModel(proposal: proposal))
  }

  func makeOptionsViewModel(proposal: InstallmentProposal) -> OptionsViewModel {
    OptionsViewModel(
      factory: makeOptionsFactory(proposal: proposal),
      proposal: proposal)
  }
}
