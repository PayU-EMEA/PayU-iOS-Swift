//
//  PaymentMethodsDatabase.swift
//  Example
//
//  Created by PayU S.A. on 12/01/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//  

import PUSDK

class PaymentMethodsDatabase {

  // MARK: - Singleton
  static let database = PaymentMethodsDatabase()

  // MARK: - Private Properties
  private var selectedPaymentMethodValue: String?

  // MARK: - Initialization
  private init() {  }
}

// MARK: - PaymentMethodsStorageProtocol
extension PaymentMethodsDatabase: PaymentMethodsStorageProtocol {
  func saveSelectedPaymentMethodValue(_ value: String) {
    selectedPaymentMethodValue = value
  }

  func getSelectedPaymentMethodValue() -> String? {
    selectedPaymentMethodValue
  }
}
