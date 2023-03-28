//
//  PaymentMethodsStorage.swift
//  
//  Created by PayU S.A. on 12/01/2023.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Protocol which defines how to save and get the last selected payment method value associated with the user
public protocol PaymentMethodsStorageProtocol {
  /// Allows to get the last selected payment method value associated with the user
  /// - Returns: last selected payment method value
  func getSelectedPaymentMethodValue() -> String?

  /// Allows to save the last selected payment method value associated with the user
  /// - Parameter value: `value` of the `PaymentMethod`, for ex: "jp", "TOK_HDKASD098ASD908", etc.. See `PUCore` for details
  func saveSelectedPaymentMethodValue(_ value: String)
}
