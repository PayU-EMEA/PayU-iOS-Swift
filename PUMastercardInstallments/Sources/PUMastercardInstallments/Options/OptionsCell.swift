//
//  OptionsCell.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

final class OptionsCell: UITableViewCell {

  // MARK: - Private Properties
  private let iconImageView = PUImageView()
  private let titleLabel = PULabel(style: PUTheme.theme.textTheme.bodyText1)
  private let accessoryPrefixLabel = PULabel(style: PUTheme.theme.textTheme.bodyText2)
  private let accessoryTitleLabel = PULabel(style: PUTheme.theme.textTheme.bodyText1)
  private let accessorySubtitleLabel = PULabel(style: PUTheme.theme.textTheme.bodyText2)

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
  func bind(with item: OptionsItem) {
    titleLabel.text = item.title
    accessoryPrefixLabel.text = item.accessoryPrefix
    accessoryTitleLabel.text = item.accessoryTitle
    accessorySubtitleLabel.text = item.accessorySubtitle
    iconImageView.brandImageProvider = .calendar
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
private extension OptionsCell {
  private func setupLayout() {
    let cardView = PUCardView(style: PUTheme.theme.cardTheme.normal)
    contentView.addSubview(cardView)
    cardView.pinToSuperviewLeft(withConstant: 16.0)
    cardView.pinToSuperviewTop(withConstant: 4.0)
    cardView.pinToSuperviewRight(withConstant: -16.0)
    cardView.pinToSuperviewBottom(withConstant: 4.0)

    let horizontalStackView = UIStackView()
    horizontalStackView.spacing = 8.0
    horizontalStackView.axis = .horizontal
    horizontalStackView.distribution = .fill
    horizontalStackView.alignment = .center

    cardView.addSubview(horizontalStackView)
    horizontalStackView.pinToSuperviewLeft(withConstant: 16.0)
    horizontalStackView.pinToSuperviewTop(withConstant: 16.0)
    horizontalStackView.pinToSuperviewRight(withConstant: -16.0)
    horizontalStackView.pinToSuperviewBottom(withConstant: 16.0)

    horizontalStackView.addArrangedSubview(iconImageView)
    iconImageView.addWidthConstraint(with: 48.0)
    iconImageView.addHeightConstraint(with: 48.0)

    horizontalStackView.addArrangedSubview(titleLabel)
    horizontalStackView.addArrangedSubview(UIView())

    let accessoryHorizontalStackView = UIStackView()
    accessoryHorizontalStackView.axis = .horizontal
    accessoryHorizontalStackView.alignment = .center
    accessoryHorizontalStackView.spacing = 4.0
    accessoryHorizontalStackView.addArrangedSubview(accessoryPrefixLabel)
    accessoryHorizontalStackView.addArrangedSubview(accessoryTitleLabel)

    let accessoryVerticalStackView = UIStackView()
    accessoryVerticalStackView.axis = .vertical
    accessoryVerticalStackView.alignment = .trailing
    accessoryVerticalStackView.spacing = 4.0
    accessoryVerticalStackView.addArrangedSubview(accessoryHorizontalStackView)
    accessoryVerticalStackView.addArrangedSubview(accessorySubtitleLabel)

    horizontalStackView.addArrangedSubview(accessoryVerticalStackView)
  }
}
