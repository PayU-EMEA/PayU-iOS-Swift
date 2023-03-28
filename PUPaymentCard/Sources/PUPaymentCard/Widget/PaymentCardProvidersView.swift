//
//  PaymentCardProvidersView.swift
//  
//  Created by PayU S.A. on 07/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

final class PaymentCardProvidersView: UIView {

  // MARK: - Public Properties
  public var paymentCardProvider: PaymentCardProvider? {
    didSet {
      UIView.animate(
        withDuration: 0.15,
        animations: {
          self
            .paymentCardProvidersViews
            .forEach { $0.isSelected = self.paymentCardProvider == $0.paymentCardProvider }
        }
      )
    }
  }

  // MARK: - Overrides
  override var intrinsicContentSize: CGSize {
    return CGSize(
      width: super.intrinsicContentSize.width,
      height: 48.0)
  }

  // MARK: - Private Properties
  private var paymentCardProvidersViews: [PaymentCardProviderView] = []

  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)

    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 16.0
    stackView.distribution = .fillEqually
    stackView.alignment = .center

    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

    PaymentCardProvider.all
      .map { makeProviderView($0) }
      .forEach {
        stackView.addArrangedSubview($0)
        paymentCardProvidersViews.append($0)
      }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods
  func makeProviderView(_ paymentCardProvider: PaymentCardProvider) -> PaymentCardProviderView {
    let imageView = PaymentCardProviderView(paymentCardProvider: paymentCardProvider)
    imageView.isSelected = self.paymentCardProvider == paymentCardProvider
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
    return imageView
  }
}
