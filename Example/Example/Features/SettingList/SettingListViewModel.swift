//
//  SettingListViewModel.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

protocol SettingListViewModelProtocol {
  func didSelect(_ item: Setting)
  func didSelectCurrencyCode(_ currencyCode: CurrencyCode)
  func didSelectLanguageCode(_ languageCode: LanguageCode)
  func didSelectTheme(_ theme: String)
}

protocol SettingListViewModelDelegate: AnyObject {
  func settingListViewModelDidUpdate(_ viewModel: SettingListViewModel)
  func settingListViewModel(_ viewModel: SettingListViewModel, shouldPresentCountryCodes countryCodes: [CountryCode], selectedCountryCode countryCode: CountryCode)
  func settingListViewModel(_ viewModel: SettingListViewModel, shouldPresentCurrencyCodes currencyCodes: [CurrencyCode], selectedCurrencyCode currencyCode: CurrencyCode)
  func settingListViewModel(_ viewModel: SettingListViewModel, shouldPresentLanguageCodes languageCodes: [LanguageCode], selectedLangaugeCode languageCode: LanguageCode)
  func settingListViewModel(_ viewModel: SettingListViewModel, shouldPresentThemes themes: [String], selectedTheme theme: String)
  func settingListViewModelShouldPresentEnvironments(_ viewModel: SettingListViewModel)
  func settingListViewModelShouldPresentFeatureToggle(_ viewModel: SettingListViewModel)
}

final class SettingListViewModel {

  // MARK: - Public Properties
  weak var delegate: SettingListViewModelDelegate?

  // MARK: - Private Properties
  private let settingsRepository = SettingsRepository()
  private(set) var settings: [Setting] = []

  // MARK: - Initialization
  init() {
    buildSettings()
  }

  // MARK: - Private Methods
  private func buildSettings() {
    settings.removeAll()
    settings.append(.countryCode(settingsRepository.getCountryCode()))
    settings.append(.currencyCode(settingsRepository.getCurrencyCode()))
    settings.append(.languageCode(settingsRepository.getLanguageCode()))
    settings.append(.environment(settingsRepository.getEnvironment()))
    settings.append(.featureToggle)
    settings.append(.theme(settingsRepository.getTheme()))
  }
}

// MARK: - FeatureListViewModelProtocol
extension SettingListViewModel: SettingListViewModelProtocol {
  func didSelect(_ item: Setting) {
    switch item {
      case .countryCode(let countryCode):
        let countryCodes = settingsRepository.getAvailableCountryCodes()
        delegate?.settingListViewModel(self, shouldPresentCountryCodes: countryCodes, selectedCountryCode: countryCode)
      case .currencyCode(let currencyCode):
        let currencyCodes = settingsRepository.getAvailableCurrencyCodes()
        delegate?.settingListViewModel(self, shouldPresentCurrencyCodes: currencyCodes, selectedCurrencyCode: currencyCode)
      case .languageCode(let languageCode):
        let languageCodes = settingsRepository.getAvailableLanguageCodes()
        delegate?.settingListViewModel(self, shouldPresentLanguageCodes: languageCodes, selectedLangaugeCode: languageCode)
      case .environment:
        delegate?.settingListViewModelShouldPresentEnvironments(self)
      case .featureToggle:
        delegate?.settingListViewModelShouldPresentFeatureToggle(self)
      case .theme(let theme):
        delegate?.settingListViewModel(self, shouldPresentThemes: Theme.allCases.map { $0.rawValue }, selectedTheme: theme.rawValue)
    }
  }

  func didSelectEnvironment() {
    buildSettings()
    delegate?.settingListViewModelDidUpdate(self)
  }

  func didSelectCountryCode(_ countryCode: CountryCode) {
    settingsRepository.setCountryCode(countryCode)
    buildSettings()
    delegate?.settingListViewModelDidUpdate(self)
  }

  func didSelectCurrencyCode(_ currencyCode: CurrencyCode) {
    settingsRepository.setCurrencyCode(currencyCode)
    buildSettings()
    delegate?.settingListViewModelDidUpdate(self)
  }

  func didSelectLanguageCode(_ languageCode: LanguageCode) {
    settingsRepository.setLanguageCode(languageCode)
    buildSettings()
    delegate?.settingListViewModelDidUpdate(self)
  }

  func didSelectTheme(_ theme: String) {
    settingsRepository.setTheme(Theme(rawValue: theme)!)
    buildSettings()
    delegate?.settingListViewModelDidUpdate(self)
  }
}
