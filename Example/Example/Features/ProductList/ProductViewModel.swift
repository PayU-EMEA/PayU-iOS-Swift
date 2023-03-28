//
//  ProductViewModel.swift
//  Example
//
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

protocol ProductViewModelDelegate: AnyObject {
  func viewModel(_ viewModel: ProductViewModel, didUpdateQuantity quantity: Int, for product: Product)
}

final class ProductViewModel {

  // MARK: - Public Properties
  weak var delegate: ProductViewModelDelegate?
  let product: Product

  // MARK: - Private Properties
  private let repository = SettingsRepository()

  // MARK: - Initialization
  init(delegate: ProductViewModelDelegate, product: Product) {
    self.delegate = delegate
    self.product = product
  }

  // MARK: - Public Methods
  func formattedTitle() -> String {
    return product.name + " " + "(\(product.quantity))"
  }

  func formattedPrice() -> String {
    let formatter = NumberFormatter.currency
    formatter.currencyCode = repository.getCurrencyCode()
    return formatter.string(from: NSNumber(value: Double(product.unitPrice))) ?? ""
  }

  func didUpdateQuantity(_ quantity: Int) {
    delegate?.viewModel(self, didUpdateQuantity: quantity, for: product)
  }
}

