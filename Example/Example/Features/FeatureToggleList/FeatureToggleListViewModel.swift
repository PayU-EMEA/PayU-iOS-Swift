//
//  FeatureToggleListViewModel.swift
//  Example
//
//  Created by PayU S.A. on 15/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

final class FeatureToggleListViewModel {

  // MARK: - Private Properties
  private let settingsRepository = SettingsRepository()
  private(set) var toggles: [FeatureToggle] = []

  // MARK: - Initialization
  init() {
    toggles.append(.paymentCardShouldDisplayHeader(settingsRepository.shouldDisplayHeader()))
    toggles.append(.paymentCardShouldDisplayCardProviders(settingsRepository.shouldDisplayCardProviders()))
    toggles.append(.paymentCardShouldDisplayCardProvidersInNumberInputField(settingsRepository.shouldDisplayCardProvidersInTextField()))
    toggles.append(.paymentCardShouldDisplayTermsAndConditions(settingsRepository.shouldDisplayTermsAndConditions()))
    toggles.append(.paymentCardShouldDisplayExampleCards(settingsRepository.shouldDisplayExampleCards()))
    toggles.append(.paymentCardShouldDisplayScanCardButton(settingsRepository.shouldDisplayScanCardButton()))
  }

  // MARK: - Public Methods
  func isEnabled(at indexPath: IndexPath) -> Bool {
    switch toggles[indexPath.row] {
      case .paymentCardShouldDisplayHeader(let isEnabled):
        return isEnabled
      case .paymentCardShouldDisplayCardProviders(let isEnabled):
        return isEnabled
      case .paymentCardShouldDisplayCardProvidersInNumberInputField(let isEnabled):
        return isEnabled
      case .paymentCardShouldDisplayTermsAndConditions(let isEnabled):
        return isEnabled
      case .paymentCardShouldDisplayExampleCards(let isEnabled):
        return isEnabled
      case .paymentCardShouldDisplayScanCardButton(let isEnabled):
        return isEnabled
    }
  }

  func didSelect(at indexPath: IndexPath) {
    switch toggles[indexPath.row] {
      case .paymentCardShouldDisplayHeader(let isEnabled):
        settingsRepository.setShouldDisplayHeader(!isEnabled)
      case .paymentCardShouldDisplayCardProviders(let isEnabled):
        settingsRepository.setShouldDisplayCardProviders(!isEnabled)
      case .paymentCardShouldDisplayCardProvidersInNumberInputField(let isEnabled):
        settingsRepository.setShouldDisplayCardProvidersInNumberInputField(!isEnabled)
      case .paymentCardShouldDisplayTermsAndConditions(let isEnabled):
        settingsRepository.setShouldDisplayTermsAndConditions(!isEnabled)
      case .paymentCardShouldDisplayExampleCards(let isEnabled):
        settingsRepository.setShouldDisplayExampleCards(!isEnabled)
      case .paymentCardShouldDisplayScanCardButton(let isEnabled):
        settingsRepository.setShouldDisplayScanCardButton(!isEnabled)
    }
  }
}
