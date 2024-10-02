//
//  PaymentMethodsService.swift
//
//  Copyright © PayU S.A. All rights reserved.
//

#if canImport(PUCore)
import PUCore
#endif

protocol PaymentMethodsServiceProtocol {
  func makePaymentMethodItems(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem]
  func makePayByLinksPaymentMethodItems(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem]
  func getSavedPaymentMethod(for configuration: PaymentMethodsConfiguration) -> PaymentMethod?
}

struct PaymentMethodsService: PaymentMethodsServiceProtocol {

  // MARK: - Private Properties
  private let factory: PaymentMethodsItemFactoryProtocol
  private let storage: PaymentMethodsStorageProtocol?

  // MARK: - Initialization
  init(factory: PaymentMethodsItemFactoryProtocol, storage: PaymentMethodsStorageProtocol?) {
    self.factory = factory
    self.storage = storage
  }

  // MARK: - PaymentMethodsServiceProtocol
  func makePaymentMethodItems(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem] {
    var items: [PaymentMethodsItem] = []
    items.append(contentsOf: makeApplePay(for: configuration))
    items.append(contentsOf: makeBlikCode(for: configuration))
    items.append(contentsOf: makeBlikTokens(for: configuration))
    items.append(contentsOf: makeCardTokens(for: configuration))
    items.append(contentsOf: makeCard(for: configuration))
    items.append(contentsOf: makeBankTransfer(for: configuration))
    items.append(contentsOf: makeInstallments(for: configuration))

    guard let storage = storage else { return items }
    guard let value = storage.getSelectedPaymentMethodValue() else { return items }
    items.append(contentsOf: makePayByLinks(for: configuration).filter { $0.value == value })

    if let index = items.firstIndex(where: { $0.value == value }) {
      let item = items[index]
      items.remove(at: index)
      items.insert(item, at: 0)
    }

    return items
  }

  func makePayByLinksPaymentMethodItems(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem] {
    var items: [PaymentMethodsItem] = []
    items.append(contentsOf: makePayByLinks(for: configuration))
    return items
  }

  func getSavedPaymentMethod(for configuration: PaymentMethodsConfiguration) -> PaymentMethod? {
    var paymentMethod: PaymentMethod? = nil

    if let storedMethod = storage?.getSelectedPaymentMethodValue() {
      var items: [PaymentMethodsItem] = []

      items.append(contentsOf: makeAll(for: configuration))
      items.append(contentsOf: makeBlikCode(for: configuration))
      items.append(contentsOf: makeBlikTokens(for: configuration))
      items.append(contentsOf: makeCardTokens(for: configuration))

      paymentMethod = items.filter { $0.value == storedMethod }.first?.paymentMethod

    }

    return paymentMethod
  }

  // MARK: - Private Methods
  private func makeApplePay(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem] {
    configuration.payByLinks
      .filter { isApplePayPayByLink($0) }
      .map { ApplePay(payByLink: $0) }
      .compactMap { factory.item($0) }
  }

  private func makeBlikCode(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem] {
    guard let blikTokens = configuration.blikTokens, blikTokens.isEmpty else { return [] }
    return [BlikCode()].compactMap { factory.item($0) }
  }

  private func makeBlikTokens(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem] {
    guard let blikTokens = configuration.blikTokens, !blikTokens.isEmpty else { return [] }
    return blikTokens.compactMap { factory.item($0) }
  }

  private func makeCardTokens(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem] {
    configuration.cardTokens.compactMap { factory.item($0) }
  }

  private func makeCard(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem] {
    guard configuration.enableAddCard else { return [] }
    return [PaymentMethodItemCard()]
  }

  private func makeBankTransfer(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem] {
    guard configuration.enablePayByLinks else { return [] }
    let enabled = configuration.enablePayByLinks
    return [PaymentMethodItemBankTransfer(enabled: enabled)]
  }

  private func makeInstallments(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem] {
    configuration.payByLinks
      .filter { isInstallmentsPayByLink($0) }
      .map { Installments(payByLink: $0) }
      .compactMap { factory.item($0) }
  }

  private func makePayByLinks(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem] {
    guard configuration.enablePayByLinks else { return [] }

    return configuration.payByLinks
      .filter { isAllowedPayByLink($0) }
      .compactMap { factory.item($0) }
  }

  private func makeAll(for configuration: PaymentMethodsConfiguration) -> [PaymentMethodsItem] {
    guard configuration.enablePayByLinks else { return [] }

    return configuration.payByLinks
      .filter { !isProhibitedPayByLink($0) }
      .compactMap { factory.item($0) }
  }

  private func isAllowedPayByLink(_ value: PayByLink) -> Bool {
    !isApplePayPayByLink(value) &&
    !isInstallmentsPayByLink(value) &&
    !isProhibitedPayByLink(value)
  }

  private func isApplePayPayByLink(_ value: PayByLink) -> Bool {
    value.value == PaymentMethodValue.applePay
  }

  private func isInstallmentsPayByLink(_ value: PayByLink) -> Bool {
    value.value == PaymentMethodValue.installments
  }

  private func isProhibitedPayByLink(_ value: PayByLink) -> Bool {
    [PaymentMethodValue.googlePay].contains(value.value)
  }
}
