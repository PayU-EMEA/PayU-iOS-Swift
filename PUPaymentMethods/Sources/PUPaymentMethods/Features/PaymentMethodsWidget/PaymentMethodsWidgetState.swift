//
//  PaymentMethodsWidgetState.swift
//
//  Created by PayU S.A. on 23/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

#if canImport(PUCore)
import PUCore
#endif

enum PaymentMethodsWidgetState: Equatable {
  case initial
  case blikCode(PaymentMethod)
  case blikToken(PaymentMethod)
  case paymentMethod(PaymentMethod)

  // MARK: - Equatable
  static func == (lhs: PaymentMethodsWidgetState, rhs: PaymentMethodsWidgetState) -> Bool {
    switch (lhs, rhs) {
      case (.initial, .initial):
        return true
      case (.blikCode(let left), .blikCode(let right)):
        return left.value == right.value
      case (.blikToken(let left), .blikToken(let right)):
        return left.value == right.value
      case (.paymentMethod(let left), .paymentMethod(let right)):
        return left.value == right.value
      default:
        return false
    }
  }
}
