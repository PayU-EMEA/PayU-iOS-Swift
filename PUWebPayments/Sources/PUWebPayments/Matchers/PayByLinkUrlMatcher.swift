//
//  PayByLinkUrlMatcher.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct PayByLinkUrlMatcher: WebPaymentsUrlMatcher, Equatable {
  
  // MARK: - Private Properties
  private let creditProviderUrls: [String] = [
    // production
    "wniosek.santanderconsumer.pl",
    "pardapu.inbank.pl",
    "smartney.pl",
    "raty.aliorbank.pl",
    "form.mbank.pl",
    "ewniosek.credit-agricole.pl",
    // sandbox
    "bank-simulator-merch-prod.snd.payu.com/simulator/spring/sandbox/utf8/installment",
    // sandbox-beta
    "smartneydevweb.z6.web.core.windows.net",
    "demo-pardapu.inbank.pl"
  ]

  // MARK: - Public Properties
  let continueUrl: URL

  // MARK: - Initialization
  init(continueUrl: URL) {
    self.continueUrl = continueUrl
  }

  // MARK: - WebPaymentsUrlMather
  func result(_ redirectUrl: URL) -> WebPaymentsUrlMatcherResult {
    if matchCreditProviderUrl(redirectUrl) { return .creditExternalApplication }
    if matchAboutBlank(redirectUrl) { return .notMatched }
    if matchExternalScheme(redirectUrl) { return .externalApplication }
    if !matchContinueUrl(redirectUrl, continueUrl) { return .notMatched }
    if matchContinueUrlWithError(redirectUrl) { return .failure }

    return .success
  }
  
  // MARK: - Private Methods
  private func matchCreditProviderUrl(_ redirectUrl: URL) -> Bool {
    for providerUrl in self.creditProviderUrls {
        if (redirectUrl.absoluteString.contains(providerUrl)) {
            return true
        }
    }
    return false
  }
}
