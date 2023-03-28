//
//  SettingsDatabase.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

class SettingsDatabase {
  @Database(key: "countryCode")
  var countryCode: CountryCode?

  @Database(key: "currencyCode")
  var currencyCode: CurrencyCode?

  @Database(key: "languageCode")
  var languageCode: LanguageCode?

  @Database(key: "environments")
  var environments: Data?

  @Database(key: "environment")
  var environment: String?

  @Database(key: "theme")
  var theme: String?

  @Database(key: "token")
  var token: String?

  @Database(key: "PaymentCard.shouldDisplayHeader")
  var shouldDisplayHeader: Bool?

  @Database(key: "PaymentCard.shouldDisplayCardProviders")
  var shouldDisplayCardProviders: Bool?

  @Database(key: "PaymentCard.shouldDisplayCardProvidersInTextField")
  var shouldDisplayCardProvidersInTextField: Bool?

  @Database(key: "PaymentCard.shouldDisplayTermsAndConditions")
  var shouldDisplayTermsAndConditions: Bool?

  @Database(key: "PaymentCard.shouldDisplayExampleCards")
  var shouldDisplayExampleCards: Bool?

  @Database(key: "PaymentCard.shouldDisplayScanCardButton")
  var shouldDisplayScanCardButton: Bool?
}
