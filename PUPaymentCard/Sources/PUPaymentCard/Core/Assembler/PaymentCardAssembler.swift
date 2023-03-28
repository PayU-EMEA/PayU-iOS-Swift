//
//  PaymentCardAssembler.swift
//  
//  Created by PayU S.A. on 07/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUAPI)
import PUAPI
#endif

#if canImport(PUCore)
import PUCore
#endif

struct PaymentCardAssembler {

  func makeNetworkClient() -> NetworkClient {
    NetworkClient.Factory().make()
  }

  func makePaymentCardDateParser() -> PaymentCardDateParserProtocol {
    PaymentCardDateParserFactory().make()
  }

  func makePaymentCardFormatterCVV() -> PaymentCardFormatterProtocol {
    PaymentCardFormatterFactory().makeCVV()
  }

  func makePaymentCardFormatterDate() -> PaymentCardFormatterProtocol {
    PaymentCardFormatterFactory().makeDate()
  }

  func makePaymentCardFormatterNumber() -> PaymentCardFormatterProtocol {
    PaymentCardFormatterFactory().makeNumber()
  }

  func makePaymentCardNetworkClient() -> PaymentCardNetworkClientProtocol {
    PaymentCardNetworkClient(client: makeNetworkClient())
  }

  func makePaymentCardLuhnValidator() -> PaymentCardLuhnValidatorProtocol {
    PaymentCardLuhnValidatorFactory().make()
  }

  func makePaymentCardProviderFinder() -> PaymentCardProviderFinderProtocol {
    PaymentCardProviderFinderFactory().make(luhnValidator: makePaymentCardLuhnValidator())
  }

  func makePaymentCardRepository() -> PaymentCardRepositoryProtocol {
    PaymentCardRepository(
      client: makePaymentCardNetworkClient(),
      finder: makePaymentCardProviderFinder())
  }

  func makePaymentCardService() -> PaymentCardServiceProtocol {
    PaymentCardService(
      cvvValidator: makePaymentCardValidatorCVV(),
      dateValidator: makePaymentCardValidatorDate(),
      numberValidator: makePaymentCardValidatorNumber(),
      finder: makePaymentCardProviderFinder(),
      presenter: makePaymentCardServicePresenter(),
      repository: makePaymentCardRepository())
  }

  func makePaymentCardServicePresenter() -> PaymentCardServicePresenterProtocol {
    PaymentCardServicePresenter()
  }

  func makePaymentCardValidatorCVV() -> PaymentCardValidatorProtocol {
    PaymentCardValidatorFactory().makeCVV()
  }

  func makePaymentCardValidatorDate() -> PaymentCardValidatorProtocol {
    PaymentCardValidatorFactory().makeDate(dateParser: makePaymentCardDateParser())
  }

  func makePaymentCardValidatorNumber() -> PaymentCardValidatorProtocol {
    PaymentCardValidatorFactory().makeNumber(providerFinder: makePaymentCardProviderFinder())
  }

  func makePaymentCardViewController(configuration: PaymentCardViewController.Configuration) -> PaymentCardViewController {
    PaymentCardViewController(
      configuration: configuration,
      viewModel: makePaymentCardViewModel())
  }

  func makePaymentCardViewModel() -> PaymentCardViewModel {
    PaymentCardViewModel(service: makePaymentCardService())
  }

  func makePaymentCardWidget(configuration: PaymentCardWidget.Configuration, service: PaymentCardServiceProtocol) -> PaymentCardWidget {
    PaymentCardWidget(
      configuration: configuration,
      service: service,
      paymentCardFormatterCVV: makePaymentCardFormatterCVV(),
      paymentCardFormatterDate: makePaymentCardFormatterDate(),
      paymentCardFormatterNumber: makePaymentCardFormatterNumber(),
      paymentCardValidatorCVV: makePaymentCardValidatorCVV(),
      paymentCardValidatorDate: makePaymentCardValidatorDate(),
      paymentCardValidatorNumber: makePaymentCardValidatorNumber())
  }

  func makeTestPaymentCardsViewController() -> TestPaymentCardsViewController {
    TestPaymentCardsViewController(viewModel: makeTestPaymentCardsViewModel())
  }

  func makeTestPaymentCardsViewModel() -> TestPaymentCardsViewModel {
    TestPaymentCardsViewModel()
  }

}
