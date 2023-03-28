//
//  PaymentCardServicePresenter.swift
//  
//  Created by PayU S.A. on 08/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUPaymentCardScanner)
import PUPaymentCardScanner
#endif

#if canImport(PUTheme)
import PUTheme
#endif

protocol PaymentCardServicePresenterProtocol {
  func presentPaymentCardScannerViewController(
    option: PaymentCardScannerOption,
    presentingViewController: UIViewController,
    onComplete: @escaping (PaymentCardScannerResult) -> Void
  )
}

final class PaymentCardServicePresenter: PaymentCardServicePresenterProtocol {

  // MARK: - Private Properties
  private weak var presentingViewController: UIViewController?
  private var onComplete: ((PaymentCardScannerResult) -> Void)?

  // MARK: - PaymentCardServicePresenterProtocolProtocol
  func presentPaymentCardScannerViewController(
    option: PaymentCardScannerOption,
    presentingViewController: UIViewController,
    onComplete: @escaping (PaymentCardScannerResult) -> Void
  ) {
    self.presentingViewController = presentingViewController
    self.onComplete = onComplete

    if #available(iOS 13.0, *) {
      let viewController = PaymentCardScannerViewController.Factory().make(option: option)
      let navigationController = PortraitNavigationController(rootViewController: viewController)
      presentingViewController.present(navigationController, animated: true)
      viewController.delegate = self
    }
  }

  // MARK: - Private Methods
  private func dialog(title: String? = nil, message: String?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel))
    presentingViewController?.present(alertController, animated: true)
  }
}

// MARK: - PaymentCardScannerViewControllerDelegate
@available(iOS 13.0, *)
extension PaymentCardServicePresenter: PaymentCardScannerViewControllerDelegate {
  func paymentCardScannerViewController(_ viewController: PaymentCardScannerViewController, didProcess result: PaymentCardScannerResult) {
    viewController.navigationController?.dismiss(animated: true) { [weak self] in
      self?.onComplete?(result)
    }
  }

  func paymentCardScannerViewController(_ viewController: PaymentCardScannerViewController, didFail error: Error) {
    viewController.navigationController?.dismiss(animated: true) { [weak self] in
      self?.dialog(message: error.localizedDescription)
    }
  }

  func paymentCardScannerViewControllerDidCancel(_ viewController: PaymentCardScannerViewController) {
    viewController.navigationController?.dismiss(animated: true)
  }
}
