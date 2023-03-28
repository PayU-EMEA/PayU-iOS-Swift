//
//  SettingListViewController.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

final class SettingListViewController: ListViewController<ListViewCell>, SettingListViewModelDelegate, EnvironmentListViewControllerDelegate {

  // MARK: - Private Properties
  private let viewModel: SettingListViewModel

  // MARK: - Initialization
  required init() {
    self.viewModel = SettingListViewModel()
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
    title = "Settings"
  }

  private func setupViewModel() {
    viewModel.delegate = self
  }

  // MARK: - Overrides
  override func numberOfRows(in section: Int) -> Int {
    return viewModel.settings.count
  }

  override func content(at indexPath: IndexPath) -> ListViewCell.Content {
    return ListViewCell.Content(
      title: viewModel.settings[indexPath.row].title,
      subtitle: viewModel.settings[indexPath.row].subtitle,
      accessoryType: .disclosureIndicator)
  }

  override func didSelectRow(at indexPath: IndexPath) {
    viewModel.didSelect(viewModel.settings[indexPath.row])
  }

  // MARK: - SettingListViewModelDelegate
  func settingListViewModelDidUpdate(_ viewModel: SettingListViewModel) {
    performUpdates()
  }

  func settingListViewModel(_ viewModel: SettingListViewModel, shouldPresentCountryCodes countryCodes: [CountryCode], selectedCountryCode countryCode: CountryCode) {
    let arguments = SelectableListViewController<CountryCode>.Arguments(items: countryCodes, selected: countryCode)
    let viewController = SelectableListViewController(arguments: arguments)
    viewController.onSelect = { [weak self] value in self?.viewModel.didSelectCountryCode(value) }
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  func settingListViewModel(_ viewModel: SettingListViewModel, shouldPresentCurrencyCodes currencyCodes: [CurrencyCode], selectedCurrencyCode currencyCode: CurrencyCode) {
    let arguments = SelectableListViewController<CurrencyCode>.Arguments(items: currencyCodes, selected: currencyCode)
    let viewController = SelectableListViewController(arguments: arguments)
    viewController.onSelect = { [weak self] value in self?.viewModel.didSelectCurrencyCode(value) }
    self.navigationController?.pushViewController(viewController, animated: true)
  }


  func settingListViewModel(_ viewModel: SettingListViewModel, shouldPresentLanguageCodes languageCodes: [LanguageCode], selectedLangaugeCode languageCode: LanguageCode) {
    let arguments = SelectableListViewController<LanguageCode>.Arguments(items: languageCodes, selected: languageCode)
    let viewController = SelectableListViewController(arguments: arguments)
    viewController.onSelect = { [weak self] value in self?.viewModel.didSelectLanguageCode(value) }
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  func settingListViewModel(_ viewModel: SettingListViewModel, shouldPresentThemes themes: [String], selectedTheme theme: String) {
    let arguments = SelectableListViewController<String>.Arguments(items: themes, selected: theme)
    let viewController = SelectableListViewController(arguments: arguments)
    viewController.onSelect = { [weak self] value in self?.viewModel.didSelectTheme(value) }
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  func settingListViewModelShouldPresentEnvironments(_ viewModel: SettingListViewModel) {
    let viewController = EnvironmentListViewController()
    navigationController?.pushViewController(viewController, animated: true)
    viewController.delegate = self
  }

  func settingListViewModelShouldPresentFeatureToggle(_ viewModel: SettingListViewModel) {
    let viewController = FeatureToggleListViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }

  // MARK: - EnvironmentListViewControllerDelegate
  func environmentListViewControllerDidComplete(_ viewController: EnvironmentListViewController) {
    viewModel.didSelectEnvironment()
  }
}
