//
//  TermsAndConditionsView.swift
//  
//  Created by PayU S.A. on 19/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

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

public final class TermsAndConditionsView: UIView {

  // MARK: - Initialization
  public required init() {
    super.init(frame: .zero)
    setupAppearance()
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupAppearance()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Properties
  private func setupAppearance() {
    let prefixText = "i_accept".localized()
    let suffixText = "pay_u_payment_terms".localized()

    let termsAndConditionsText = [prefixText, suffixText].joined(separator: " ")
    let attributedString = NSMutableAttributedString(string: termsAndConditionsText)
    attributedString.addAttributes(makePrefixAttributes(), range: NSMakeRange(0, termsAndConditionsText.count))
    attributedString.addAttributes(makeSuffixAttributes(), range: (termsAndConditionsText as NSString).range(of: suffixText))

    let termsAndConditionsLabel = UILabel()
    termsAndConditionsLabel.isEnabled = true
    termsAndConditionsLabel.isUserInteractionEnabled = true
    termsAndConditionsLabel.attributedText = attributedString

    let tap = UITapGestureRecognizer(target: self, action: #selector(actionTap(_:)))
    termsAndConditionsLabel.addGestureRecognizer(tap)

    addSubview(termsAndConditionsLabel)
    termsAndConditionsLabel.translatesAutoresizingMaskIntoConstraints = false
    termsAndConditionsLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    termsAndConditionsLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    termsAndConditionsLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    termsAndConditionsLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }

  // MARK: - Actions
  @objc private func actionTap(_ sender: Any) {
    if let url = URL(string: "pay_u_payment_terms_url".localized()) {
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
      }
    }
  }

  // MARK: - Private Methods
  private func makePrefixAttributes() -> [NSAttributedString.Key : Any] {
    return [
      .foregroundColor: PUTheme.theme.textTheme.caption.color,
      .font: PUTheme.theme.textTheme.caption.font
    ]
  }

  private func makeSuffixAttributes() -> [NSAttributedString.Key : Any] {
    return [
      .foregroundColor: PUTheme.theme.colorTheme.primary2,
      .font: PUTheme.theme.textTheme.caption.font,
    ]
  }
}
