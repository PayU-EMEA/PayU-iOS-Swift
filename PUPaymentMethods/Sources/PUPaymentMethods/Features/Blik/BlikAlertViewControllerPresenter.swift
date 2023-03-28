//
//  BlikAlertViewControllerPresenter.swift
//  
//  Created by PayU S.A. on 17/01/2023.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTranslations)
import PUTranslations
#endif

/// Protocol which defines the behavior of ``BlikAlertViewControllerPresenter``
public protocol BlikAlertViewControllerPresenterProtocol {

  /// Call this method when there is a need to display the ``BlikAlertViewControllerPresenter``
  /// - Parameters:
  ///   - presentingViewController: view controller from which you would like to present
  ///   - onDidConfirm: `completionHanlder` which is called when user confirms the inputed BLIK code
  ///   - onDidCancel: `completionHanlder` which is called when user cancelled inputting
  func presentBlikAlertViewController(
    from presentingViewController: UIViewController?,
    onDidConfirm: @escaping (String) -> Void,
    onDidCancel: @escaping () -> Void)
}

/// Allows to present the the UIAlertViewController to force user to input BLIK code
public class BlikAlertViewControllerPresenter: NSObject, BlikAlertViewControllerPresenterProtocol {

  // MARK: - Factory
  /// Factory which allows to create the ``BlikAlertViewControllerPresenter`` instance
  public struct Factory {
    // MARK: - Private Properties
    private let assembler = PaymentMethodsAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Initialization
    /// Returns default implementation for ``BlikAlertViewControllerPresenter``
    /// - Returns: Default implementation for ``BlikAlertViewControllerPresenter``
    public func make() -> BlikAlertViewControllerPresenterProtocol {
      assembler.makeBlikAlertViewControllerPresenter()
    }
  }

  // MARK: - Private Properties
  private var cancelAction: UIAlertAction!
  private var confirmAction: UIAlertAction!
  private var blikAuthorizationCodeTextField: UITextField!

  private let formatter: TextFormatterProtocol

  // MARK: - Initialization
  init(formatter: TextFormatterProtocol) {
    self.formatter = formatter
    super.init()
  }

  // MARK: - Public Methods
  public func presentBlikAlertViewController(
    from presentingViewController: UIViewController?,
    onDidConfirm: @escaping (String) -> Void,
    onDidCancel: @escaping () -> Void) {

      let viewController = UIAlertController(
        title: "BLIK",
        message: "enter_blik_code".localized(),
        preferredStyle: .alert)

      cancelAction = UIAlertAction(
        title: "cancel".localized(),
        style: .cancel,
        handler: { _ in
          onDidCancel()
        }
      )

      confirmAction = UIAlertAction(
        title: "ok".localized(),
        style: .default,
        handler: { [weak self] _ in
          guard let self = self else { return }
          guard let blikAuthorizationCode = self.blikAuthorizationCodeTextField.text else { return }
          onDidConfirm(blikAuthorizationCode)
        }
      )

      viewController.addAction(cancelAction)
      viewController.addAction(confirmAction)
      viewController.addTextField { [weak self] textField in
        guard let self = self else { return }
        self.blikAuthorizationCodeTextField = textField
        self.blikAuthorizationCodeTextField.placeholder = "enter_blik_code".localized()
        self.blikAuthorizationCodeTextField.keyboardType = .numberPad
        self.blikAuthorizationCodeTextField.delegate = self
      }

      presentingViewController?.present(viewController, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension BlikAlertViewControllerPresenter: UITextFieldDelegate {
  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return false }
    let editedText = (text as NSString).replacingCharacters(in: range, with: string)
    let blikAuthorizationCode = formatter.formatted(editedText)
    confirmAction.isEnabled = blikAuthorizationCode.isBlikCode
    textField.text = blikAuthorizationCode
    return false
  }

  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
