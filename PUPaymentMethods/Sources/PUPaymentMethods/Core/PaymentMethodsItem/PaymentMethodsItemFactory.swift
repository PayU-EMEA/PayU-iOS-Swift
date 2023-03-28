//
//  PaymentMethodsItemFactory.swift
//  
//  Created by PayU S.A. on 28/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

#if canImport(PUCore)
import PUCore
#endif

protocol PaymentMethodsItemFactoryProtocol {
  func item(_ paymentMethod: PaymentMethod) -> PaymentMethodsItem?
}

struct PaymentMethodsItemFactory: PaymentMethodsItemFactoryProtocol {

  // MARK: - PaymentMethodsItemFactoryProtocol
  func item(_ paymentMethod: PaymentMethod) -> PaymentMethodsItem? {
    switch paymentMethod {
      case let applePay as ApplePay:
       return PaymentMethodItemApplePay(applePay: applePay)
      case let blikCode as BlikCode:
        return PaymentMethodItemBlikCode(blikCode: blikCode)
      case let blikToken as BlikToken:
        return PaymentMethodItemBlikToken(blikToken: blikToken)
      case let cardToken as CardToken:
        return PaymentMethodItemCardToken(cardToken: cardToken)
      case let insellments as Installments:
        return PaymentMethodItemInstallments(installments: insellments)
      case let payByLink as PayByLink:
        return PaymentMethodItemPayByLink(payByLink: payByLink)
      default:
        return nil
    }
  }
}
