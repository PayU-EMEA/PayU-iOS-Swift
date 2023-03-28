//
//  ListViewCell.swift
//  Example
//
//  Created by PayU S.A. on 22/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

protocol Cell {
  associatedtype Content

  func bind(with content: Content)
}

class ListViewCell: UITableViewCell, Cell  {

  // MARK: - Content
  struct Content {
    let title: String?
    let subtitle: String?
    let accessoryType: UITableViewCell.AccessoryType

    init(title: String?, subtitle: String? = nil, accessoryType: UITableViewCell.AccessoryType = .none) {
      self.title = title
      self.subtitle = subtitle
      self.accessoryType = accessoryType
    }
  }

  // MARK: - Public Methods
  func bind(with content: ListViewCell.Content) {
    if #available(iOS 14.0, *) {
      var configuration = UIListContentConfiguration.cell()
      configuration.text = content.title
      configuration.secondaryText = content.subtitle
      self.contentConfiguration = configuration
    } else {
      self.textLabel?.text = content.title
      self.detailTextLabel?.text = content.subtitle
    }
    self.accessoryType = content.accessoryType
  }
}
