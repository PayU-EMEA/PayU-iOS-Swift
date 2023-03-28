//
//  PaymentMethodsItem.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTranslations)
import PUTranslations
#endif

protocol PaymentMethodsItem {
  var enabled: Bool { get }
  var title: String { get }
  var subtitle: String? { get }
  var brandImageProvider: BrandImageProvider { get }
  var paymentMethod: PaymentMethod? { get }
  var value: String? { get }
}

// MARK: - PaymentMethodItemApplePay
struct PaymentMethodItemApplePay: PaymentMethodsItem {
  private let applePay: ApplePay

  var enabled: Bool { applePay.enabled }
  var title: String { applePay.name }
  var subtitle: String? { "pay_by_phone".localized() }
  var brandImageProvider: BrandImageProvider { applePay.brandImageProvider }
  var paymentMethod: PaymentMethod? { applePay }
  var value: String? { applePay.value }

  init(applePay: ApplePay) {
    self.applePay = applePay
  }
}

// MARK: - PaymentMethodItemBankTransfer
struct PaymentMethodItemBankTransfer: PaymentMethodsItem {
  let enabled: Bool
  var title: String { "bank_transfer".localized() }
  var subtitle: String? { "fast_online_transfer".localized() }
  var brandImageProvider: BrandImageProvider { .paperplane }
  var paymentMethod: PaymentMethod? { nil }
  var value: String? { nil }

  init(enabled: Bool) {
    self.enabled = enabled
  }
}

// MARK: - PaymentMethodItemBlikCode
struct PaymentMethodItemBlikCode: PaymentMethodsItem {
  private let blikCode: BlikCode

  var enabled: Bool { blikCode.enabled }
  var title: String { blikCode.name }
  var subtitle: String? { "use_code_from_your_bank_app".localized() }
  var brandImageProvider: BrandImageProvider { blikCode.brandImageProvider }
  var paymentMethod: PaymentMethod? { blikCode }
  var value: String? { blikCode.value }

  init(blikCode: BlikCode) {
    self.blikCode = blikCode
  }
}

// MARK: - PaymentMethodItemBlikToken
struct PaymentMethodItemBlikToken: PaymentMethodsItem {
  private let blikToken: BlikToken

  var enabled: Bool { blikToken.enabled }
  var title: String { blikToken.name }
  var subtitle: String? { "one_tap_payment".localized() }
  var brandImageProvider: BrandImageProvider { blikToken.brandImageProvider }
  var paymentMethod: PaymentMethod? { blikToken }
  var value: String? { blikToken.value }

  init(blikToken: BlikToken) {
    self.blikToken = blikToken
  }
}

// MARK: - PaymentMethodItemCard
struct PaymentMethodItemCard: PaymentMethodsItem {
  var enabled: Bool { true }
  var title: String { "card".localized() }
  var subtitle: String? { "credit_or_debit".localized() }
  var brandImageProvider: BrandImageProvider { .creditcard }
  var paymentMethod: PaymentMethod? { nil }
  var value: String? { nil }
}

// MARK: - PaymentMethodItemCardToken
struct PaymentMethodItemCardToken: PaymentMethodsItem {
  private let cardToken: CardToken

  var enabled: Bool { cardToken.enabled }
  var title: String { cardToken.cardNumberMasked }
  var subtitle: String? { "\(cardToken.cardExpirationMonth)/\(cardToken.cardExpirationYear)" }
  var brandImageProvider: BrandImageProvider { cardToken.brandImageProvider }
  var paymentMethod: PaymentMethod? { cardToken }
  var value: String? { cardToken.value }

  init(cardToken: CardToken) {
    self.cardToken = cardToken
  }
}

// MARK: - PaymentMethodItemInstallments
struct PaymentMethodItemInstallments: PaymentMethodsItem {
  private let installments: Installments

  var enabled: Bool { installments.enabled }
  var title: String { installments.name }
  var subtitle: String? { "decision_in_even_15_minutes".localized() }
  var brandImageProvider: BrandImageProvider { installments.brandImageProvider }
  var paymentMethod: PaymentMethod? { installments }
  var value: String? { installments.value }

  init(installments: Installments) {
    self.installments = installments
  }
}

// MARK: - PaymentMethodItemPayByLink
struct PaymentMethodItemPayByLink: PaymentMethodsItem {
  private let payByLink: PayByLink

  var enabled: Bool { payByLink.enabled }
  var title: String { payByLink.name }
  var subtitle: String? { nil }
  var brandImageProvider: BrandImageProvider { payByLink.brandImageProvider }
  var paymentMethod: PaymentMethod? { payByLink }
  var value: String? { payByLink.value }

  init(payByLink: PayByLink) {
    self.payByLink = payByLink
  }
}
