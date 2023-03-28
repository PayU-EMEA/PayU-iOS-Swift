//
//  ShowDemoPaymentCardScannerUseCase.swift
//  Example
//
//  Created by PayU S.A. on 08/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//  

import UIKit
import PUSDK

final class ShowDemoPaymentCardScannerUseCase {
  private weak var presenter: UIViewController?
  private let settingsRepository = SettingsRepository()

  init(presenter: UIViewController? = nil) {
    self.presenter = presenter
  }

  func execute() {
    if #available(iOS 13.0, *) {
      let viewController = PaymentCardScannerViewController.Factory().make(option: .numberAndDate)
      let navigationController = PortraitNavigationController(rootViewController: viewController)
      presenter?.present(navigationController, animated: true)
      viewController.delegate = self
    } else {
      presenter?.dialog(title: "PaymentCardScanner", message: "This feature is available from iOS 13.0")
    }
  }
}

// MARK: - PaymentCardScannerViewControllerDelegate
@available(iOS 13.0, *)
extension ShowDemoPaymentCardScannerUseCase: PaymentCardScannerViewControllerDelegate {
  func paymentCardScannerViewController(_ viewController: PaymentCardScannerViewController, didProcess result: PaymentCardScannerResult) {
    Console.console.log(result)
    viewController.navigationController?.dismiss(animated: true) { [weak self] in
      self?.presenter?.dialog(
        title: "ShowDemoPaymentCardScannerUseCase",
        message: [result.cardNumber, result.cardExpirationDate]
          .compactMap { $0 }
          .joined(separator: "\n"))
    }
  }

  func paymentCardScannerViewController(_ viewController: PaymentCardScannerViewController, didFail error: Error) {
    Console.console.log(error)
    viewController.navigationController?.dismiss(animated: true) { [weak self] in
      self?.presenter?.dialog(
        title: "ShowDemoPaymentCardScannerUseCase",
        message: error.localizedDescription)
    }
  }

  func paymentCardScannerViewControllerDidCancel(_ viewController: PaymentCardScannerViewController) {
    Console.console.log()
    viewController.navigationController?.dismiss(animated: true) { [weak self] in
      self?.presenter?.dialog(
        title: "ShowDemoPaymentCardScannerUseCase",
        message: "paymentCardScannerViewControllerDidCancel")
    }
  }
}
