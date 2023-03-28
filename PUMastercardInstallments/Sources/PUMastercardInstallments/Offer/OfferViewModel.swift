//
//  OfferViewModel.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

protocol OfferViewModelDelegate: AnyObject {
  func offerViewModel(_ viewModel: OfferViewModel, shouldNavigateToOptions proposal: InstallmentProposal)
  func offerViewModel(_ viewModel: OfferViewModel, didComplete result: InstallmentResult)
  func offerViewModelDidCancel(_ viewModel: OfferViewModel)
}

final class OfferViewModel {

  // MARK: - Public Properties
  weak var delegate: OfferViewModelDelegate?

  // MARK: - Private Properties
  private let proposal: InstallmentProposal

  // MARK: - Initialization
  init(proposal: InstallmentProposal) {
    self.proposal = proposal
  }

  // MARK: - Public Methods
  func didTapSplitIntoInstallments() {
    delegate?.offerViewModel(self, shouldNavigateToOptions: proposal)
  }

  func didTapNoThanks() {
    delegate?.offerViewModelDidCancel(self)
  }

  func didSelect(result: InstallmentResult) {
    delegate?.offerViewModel(self, didComplete: result)
  }
}
