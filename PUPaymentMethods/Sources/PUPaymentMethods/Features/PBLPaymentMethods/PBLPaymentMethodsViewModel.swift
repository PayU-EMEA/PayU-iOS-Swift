//
//  PBLPaymentMethodsViewModel.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

protocol PBLPaymentMethodsViewModelProtocol {
  func numberOfSections() -> Int
  func numberOfItems(in section: Int) -> Int
  func item(at indexPath: IndexPath) -> PaymentMethodItemPayByLink
  func didSelectItem(at indexPath: IndexPath)
}

protocol PBLPaymentMethodsViewModelDelegate: AnyObject {
  func paymentMethodsViewModel(_ viewModel: PBLPaymentMethodsViewModel, didSelect payByLink: PayByLink)
}

final class PBLPaymentMethodsViewModel {

  // MARK: - Public Properties
  weak var delegate: PBLPaymentMethodsViewModelDelegate?
  private(set) var items: [PaymentMethodItemPayByLink] = []
  
  // MARK: - Private Properties
  private let configuration: PaymentMethodsConfiguration
  private let service: PaymentMethodsServiceProtocol

  // MARK: - Initialization
  init(configuration: PaymentMethodsConfiguration, service: PaymentMethodsServiceProtocol) {
    self.configuration = configuration
    self.service = service
    self.items = service
      .makePayByLinksPaymentMethodItems(for: configuration)
      .compactMap { $0 as? PaymentMethodItemPayByLink }
  }
}

// MARK: - PBLPaymentMethodsViewModelProtocol
extension PBLPaymentMethodsViewModel: PBLPaymentMethodsViewModelProtocol {
  func numberOfSections() -> Int {
    1
  }
  
  func numberOfItems(in section: Int) -> Int {
    items.count
  }
  
  func item(at indexPath: IndexPath) -> PaymentMethodItemPayByLink {
    items[indexPath.row]
  }
  
  func didSelectItem(at indexPath: IndexPath) {
    if let paymentMethod = item(at: indexPath).paymentMethod,
       let payByLink = paymentMethod as? PayByLink {
      delegate?.paymentMethodsViewModel(self, didSelect: payByLink)
    }
  }
}
