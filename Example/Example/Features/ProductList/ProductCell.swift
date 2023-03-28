//
//  ProductCell.swift
//  Example
//
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

class ProductCell: UITableViewCell, Cell {

  // MARK: - Private Properties
  private let stepper = UIStepper()
  private var viewModel: ProductViewModel!

  // MARK: - Initialization
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.accessoryView = stepper
    self.setupAppearance()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public Methods
  func bind(with viewModel: ProductViewModel) {
    self.viewModel = viewModel

    if #available(iOS 14.0, *) {
      var configuration = UIListContentConfiguration.cell()
      configuration.text = viewModel.formattedTitle()
      configuration.secondaryText = viewModel.formattedPrice()
      self.contentConfiguration = configuration
    } else {
      self.textLabel?.text = viewModel.formattedTitle()
      self.detailTextLabel?.text = viewModel.formattedPrice()
    }

    stepper.value = Double(viewModel.product.quantity)
  }

  // MARK: - Private Methods
  private func setupAppearance() {
    stepper.addTarget(self, action: #selector(actionStepperValueDidChange(_:)), for: .valueChanged)
  }

  // MARK: - Actions
  @objc private func actionStepperValueDidChange(_ sender: Any) {
    viewModel.didUpdateQuantity(Int(stepper.value))
    bind(with: viewModel)
  }
}


