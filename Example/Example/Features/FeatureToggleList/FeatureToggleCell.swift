//
//  FeatureToggleCell.swift
//  Example
//
//  Created by PayU S.A. on 15/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

class FeatureToggleCell: UITableViewCell, Cell {

  // MARK: - Private Properties
  private let switcher = UISwitch()
  private var content: Content!

  // MARK: - Content
  struct Content {
    let title: String
    let subtitle: String
    let isEnabled: Bool
    let onChanged: (Bool) -> Void

    init(title: String, subtitle: String, isEnabled: Bool, onChanged: @escaping (Bool) -> Void) {
      self.title = title
      self.subtitle = subtitle
      self.isEnabled = isEnabled
      self.onChanged = onChanged
    }
  }

  // MARK: - Initialization
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.accessoryView = switcher
    self.setupAppearance()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public Methods
  func bind(with content: Content) {
    self.content = content

    if #available(iOS 14.0, *) {
      var configuration = UIListContentConfiguration.cell()
      configuration.text = content.title
      configuration.secondaryText = content.subtitle
      self.contentConfiguration = configuration
    } else {
      self.textLabel?.text = content.title
      self.detailTextLabel?.text = content.subtitle
    }

    switcher.isOn = content.isEnabled
  }

  // MARK: - Private Methods
  private func setupAppearance() {
    switcher.addTarget(self, action: #selector(actionSwitcherValueDidChange(_:)), for: .valueChanged)
  }

  // MARK: - Actions
  @objc private func actionSwitcherValueDidChange(_ sender: Any) {
    content.onChanged(switcher.isOn)
  }
}


