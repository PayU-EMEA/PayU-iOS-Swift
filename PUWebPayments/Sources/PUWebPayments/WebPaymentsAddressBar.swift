//
//  WebPaymentsAddressBar.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

final class WebPaymentsAddressBar: UIView {

  // MARK: - Public Properties
  var isSecure: Bool? {
    didSet {
      imageView.tintColor = isSecure == true
      ? PUTheme.theme.colorTheme.primary2
      : PUTheme.theme.colorTheme.tertiary2
    }
  }

  var url: URL? {
    didSet {
      addressLabel.text = url?.absoluteString
    }
  }

  // MARK: - Private Properties
  private let imageView: PUImageView = {
    let imageView = PUImageView(brandImageProvider: .lock)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let addressLabel: UILabel = {
    let label = UILabel()
    label.apply(style: PUTheme.theme.textTheme.bodyText2)
    return label
  }()

  // MARK: - Overrides
  override var intrinsicContentSize: CGSize {
    return CGSize(
      width: super.intrinsicContentSize.width,
      height: 44.0)
  }

  // MARK: - Initialization
  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - Layout
private extension WebPaymentsAddressBar {
  func setupLayout() {

    addSubview(imageView)
    imageView.pinToSuperviewLeft(withConstant: 16.0)
    imageView.addWidthConstraint(with: 16.0)
    imageView.addHeightConstraint(with: 16.0)
    imageView.centerYToSuperview()

    addSubview(addressLabel)
    addressLabel.pinLeft(to: imageView, anchor: .right, constant: 8.0)
    addressLabel.pinToSuperviewRight(withConstant: -16.0)
    addressLabel.centerYToSuperview()
  }
}
