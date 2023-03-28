//
//  EnvironmentCreateViewModel.swift
//  Example
//
//  Created by PayU S.A. on 22/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

protocol EnvironmentCreateViewModelProtocol {
  func didTapSave()
}

protocol EnvironmentCreateViewModelDataSource: AnyObject {
  func environmentType() -> EnvironmentType?
  func grantType() -> GrantType?
  func clientId() -> String?
  func clientSecret() -> String?
}

protocol EnvironmentCreateViewModelDelegate: AnyObject {
  func environmentCreateViewModelDidComplete(_ viewModel: EnvironmentCreateViewModel)
}

final class EnvironmentCreateViewModel {

  // MARK: - Public Properties
  weak var dataSource: EnvironmentCreateViewModelDataSource?
  weak var delegate: EnvironmentCreateViewModelDelegate?

  // MARK: - Private Properties
  private let repository = SettingsRepository()
}

// MARK: - EnvironmentCreateViewModelProtocol
extension EnvironmentCreateViewModel: EnvironmentCreateViewModelProtocol {
  func didTapSave() {
    guard
      let environmentType = dataSource?.environmentType(),
      let grantType = dataSource?.grantType(),
      let clientId = dataSource?.clientId(),
      let clientSecret = dataSource?.clientSecret(),
      !clientId.isEmpty,
      !clientSecret.isEmpty else { return }

    let environment = EnvironmentModel.create(
      environmentType: environmentType,
      grantType: grantType,
      clientId: clientId,
      clientSecret: clientSecret)

    repository.saveEnvironment(environment)
    repository.setEnvironment(environment)
    delegate?.environmentCreateViewModelDidComplete(self)
  }
}
