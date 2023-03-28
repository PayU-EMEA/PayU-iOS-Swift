//
//  ThreeDSUrlMatcher.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct ThreeDSUrlMatcher: WebPaymentsUrlMatcher, Equatable {

  // MARK: - Private Properties
  private let statusCodes: [String: WebPaymentsUrlMatcherResult] = [
    "SUCCESS": .success,
    "WARNING_CONTINUE_3DS": .continue3DS,
    "WARNING_CONTINUE_CVV": .continueCvv,
    "ERROR_SYNTAX": .failure,
    "ERROR_VALUE_INVALID": .failure,
    "ERROR_VALUE_MISSING": .failure,
    "UNAUTHORIZED": .failure,
    "UNAUTHORIZED_REQUEST": .failure,
    "DATA_NOT_FOUND": .failure,
    "TIMEOUT": .failure,
    "BUSINESS_ERROR": .failure,
    "ERROR_INTERNAL": .failure,
    "GENERAL_ERROR": .failure,
    "WARNING": .failure,
    "SERVICE_NOT_AVAILABLE": .failure
  ]

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
    if !matchStatusCode(redirectUrl) { return .notMatched }

    guard let statusCode = redirectUrl.components?.queryItem("statusCode")?.value else { return .notMatched }
    return statusCodes[statusCode] ?? .notMatched
  }
}
