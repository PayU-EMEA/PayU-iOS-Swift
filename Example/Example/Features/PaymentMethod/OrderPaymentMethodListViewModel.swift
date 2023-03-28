//
//  OrderPaymentMethodListViewModel.swift
//  Example
//
//  Created by PayU S.A. on 30/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import PUSDK
import UIKit

protocol OrderPaymentMethodViewModelDelegate: AnyObject {
  func orderPaymentMethodViewModelDidUpdate(_ viewModel: OrderPaymentMethodViewModel)
  func orderPaymentMethodViewModel(_ viewModel: OrderPaymentMethodViewModel, shouldPresentPaymentMethods configuration: PaymentMethodsConfiguration)
}

protocol OrderPaymentMethodViewModelPresenter: AnyObject {
  var presenterViewController: UIViewController? { get }
}

final class OrderPaymentMethodViewModel {

  // MARK: - Public Properties
  weak var delegate: OrderPaymentMethodViewModelDelegate?
  weak var presenter: OrderPaymentMethodViewModelPresenter?
  private(set) var items: [OrderPaymentMethodListItem] = []

  // MARK: - Private Properties
  private let dataRepository = DataRepository()
  private let orderRepository = OrderRepository()
  private let settingsRepository = SettingsRepository()

  private lazy var paymentMethodsProcessor = PaymentMethodsProcessor.Factory().make()
  private lazy var orderCreateResponseProcessor = OrderPaymentMethodListProcessor(presentingViewController: presenter?.presenterViewController)

  // MARK: - Initialization
  init() {
    paymentMethodsProcessor.applePayPaymentRequestProvider = self
    paymentMethodsProcessor.blikAuthorizationCodePresenter = self
    setupOrderPaymentMethodListItems()
  }

  // MARK: - Public Methods
  func canCreateOrder() -> Bool {
    return orderRepository.paymentMethod != nil
  }

  func didSelectItem(_ item: OrderPaymentMethodListItem) {
    switch item {
      case .openPaymentMethods:
        navigateToPaymentMethods()
    }
  }

  func didSelectPaymentMethod(_ paymentMethod: PaymentMethod) {
    orderRepository.didUpdateProductMethod(paymentMethod)
    setupOrderPaymentMethodListItems()
  }

  func didTapCreateOrder() {
    processPaymentMethod()
  }

    // MARK: - Private Methods
  private func processPaymentMethod() {
    guard let paymentMethod = orderRepository.paymentMethod else { return }
    paymentMethodsProcessor.process(
      paymentMethod: paymentMethod,
      onDidProcess: onDidProcess,
      onDidFail: onDidFail)
  }

  private func createOrder(payMethod: PayMethod) {
    guard let clientId = settingsRepository.getEnvironment()?.clientId else { return }

    let currencyCode = settingsRepository.getCurrencyCode()
    let products = orderRepository.products

    let orderCreateRequest = OrderCreateRequest.build(
      clientId: clientId,
      currencyCode: currencyCode,
      payMethod: payMethod,
      products: products)

    dataRepository.createOrder(
      orderCreateRequest: orderCreateRequest,
      completionHandler: { [weak self] result in
        guard let self = self else { return }
        switch result {
          case .success(let orderCreateResponse):
            self.orderCreateResponseProcessor.process(orderCreateResponse)
          case .failure(let error):
            print("[OrderPaymentMethodViewModel] error: \(error)")
        }
      }
    )
  }

  // MARK: - Private Methods
  private func setupOrderPaymentMethodListItems() {
    items.removeAll()
    let paymentMethod = orderRepository.paymentMethod
    items.append(.openPaymentMethods(paymentMethod))
    delegate?.orderPaymentMethodViewModelDidUpdate(self)
  }

  private func navigateToPaymentMethods() {
    dataRepository.getPaymentMethods { [weak self] result in
      guard let self = self else { return }

      switch result {
        case .success(let response):
          let configuration = PaymentMethodsConfiguration(
            blikTokens: response.blikTokens,
            cardTokens: response.cardTokens,
            payByLinks: response.payByLinks)

          self.delegate?.orderPaymentMethodViewModel(self, shouldPresentPaymentMethods: configuration)
        case .failure(let error):
          print("[OrderPaymentMethodViewModel] error: \(error)")
      }
    }
  }

  // MARK: - Handlers
  private func onDidProcess(_ payMethod: PayMethod) {
    Console.console.log(payMethod)
    createOrder(payMethod: payMethod)
  }

  private func onDidFail(_ error: Error) {
    Console.console.log(error)
  }
}

// MARK: - PaymentMethodsProcessorApplePayPaymentRequestProvider
extension OrderPaymentMethodViewModel: PaymentMethodsProcessorApplePayPaymentRequestProvider {
  func paymentRequest() -> PaymentRequest {
    let shippingContact = PaymentRequest.Contact(emailAddress: Constants.Buyer.email)

    var paymentSummaryItems: [PaymentRequest.SummaryItem] = []

    paymentSummaryItems.append(contentsOf: orderRepository.products.map { PaymentRequest.SummaryItem(label: $0.name, amount: UInt($0.price)) })
    paymentSummaryItems.append(PaymentRequest.SummaryItem(label: "Order", amount: UInt(orderRepository.products.map { $0.price }.reduce(0, +)) ))

    return PaymentRequest(
      countryCode: settingsRepository.getCountryCode(),
      currencyCode: settingsRepository.getCurrencyCode(),
      merchantIdentifier: Constants.ApplePay.merchantIdentifier,
      paymentSummaryItems: paymentSummaryItems,
      shippingContact: shippingContact)
  }
}

// MARK: - PaymentMethodsProcessorBlikAuthorizationCodePresenter
extension OrderPaymentMethodViewModel: PaymentMethodsProcessorBlikAuthorizationCodePresenter {
  func presentingViewController() -> UIViewController? {
    presenter?.presenterViewController
  }
}
