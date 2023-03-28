//
//  PaymentCardProviderView.swift
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

final class PaymentCardProviderView: UIView {

  // MARK: - Public Properties
  let paymentCardProvider: PaymentCardProvider
  var isSelected: Bool = false {
    didSet {
      self.alpha = isSelected ? 1 : 0.15
    }
  }

  // MARK: - Private Properties
  private let imageView: PUImageView

  // MARK: - Initialization
  required init(paymentCardProvider: PaymentCardProvider) {
    self.paymentCardProvider = paymentCardProvider
    self.imageView = PUImageView(brandImageProvider: paymentCardProvider.brandImageProvider)
    super.init(frame: .zero)

    addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.pinToSuperviewEdges()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}


