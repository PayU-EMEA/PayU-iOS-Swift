//
//  PaymentMethodsAssembler.swift
//  
//  Created by PayU S.A. on 12/01/2023.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUApplePay)
import PUApplePay
#endif

#if canImport(PUCore)
import PUCore
#endif

struct PaymentMethodsAssembler {

  func makeApplePayService() -> ApplePayServiceProtocol {
    ApplePayServiceFactory().make()
  }

  func makeBlikAlertViewControllerPresenter() -> BlikAlertViewControllerPresenterProtocol {
    BlikAlertViewControllerPresenter(formatter: makePaymentMethodsWidgetFormatter())
  }

  func makePaymentMethodsFactory() -> PaymentMethodsItemFactoryProtocol {
    PaymentMethodsItemFactory()
  }

  func makePaymentMethodsProcessor() -> PaymentMethodsProcessor {
    PaymentMethodsProcessor(
      applePayService: makeApplePayService(),
      blikAlertViewControllerPresenter: makeBlikAlertViewControllerPresenter())
  }

  func makePaymentMethodsService(storage: PaymentMethodsStorageProtocol? = nil) -> PaymentMethodsServiceProtocol {
    PaymentMethodsService(
      factory: makePaymentMethodsFactory(),
      storage: storage)
  }

  func makePaymentMethodsViewModel(
    configuration: PaymentMethodsConfiguration,
    storage: PaymentMethodsStorageProtocol?
  ) -> PaymentMethodsViewModel {
    PaymentMethodsViewModel(
      configuration: configuration,
      service: makePaymentMethodsService(storage: storage),
      storage: storage)
  }

  func makePaymentMethodsWidgetFormatter() -> TextFormatterProtocol {
    TextFormatterFactory().makeBlik()
  }

  func makePaymentMethodsWidgetViewModel(
    configuration: PaymentMethodsConfiguration,
    storage: PaymentMethodsStorageProtocol?
  ) -> PaymentMethodsWidgetViewModel {
    PaymentMethodsWidgetViewModel(
      configuration: configuration,
      storage: storage,
      textFormatter: makePaymentMethodsWidgetFormatter())
  }

  func makePBLPaymentMethodsViewModel(configuration: PaymentMethodsConfiguration) -> PBLPaymentMethodsViewModel {
    PBLPaymentMethodsViewModel(
      configuration: configuration,
      service: makePaymentMethodsService())
  }
}
