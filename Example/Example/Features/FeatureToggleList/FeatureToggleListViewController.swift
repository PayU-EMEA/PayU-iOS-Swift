//
//  FeatureToggleListViewController.swift
//  Example
//
//  Created by PayU S.A. on 15/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

final class FeatureToggleListViewController: ListViewController<FeatureToggleCell> {

  // MARK: - Private Properties
  private let viewModel: FeatureToggleListViewModel

  // MARK: - Initialization
  required init() {
    self.viewModel = FeatureToggleListViewModel()
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBasics()
  }

  // MARK: - Private Methods
  private func setupBasics() {
    title = "Feature Toggle"
  }

  // MARK: - Overrides
  override func numberOfRows(in section: Int) -> Int {
    return viewModel.toggles.count
  }

  override func content(at indexPath: IndexPath) -> FeatureToggleCell.Content {
    return FeatureToggleCell.Content(
      title: viewModel.toggles[indexPath.row].title,
      subtitle: viewModel.toggles[indexPath.row].subtitle,
      isEnabled: viewModel.isEnabled(at: indexPath),
      onChanged: { [weak self] isEnabled in self?.viewModel.didSelect(at: indexPath) })
  }

  override func didSelectRow(at indexPath: IndexPath) {
    viewModel.didSelect(at: indexPath)
  }
}
