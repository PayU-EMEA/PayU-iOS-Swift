//
//  SettingsRepository.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation
import PUSDK

final class SettingsRepository {

  // MARK: - Private Properties
  private let database = SettingsDatabase()
  private let themeFactory = ThemeFactory()

  // MARK: - Initialization
  init() {
    if (getEnvironments().isEmpty) {
      let environment = EnvironmentModel.sandbox()
      saveEnvironment(environment)
      setEnvironment(environment)
    }
    setTheme(getTheme())
  }

  // authorization

  func getToken() -> String? {
    return database.token
  }

  func setToken(_ token: String) {
    database.token = token
  }

  // country
  func getAvailableCountryCodes() -> [CountryCode] {
    NSLocale.isoCountryCodes.sorted()
  }

  func getCountryCode() -> CurrencyCode {
    database.countryCode ?? Constants.Locale.defaultCountryCode
  }

  func setCountryCode(_ countryCode: CountryCode) {
    database.countryCode = countryCode
  }


  // currencies

  func getAvailableCurrencyCodes() -> [CurrencyCode] {
    ["PLN", "EUR", "USD", "GBP", "CZK", "RON", "HUF", "HRK", "SEK", "NOK", "DKK", "UAH"].sorted()
  }

  func getCurrencyCode() -> CurrencyCode {
    database.currencyCode ?? Constants.Locale.defaultCurrencyCode
  }

  func setCurrencyCode(_ currencyCode: CurrencyCode) {
    database.currencyCode = currencyCode
    PayU.currencyCode = currencyCode
  }

  // languages

  func getAvailableLanguageCodes() -> [LanguageCode] {
    ["cs", "en", "fr", "de", "hu", "lv", "pl", "ro", "sk", "sl", "es", "uk"].sorted()
  }

  func getLanguageCode() -> LanguageCode {
    database.languageCode ?? Constants.Locale.defaultLanguageCode
  }

  func setLanguageCode(_ languageCode: LanguageCode) {
    database.languageCode = languageCode
    PayU.languageCode = languageCode
  }

  // environments

  func getEnvironments() -> [EnvironmentModel] {
    [EnvironmentModel].decoded(from: database.environments)
  }

  func saveEnvironment(_ environment: EnvironmentModel) {
    var environments = getEnvironments()
    environments.append(environment)
    database.environments = environments.encoded()
  }

  func deleteEnvironment(_ environment: EnvironmentModel) {
    var environments = getEnvironments()
    environments.remove(environment)
    database.environments = environments.encoded()
  }


  // environment

  func getEnvironment() -> EnvironmentModel? {
    return getEnvironments().first(where: { $0.id == database.environment })
  }

  func setEnvironment(_ environment: EnvironmentModel) {
    database.environment = environment.id
    PayU.pos = POS(id: environment.id, environment: environment.environmentType.payU)
  }

  func getTheme() -> Theme {
    guard let theme = database.theme else { return .default }
    return Theme(rawValue: theme) ?? .default
  }

  func setTheme(_ theme: Theme) {
    database.theme = theme.rawValue
    PUTheme.theme = themeFactory.make(theme)
  }

  // feature toggle

  func shouldDisplayHeader() -> Bool {
    database.shouldDisplayHeader ?? true
  }

  func shouldDisplayCardProviders() -> Bool {
    database.shouldDisplayCardProviders ?? true
  }

  func shouldDisplayCardProvidersInTextField() -> Bool {
    database.shouldDisplayCardProvidersInTextField ?? false
  }

  func shouldDisplayTermsAndConditions() -> Bool {
    database.shouldDisplayTermsAndConditions ?? true
  }

  func shouldDisplayExampleCards() -> Bool {
    database.shouldDisplayExampleCards ?? false
  }

  func shouldDisplayScanCardButton() -> Bool {
    database.shouldDisplayScanCardButton ?? true
  }

  func setShouldDisplayHeader(_ value: Bool) {
    database.shouldDisplayHeader = value
  }

  func setShouldDisplayCardProviders(_ value: Bool) {
    database.shouldDisplayCardProviders = value
  }

  func setShouldDisplayCardProvidersInNumberInputField(_ value: Bool) {
    database.shouldDisplayCardProvidersInTextField = value
  }

  func setShouldDisplayTermsAndConditions(_ value: Bool) {
    database.shouldDisplayTermsAndConditions = value
  }

  func setShouldDisplayExampleCards(_ value: Bool) {
    database.shouldDisplayExampleCards = value
  }

  func setShouldDisplayScanCardButton(_ value: Bool) {
    database.shouldDisplayScanCardButton = value
  }
}
