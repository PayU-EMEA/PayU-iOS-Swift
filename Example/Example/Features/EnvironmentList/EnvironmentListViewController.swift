//
//  EnvironmentListViewController.swift
//  Example
//
//  Created by PayU S.A. on 22/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

protocol EnvironmentListViewControllerDelegate: AnyObject {
  func environmentListViewControllerDidComplete(_ viewController: EnvironmentListViewController)
}

final class EnvironmentListViewController: ListViewController<ListViewCell>, EnvironmentListViewModelDelegate, EnvironmentCreateViewControllerDelegate {

  // MARK: - Public Properties
  weak var delegate: EnvironmentListViewControllerDelegate?

  // MARK: - Private Properties
  private let viewModel: EnvironmentListViewModel

  // MARK: - Initialization
  required init() {
    self.viewModel = EnvironmentListViewModel()
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
    title = "Environments"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(actionCreate))
  }

  private func setupViewModel() {
    viewModel.delegate = self
  }

  // MARK: - Actions
  @objc private func actionCreate(_ sender: Any) {
    viewModel.didTapCreateEnvironment()
  }

  // MARK: - Overrides
  override func numberOfRows(in section: Int) -> Int {
    return viewModel.environments.count
  }

  override func canDeleteRow(at indexPath: IndexPath) -> Bool {
    return viewModel.environments[indexPath.row] != viewModel.environment
  }

  override func content(at indexPath: IndexPath) -> ListViewCell.Content {
    let environment = viewModel.environments[indexPath.row]
    return ListViewCell.Content(
      title: environment.environmentType.rawValue,
      subtitle: [
        environment.grantType.rawValue,
        environment.clientId.limited(10),
        environment.clientSecret.limited(10)]
        .compactMap { $0 }.joined(separator: " · "),
      accessoryType: environment == viewModel.environment ? .checkmark : .none)
  }

  override func didSelectRow(at indexPath: IndexPath) {
    viewModel.didSelect(viewModel.environments[indexPath.row])
  }

  override func didDeleteRow(at indexPath: IndexPath) {
    viewModel.didDelete(viewModel.environments[indexPath.row])
  }

  // MARK: - EnvironmentListViewModelDelegate
  func environmentListViewModelDidUpdate(_ viewModel: EnvironmentListViewModel) {
    performUpdates()
  }

  func environmentListViewModelDidComplete(_ viewModel: EnvironmentListViewModel) {
    delegate?.environmentListViewControllerDidComplete(self)
  }

  func environmentListViewModelShouldPresentEnvironmentCreate(_ viewModel: EnvironmentListViewModel) {
    let viewController = EnvironmentCreateViewController()
    navigationController?.pushViewController(viewController, animated: true)
    viewController.delegate = self
  }

  // MARK: - EnvironmentCreateViewControllerDelegate
  func environmentCreateViewControllerDidComplete(_ viewController: EnvironmentCreateViewController) {
    viewController.navigationController?.popViewController(animated: true)
    viewModel.didCreateEnvironment()
  }
}
