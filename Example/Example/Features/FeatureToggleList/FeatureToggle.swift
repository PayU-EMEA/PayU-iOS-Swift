//
//  FeatureToggle.swift
//  Example
//
//  Created by PayU S.A. on 15/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

enum FeatureToggle {
  case paymentCardShouldDisplayHeader(Bool)
  case paymentCardShouldDisplayCardProviders(Bool)
  case paymentCardShouldDisplayCardProvidersInNumberInputField(Bool)
  case paymentCardShouldDisplayTermsAndConditions(Bool)

  case paymentCardShouldDisplayExampleCards(Bool)
  case paymentCardShouldDisplayScanCardButton(Bool)
  case enableBlikCode(Bool)
  case mockBlikToken(Bool)

  var title: String {
    switch self {
      case .paymentCardShouldDisplayHeader:
        return "PaymentCardWidget"
      case .paymentCardShouldDisplayCardProviders:
        return "PaymentCardWidget"
      case .paymentCardShouldDisplayCardProvidersInNumberInputField:
        return "PaymentCardWidget"
      case .paymentCardShouldDisplayTermsAndConditions:
        return "PaymentCardWidget"
      case .paymentCardShouldDisplayExampleCards:
        return "PaymentCardViewController"
      case .paymentCardShouldDisplayScanCardButton:
        return "PaymentCardViewController"
      case .enableBlikCode:
        return "EnableBlikCode"
      case .mockBlikToken:
        return "MockBlikToken"
    }
  }

  var subtitle: String {
    switch self {
      case .paymentCardShouldDisplayHeader:
        return "shouldDisplayHeader"
      case .paymentCardShouldDisplayCardProviders:
        return "shouldDisplayCardProviders"
      case .paymentCardShouldDisplayCardProvidersInNumberInputField:
        return "shouldDisplayCardProvidersInNumberInputField"
      case .paymentCardShouldDisplayTermsAndConditions:
        return "shouldDisplayTermsAndConditions"
      case .paymentCardShouldDisplayExampleCards:
        return "shouldDisplayExampleCards"
      case .paymentCardShouldDisplayScanCardButton:
        return "shouldDisplayScanCardButton"
      case .enableBlikCode:
        return "Enable blik code option in payment list if blik is available and no blik tones are stored"
      case .mockBlikToken:
        return "Mock blik token for testing purposes"
    }
  }
}
