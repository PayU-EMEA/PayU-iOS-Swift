//
//  ShowDemoPaymentMethodsWidgetUseCase.swift
//  Example
//
//  Created by PayU S.A. on 23/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit
import PUSDK

final class ShowDemoPaymentMethodsWidgetUseCase {
  private let repository = DataRepository()
  private weak var presenter: UIViewController?

  init(presenter: UIViewController? = nil) {
    self.presenter = presenter
  }

  func execute() {
    repository.getPaymentMethods { [weak self] result in
      switch result {
        case .success(let response):
          self?.navigate(response: response)
        case .failure(let error):
          self?.presenter?.dialog(message: error.localizedDescription)
      }
    }
  }

  private func navigate(response: PaymentMethodsResponse) {
    let viewController = DemoPaymentMethodsWidgetViewController(
      configuration: PaymentMethodsConfiguration(
        blikTokens: response.blikTokens,
        cardTokens: response.cardTokens,
        payByLinks: response.payByLinks))
    presenter?.navigationController?.pushViewController(viewController, animated: true)
  }
}
