//
//  PBLPaymentMethodsCell.swift
//  
//  Created by PayU S.A. on 28/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

final class PBLPaymentMethodsCell: UICollectionViewCell {

  // MARK: - Private Properties
  private let cardView = PUCardView(style: PUTheme.theme.cardTheme.normal)
  private let iconImageView = PUImageView()

  // MARK: - Content
  struct Content {

    // MARK: - Public Properties
    let brandImageProvider: BrandImageProvider?

    // MARK: - Initializatio
    init(brandImageProvider: BrandImageProvider?) {
      self.brandImageProvider = brandImageProvider
    }
  }

  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
    setupAppearance()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public Methods
  public func bind(with content: Content) {
    iconImageView.brandImageProvider = content.brandImageProvider
  }

  // MARK: - Overrides
  public override func prepareForReuse() {
    super.prepareForReuse()
    iconImageView.prepareForReuse()
  }

  // MARK: - Private Methods
  private func setupAppearance() {
    backgroundColor = .clear
    contentView.backgroundColor = .clear
  }

}

private extension PBLPaymentMethodsCell {
  func setupLayout() {
    contentView.addSubview(cardView)
    cardView.pinToSuperviewEdges()

    cardView.addSubview(iconImageView)
    iconImageView.clipsToBounds = true
    iconImageView.pinToSuperviewLeft(withConstant: 16.0)
    iconImageView.pinToSuperviewTop(withConstant: 16.0)
    iconImageView.pinToSuperviewRight(withConstant: -16.0)
    iconImageView.pinToSuperviewBottom(withConstant: 16.0)
  }
}
