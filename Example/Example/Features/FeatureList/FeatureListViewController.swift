//
//  FeatureListViewController.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

final class FeatureListViewController: ListViewController<ListViewCell>, FeatureListViewModelDelegate, FeatureListViewModelPresenter {

  // MARK: - Private Properties
  private let viewModel: FeatureListViewModel

  // MARK: - Initialization
  required init() {
    self.viewModel = FeatureListViewModel()
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBasics()
    setupViewModel()
  }

  // MARK: - Private Methods
  private func setupBasics() {
    title = "Features"
    navigationItem.rightBarButtonItem = UIBarButtonItem.settings(target: self, action: #selector(actionSettings(_:)))
  }

  private func setupViewModel() {
    viewModel.delegate = self
    viewModel.presenter = self
  }

  // MARK: - Actions
  @objc private func actionSettings(_ sender: Any) {
    viewModel.didTapSettings()
  }

  // MARK: - Overrides
  override func numberOfRows(in section: Int) -> Int {
    return viewModel.features.count
  }

  override func content(at indexPath: IndexPath) -> ListViewCell.Content {
    return ListViewCell.Content(
      title: viewModel.features[indexPath.row].title,
      subtitle: viewModel.features[indexPath.row].subtitle,
      accessoryType: .disclosureIndicator)
  }

  override func didSelectRow(at indexPath: IndexPath) {
    viewModel.didSelect(viewModel.features[indexPath.row])
  }

  // MARK: - FeatureListViewModelDelegate
  func featureListViewModelShouldNavigateToSettings(_ viewModel: FeatureListViewModelProtocol) {
    let viewController = SettingListViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }

  // MARK: - FeatureListViewModelPresenter
  var presenterViewController: UIViewController? {
    return self
  }
}
