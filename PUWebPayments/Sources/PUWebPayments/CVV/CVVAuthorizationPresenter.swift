//
//  CVVAuthorizationAlertViewControllerPresenter.swift
//  
//  Created by PayU S.A. on 20/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTranslations)
import PUTranslations
#endif

protocol CVVAuthorizationPresenterProtocol {
  func presentCVVAlertViewController(
    from presentingViewController: UIViewController?,
    onConfirm: @escaping (String) -> Void,
    onCancel: @escaping () -> Void
  )
}

class CVVAuthorizationPresenter: NSObject, CVVAuthorizationPresenterProtocol {

  // MARK: - Private Properties
  private var cancelAction: UIAlertAction!
  private var confirmAction: UIAlertAction!
  private var cvvTextField: UITextField!

  private let formatter: TextFormatterProtocol

  // MARK: - Initialization
  init(formatter: TextFormatterProtocol) {
    self.formatter = formatter
    super.init()
  }

  // MARK: - CVVAuthorizationPresenterProtocol
  func presentCVVAlertViewController(
    from presentingViewController: UIViewController?,
    onConfirm: @escaping (String) -> Void,
    onCancel: @escaping () -> Void
  ) {
    let viewController = UIAlertController(
      title: "enter_cvv".localized(),
      message: nil,
      preferredStyle: .alert)

    cancelAction = UIAlertAction(
      title: "cancel".localized(),
      style: .cancel) { _ in
        onCancel()
      }

    confirmAction = UIAlertAction(
      title: "ok".localized(),
      style: .default) { [weak self] _ in
        guard let cvv = self?.cvvTextField.text else { return }
        onConfirm(cvv)
      }

    viewController.addAction(cancelAction)
    viewController.addAction(confirmAction)
    viewController.addTextField { [weak self] textField in
      guard let self = self else { return }
      self.cvvTextField = textField
      self.cvvTextField.placeholder = "cvv_code".localized()
      self.cvvTextField.keyboardType = .numberPad
      self.cvvTextField.delegate = self
    }

    presentingViewController?.present(viewController, animated: true)
  }
}

// MARK: - UITextFieldDelegate
extension CVVAuthorizationPresenter: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return false }
    let editedText = (text as NSString).replacingCharacters(in: range, with: string)
    let cvv = formatter.formatted(editedText)
    confirmAction.isEnabled = cvv.isCVV
    textField.text = cvv
    return false
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
