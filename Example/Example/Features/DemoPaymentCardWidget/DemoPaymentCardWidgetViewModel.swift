//
//  DemoPaymentCardWidgetViewModel.swift
//  Example
//
//  Created by PayU S.A. on 15/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation
import PUSDK

protocol DemoPaymentCardWidgetViewModelDelegate: AnyObject {
  func demoPaymentCardWidgetViewModel(_ viewModel: DemoPaymentCardWidgetViewModel, didComplete cardToken: CardToken)
  func demoPaymentCardWidgetViewModel(_ viewModel: DemoPaymentCardWidgetViewModel, didFail error: Error)
}

final class DemoPaymentCardWidgetViewModel {

  // MARK: - Public Properties
  weak var delegate: DemoPaymentCardWidgetViewModelDelegate?

  // MARK: - Private Properties
  private let settingRepository = SettingsRepository()
  private(set) var configuration: PaymentCardWidget.Configuration
  private(set) var service: PaymentCardServiceProtocol

  // MARK: - Initialization
  init(service: PaymentCardServiceProtocol) {
    self.configuration = PaymentCardWidget.Configuration(
      shouldDisplayHeader: settingRepository.shouldDisplayHeader(),
      shouldDisplayCardProviders: settingRepository.shouldDisplayCardProviders(),
      shouldDisplayCardProvidersInTextField: settingRepository.shouldDisplayCardProvidersInTextField(),
      shouldDisplayTermsAndConditions: settingRepository.shouldDisplayTermsAndConditions(),
      cvvDecoration: PaymentCardWidget.Configuration.Decoration.cvv.copyWith(labelText: "Where to find CVV?")
    )
    self.service = service
  }

  // MARK: - Public Methods
  func tokenize(type: TokenType) {
    Console.console.log(type.rawValue)
    service.tokenize(type: type) { [weak self] result in
      guard let self = self else { return }

      switch result {
        case .success(let cardToken):
          self.delegate?.demoPaymentCardWidgetViewModel(self, didComplete: cardToken)
        case .failure(let error):
          self.delegate?.demoPaymentCardWidgetViewModel(self, didFail: error)
      }
    }
  }
}

