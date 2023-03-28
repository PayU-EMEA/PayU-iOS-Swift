//
//  EnvironmentListViewModel.swift
//  Example
//
//  Created by PayU S.A. on 22/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

protocol EnvironmentListViewModelProtocol {
  func didSelect(_ environment: EnvironmentModel)
  func didDelete(_ environment: EnvironmentModel)

  func didTapCreateEnvironment()
  func didCreateEnvironment()
}

protocol EnvironmentListViewModelDelegate: AnyObject {
  func environmentListViewModelDidUpdate(_ viewModel: EnvironmentListViewModel)
  func environmentListViewModelDidComplete(_ viewModel: EnvironmentListViewModel)
  func environmentListViewModelShouldPresentEnvironmentCreate(_ viewModel: EnvironmentListViewModel)
}

final class EnvironmentListViewModel {

  // MARK: - Public Properties
  weak var delegate: EnvironmentListViewModelDelegate?
  var environments: [EnvironmentModel] { repository.getEnvironments() }
  var environment: EnvironmentModel? { repository.getEnvironment() }

  // MARK: - Private Properties
  private let repository = SettingsRepository()
}

// MARK: - EnvironmentListViewModelProtocol
extension EnvironmentListViewModel: EnvironmentListViewModelProtocol {
  func didSelect(_ environment: EnvironmentModel) {
    repository.setEnvironment(environment)
    delegate?.environmentListViewModelDidUpdate(self)
    delegate?.environmentListViewModelDidComplete(self)
  }

  func didDelete(_ environment: EnvironmentModel) {
    repository.deleteEnvironment(environment)
    delegate?.environmentListViewModelDidUpdate(self)
  }

  func didTapCreateEnvironment() {
    delegate?.environmentListViewModelShouldPresentEnvironmentCreate(self)
  }

  func didCreateEnvironment() {
    delegate?.environmentListViewModelDidUpdate(self)
    delegate?.environmentListViewModelDidComplete(self)
  }
}
