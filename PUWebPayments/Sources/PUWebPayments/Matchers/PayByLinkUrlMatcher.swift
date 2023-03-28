//
//  PayByLinkUrlMatcher.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct PayByLinkUrlMatcher: WebPaymentsUrlMatcher, Equatable {

  // MARK: - Public Properties
  let continueUrl: URL

  // MARK: - Initialization
  init(continueUrl: URL) {
    self.continueUrl = continueUrl
  }

  // MARK: - WebPaymentsUrlMather
  func result(_ redirectUrl: URL) -> WebPaymentsUrlMatcherResult {
    if matchAboutBlank(redirectUrl) { return .notMatched }
    if matchExternalScheme(redirectUrl) { return .externalApplication }
    if !matchContinueUrl(redirectUrl, continueUrl) { return .notMatched }
    if matchContinueUrlWithError(redirectUrl) { return .failure }

    return .success
  }
}
