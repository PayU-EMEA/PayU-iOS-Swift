//
//  OptionsViewModel.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

protocol OptionsViewModelDelegate: AnyObject {
  func optionsViewModel(_ viewModel: OptionsViewModel, didComplete result: InstallmentResult)
}

final class OptionsViewModel {

  // MARK: - Public Properties
  weak var delegate: OptionsViewModelDelegate?

  // MARK: - Private Properties
  private let items: [OptionsItem]
  private let proposal: InstallmentProposal

  // MARK: - Initialization
  init(factory: OptionsFactoryProtocol, proposal: InstallmentProposal) {
    self.items = factory.items(proposal: proposal)
    self.proposal = proposal
  }

  // MARK: - Public Properties
  func numberOfSections() -> Int {
    return 1
  }

  func numberOfItems(in section: Int) -> Int {
    return items.count
  }

  func item(at indexPath: IndexPath) -> OptionsItem {
    return items[indexPath.row]
  }

  func didSelectItem(at indexPath: IndexPath) {
    let result = InstallmentResult.from(proposal: proposal, option: item(at: indexPath).option)
    delegate?.optionsViewModel(self, didComplete: result)
  }
}
