//
//  PaymentMethodsCell.swift
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

final class PaymentMethodsCell: UITableViewCell {

  // MARK: - Private Properties
  private let cardView = PUCardView(style: PUTheme.theme.cardTheme.normal)
  private let iconImageView = PUImageView()
  private let titleLabel = PULabel(style: PUTheme.theme.textTheme.subtitle1)
  private let subtitleLabel = PULabel(style: PUTheme.theme.textTheme.bodyText2)

  // MARK: - Content
  struct Content {
    public let title: String?
    public let subtitle: String?
    public let brandImageProvider: BrandImageProvider?

    // MARK: - Initialization
    init(title: String?, subtitle: String?, brandImageProvider: BrandImageProvider?) {
      self.title = title
      self.subtitle = subtitle
      self.brandImageProvider = brandImageProvider
    }
  }

  // MARK: - Initialization
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLayout()
    setupAppearance()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public Methods
  func bind(with content: PaymentMethodsCell.Content) {
    titleLabel.text = content.title
    titleLabel.isHidden = content.title == nil
    subtitleLabel.text = content.subtitle
    subtitleLabel.isHidden = content.subtitle == nil
    iconImageView.brandImageProvider = content.brandImageProvider
  }

  // MARK: - Private Methods
  private func setupAppearance() {
    backgroundColor = .clear
    contentView.backgroundColor = .clear
  }

  // MARK: - Overrides
  override func prepareForReuse() {
    super.prepareForReuse()
    iconImageView.prepareForReuse()
  }
}

// MARK: - Layout
private extension PaymentMethodsCell {
  private func setupLayout() {
    contentView.addSubview(cardView)
    cardView.pinToSuperviewLeft(withConstant: 16.0)
    cardView.pinToSuperviewTop(withConstant: 4.0)
    cardView.pinToSuperviewRight(withConstant: -16.0)
    cardView.pinToSuperviewBottom(withConstant: 4.0)

    let horizontalStackView = UIStackView()
    horizontalStackView.spacing = 16.0
    horizontalStackView.axis = .horizontal
    horizontalStackView.distribution = .fillProportionally
    horizontalStackView.alignment = .center

    cardView.addSubview(horizontalStackView)
    horizontalStackView.pinToSuperviewLeft(withConstant: 16.0)
    horizontalStackView.pinToSuperviewTop(withConstant: 16.0)
    horizontalStackView.pinToSuperviewRight(withConstant: -16.0)
    horizontalStackView.pinToSuperviewBottom(withConstant: 16.0)

    horizontalStackView.addArrangedSubview(iconImageView)
    iconImageView.addWidthConstraint(with: 48.0)
    iconImageView.addHeightConstraint(with: 48.0)

    let verticalStackView = UIStackView()
    verticalStackView.axis = .vertical
    verticalStackView.spacing = 4.0
    verticalStackView.addArrangedSubview(titleLabel)
    verticalStackView.addArrangedSubview(subtitleLabel)
    horizontalStackView.addArrangedSubview(verticalStackView)
  }
}

