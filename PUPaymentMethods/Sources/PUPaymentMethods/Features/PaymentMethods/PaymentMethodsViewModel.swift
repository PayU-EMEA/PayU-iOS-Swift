//
//  PaymentMethodsViewModel.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

protocol PaymentMethodsViewModelProtocol {
  func numberOfSections() -> Int
  func numberOfItems(in section: Int) -> Int
  func item(at indexPath: IndexPath) -> PaymentMethodsItem

  func canDeleteItem(at indexPath: IndexPath) -> Bool
  func deleteItem(at indexPath: IndexPath)

  func didSelectItem(at indexPath: IndexPath) -> PaymentMethodsItem
  func didSelectPayByLink(_ payByLink: PayByLink)
}

protocol PaymentMethodsViewModelDelegate: AnyObject {
  func viewModel(_ viewModel: PaymentMethodsViewModel, didComplete paymentMethod: PaymentMethod)
  func viewModel(_ viewModel: PaymentMethodsViewModel, didDelete paymentMethod: PaymentMethod)
  func viewModel(_ viewModel: PaymentMethodsViewModel, shouldNavigateToBankTransfer configuration: PaymentMethodsConfiguration)
  func viewModelDidUpdate(_ viewModel: PaymentMethodsViewModel)
  func viewModelShouldNavigateToCard(_ viewModel: PaymentMethodsViewModel)
}

final class PaymentMethodsViewModel {

  // MARK: - Public Properties
  weak var delegate: PaymentMethodsViewModelDelegate?

  // MARK: - Private Properties
  private var configuration: PaymentMethodsConfiguration
  private let service: PaymentMethodsServiceProtocol
  private let storage: PaymentMethodsStorageProtocol?
  private var items: [PaymentMethodsItem]
  private var removed: [String]

  // MARK: - Initialization
  init(
    configuration: PaymentMethodsConfiguration,
    service: PaymentMethodsServiceProtocol,
    storage: PaymentMethodsStorageProtocol?) {

      self.configuration = configuration
      self.service = service
      self.storage = storage
      self.items = service.makePaymentMethodItems(for: configuration)
      self.removed = []
    }

  // MARK: - Public Methods
  func numberOfSections() -> Int {
    1
  }

  func numberOfItems(in section: Int) -> Int {
    items.count
  }

  func item(at indexPath: IndexPath) -> PaymentMethodsItem {
    items[indexPath.row]
  }

  func canDeleteItem(at indexPath: IndexPath) -> Bool {
    item(at: indexPath) is PaymentMethodItemCardToken
  }

  func deleteItem(at indexPath: IndexPath) {
    let paymentMethodItemToBeDeleted = item(at: indexPath)
    let paymentMethodToBeDeleted = paymentMethodItemToBeDeleted.paymentMethod

    guard let value = paymentMethodItemToBeDeleted.value,
          let paymentMethod = paymentMethodToBeDeleted else { return }

    removed.append(value)
    items.removeAll(where: { $0.value != nil ? removed.contains($0.value!) : false })
    delegate?.viewModel(self, didDelete: paymentMethod)
  }

  @discardableResult
  func didSelectItem(at indexPath: IndexPath) -> PaymentMethodsItem {
    switch item(at: indexPath) {
      case let value as PaymentMethodItemApplePay:
        navigateToComplete(value.paymentMethod)
      case is PaymentMethodItemBankTransfer:
        navigateToBankTransfer()
      case let value as PaymentMethodItemBlikCode:
        navigateToComplete(value.paymentMethod)
      case let value as PaymentMethodItemBlikToken:
        navigateToComplete(value.paymentMethod)
      case is PaymentMethodItemCard:
        navigateToCard()
      case let value as PaymentMethodItemCardToken:
        navigateToComplete(value.paymentMethod)
      case let value as PaymentMethodItemInstallments:
        navigateToComplete(value.paymentMethod)
      case let value as PaymentMethodItemPayByLink:
        navigateToComplete(value.paymentMethod)
      default:
        break
    }
    return item(at: indexPath)
  }

  func didSelectCardToken(_ cardToken: CardToken) {
    configuration = configuration.copyWith(cardToken)
    items = service.makePaymentMethodItems(for: configuration)
    delegate?.viewModelDidUpdate(self)
    navigateToComplete(cardToken)
  }

  func didSelectPayByLink(_ payByLink: PayByLink) {
    navigateToComplete(payByLink)
  }

  // MARK: - Private Methods
  private func navigateToCard() {
    delegate?.viewModelShouldNavigateToCard(self)
  }

  private func navigateToBankTransfer() {
    delegate?.viewModel(self, shouldNavigateToBankTransfer: configuration)
  }

  private func navigateToComplete(_ paymentMethod: PaymentMethod?) {
    guard let paymentMethod = paymentMethod else { return }
    storage?.saveSelectedPaymentMethodValue(paymentMethod.value)
    delegate?.viewModel(self, didComplete: paymentMethod)
  }
}
