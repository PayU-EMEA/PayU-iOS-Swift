//
//  ShowDemoPaymentMethodsUseCase.swift
//  Example
//
//  Created by PayU S.A. on 22/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit
import PUSDK

final class ShowDemoPaymentMethodsUseCase {
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
    let viewController = PaymentMethodsViewController
      .Factory()
      .make(
        configuration: PaymentMethodsConfiguration(
          blikTokens: response.blikTokens,
          cardTokens: response.cardTokens,
          payByLinks: response.payByLinks),
        storage: PaymentMethodsDatabase.database)

    presenter?.navigationController?.pushViewController(viewController, animated: true)
    viewController.delegate = self
  }
}

// MARK: - PaymentMethodsViewControllerDelegate
extension ShowDemoPaymentMethodsUseCase: PaymentMethodsViewControllerDelegate {
  func viewController(_ viewController: PaymentMethodsViewController, didSelect paymentMethod: PaymentMethod) {
    viewController.navigationController?.popViewController(animated: true)
    presenter?.dialog(title: "ShowDemoPaymentMethodsUseCase", message: paymentMethod.formattedDescription)
    Console.console.log(paymentMethod)
  }

  func viewController(_ viewController: PaymentMethodsViewController, didDelete paymentMethod: PaymentMethod) {
    repository.deletePaymentMethod(token: paymentMethod.value) { Console.console.log($0) }
  }
}
