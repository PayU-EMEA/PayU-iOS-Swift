//
//  ShowDemoPaymentCardWidgetUseCase.swift
//  Example
//
//  Created by PayU S.A. on 15/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit
import PUSDK

final class ShowDemoPaymentCardWidgetUseCase {
  private weak var presenter: UIViewController?
  
  init(presenter: UIViewController? = nil) {
    self.presenter = presenter
  }
  
  func execute() {
    let viewController = DemoPaymentCardWidgetViewController()
    presenter?.navigationController?.pushViewController(viewController, animated: true)
    viewController.delegate = self
  }
}

// MARK: - DemoPaymentCardWidgetViewControllerDelegate
extension ShowDemoPaymentCardWidgetUseCase: DemoPaymentCardWidgetViewControllerDelegate {
  func demoPaymentCardWidgetViewController(_ viewController: DemoPaymentCardWidgetViewController, didComplete cardToken: CardToken) {
    viewController.navigationController?.popViewController(animated: true)
    presenter?.dialog(title: "ShowDemoPaymentCardWidgetUseCase", message: cardToken.value)
    Console.console.log(cardToken)
  }
}
