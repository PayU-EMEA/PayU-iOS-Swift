//
//  OrderRepository.swift
//  Example
//
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation
import PUSDK

final class OrderRepository {

  // MARK: - Public Properties
  private(set) var products = Product.products
  private(set) var paymentMethod: PaymentMethod?

  // MARK: - Public Methods
  func totalPrice() -> Int {
    return products.map { $0.unitPrice * $0.quantity }.reduce(0, +)
  }

  func didUpdateProductMethod(_ paymentMethod: PaymentMethod?) {
    self.paymentMethod = paymentMethod
  }

  func didUpdateQuantity(_ quantity: Int, for product: Product) {
    product.quantity = quantity
  }
}
