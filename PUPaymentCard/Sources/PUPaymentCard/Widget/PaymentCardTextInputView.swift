//
//  PaymentCardTextInputView.swift
//  
//  Created by PayU S.A. on 12/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation
import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

#if canImport(PUTranslations)
import PUTranslations
#endif

final class PaymentCardTextInputView: PUTextField {

  // MARK: - Public Properties
  var onTextDidChange: ((String) -> Void)?
  var onErrorAccessoryTap: (() -> Void)?
  var onHintAccessoryTap: (() -> Void)?
  var nextActiveResponder: PaymentCardTextInputView?

  // MARK: - Private Properties
  private let decoration: PaymentCardWidget.Configuration.Decoration
  private let formatter: PaymentCardFormatterProtocol
  private let validator: PaymentCardValidatorProtocol

  // MARK: - Initialization
  init(
    decoration: PaymentCardWidget.Configuration.Decoration,
    formatter: PaymentCardFormatterProtocol,
    validator: PaymentCardValidatorProtocol) {

    self.decoration = decoration
    self.formatter = formatter
    self.validator = validator
    super.init(frame: .zero)

    self.onErrorAccessoryViewTap = { [weak self] in
      guard let self = self else { return }
      self.onErrorAccessoryTap?()
    }

    self.onHintAccessoryViewTap = { [weak self] in
      guard let self = self else { return }
      self.onHintAccessoryTap?()
    }

    self.setupBottomAccessoryView(error: nil)
    self.placeholder = decoration.hintText.localized()
    self.delegate = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public Methods
  func validate() throws {
    do {
      try validator.validate(text ?? "")
      setupBottomAccessoryView(error: nil)
    } catch {
      let message = error.localizedDescription
      setupBottomAccessoryView(error: message.localized())
      throw error
    }
  }

  // MARK: - Private Methods
  private func setupBottomAccessoryView(error: String?) {
    self.error = error
    self.hint = error == nil ? decoration.labelText : nil
  }
}

// MARK: - UITextFieldDelegate
extension PaymentCardTextInputView: UITextFieldDelegate {
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard let text = textField.text else { return false }
    let editedText = (text as NSString).replacingCharacters(in: range, with: string)
    let formattedText = formatter.formatted(editedText)

    textField.text = formattedText
    onTextDidChange?(formattedText)

    if !editedText.isEmpty && (nextActiveResponder != nil) {
        do {
          try validator.validate(editedText)
          nextActiveResponder?.becomeFirstResponder()
        } catch {
        }
    }

    return false
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    setupBottomAccessoryView(error: nil)
    return true
  }

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    try? validate()
    return true
  }
}
