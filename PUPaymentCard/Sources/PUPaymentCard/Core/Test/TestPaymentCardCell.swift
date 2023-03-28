//
//  TestPaymentCardCell.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

final class TestPaymentCardCell: UITableViewCell {

  // MARK: - Private Properties
  private let cardView = PUCardView(style: PUTheme.theme.cardTheme.normal)
  private let iconImageView = PUImageView()
  private let titleLabel = PULabel(style: PUTheme.theme.textTheme.subtitle1)
  private let subtitleLabel = PULabel(style: PUTheme.theme.textTheme.bodyText2)

  // MARK: - Content
  struct Content {
    public let title: String?
    public let subtitle: String?

    // MARK: - Initialization
    init(title: String?, subtitle: String?) {
      self.title = title
      self.subtitle = subtitle
    }
  }

  // MARK: - Initialization
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public Methods
  func bind(with content: TestPaymentCardCell.Content) {
    if #available(iOS 14.0, *) {
      var configuration = UIListContentConfiguration.cell()
      configuration.text = content.title
      configuration.secondaryText = content.subtitle
      self.contentConfiguration = configuration
    } else {
      self.textLabel?.text = content.title
      self.detailTextLabel?.text = content.subtitle
    }
  }

  // MARK: - Overrides
  override func prepareForReuse() {
    super.prepareForReuse()
    iconImageView.prepareForReuse()
  }
}
