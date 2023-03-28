//
//  OrderPaymentMethodListItem.swift
//  Example
//
//  Created by PayU S.A. on 30/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import PUSDK

enum OrderPaymentMethodListItem {
  case openPaymentMethods(PaymentMethod?)

  var title: String {
    switch self {
      case .openPaymentMethods:
        return "Open PaymentMethodsViewController"
    }
  }

  var subtitle: String? {
    switch self {
      case .openPaymentMethods(let paymentMethod):
        return paymentMethod?.name
    }
  }
}
