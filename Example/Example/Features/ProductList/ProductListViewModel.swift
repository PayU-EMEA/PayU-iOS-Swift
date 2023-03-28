//
//  ProductViewModel.swift
//  Example
//
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

protocol ProductListViewModelDelegate: AnyObject {
  func productListViewModelDidUpdate(_ viewModel: ProductListViewModel)
}

final class ProductListViewModel: ProductViewModelDelegate {

  // MARK: - Public Properties
  weak var delegate: ProductListViewModelDelegate?
  lazy var viewModels: [ProductViewModel] = orderRepository.products.map { ProductViewModel(delegate: self, product: $0) }

  // MARK: - Private Properties
  private let orderRepository = OrderRepository()
  private let settingsRepository = SettingsRepository()

  // MARK: - Public Methods
  func totalPrice() -> Int {
    return orderRepository.totalPrice()
  }

  func formattedTotalPrice() -> String {
    let formatter = NumberFormatter.currency
    formatter.currencyCode = settingsRepository.getCurrencyCode()
    return "Pay:" + " " + (formatter.string(from: NSNumber(value: Double(totalPrice()))) ?? "")
  }

  // MARK: - ProductViewModelDelegate
  func viewModel(_ viewModel: ProductViewModel, didUpdateQuantity quantity: Int, for product: Product) {
    orderRepository.didUpdateQuantity(quantity, for: product)
    delegate?.productListViewModelDidUpdate(self)
  }
}
