//
//  WebPaymentsUrlMather.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

protocol WebPaymentsUrlMatcher {
  func result(_ url: URL) -> WebPaymentsUrlMatcherResult

  func matchAboutBlank(_ url: URL) -> Bool
  func matchExternalScheme(_ url: URL) -> Bool
  func matchStatusCode(_ url: URL) -> Bool
  func matchContinueUrl(_ url: URL, _ continueUrl: URL) -> Bool
  func matchContinueUrlWithError(_ url: URL) -> Bool
}

extension WebPaymentsUrlMatcher {
  func matchAboutBlank(_ url: URL) -> Bool {
    return url.absoluteString == "about:blank"
  }

  func matchExternalScheme(_ url: URL) -> Bool {
    guard let urlComponents = url.components else { return false }
    return !urlComponents.isHTTP() && !urlComponents.isHTTPS()
  }

  func matchStatusCode(_ url: URL) -> Bool {
    guard let urlComponents = url.components else { return false }
    return urlComponents.queryItems?.contains(where: { $0.name == "statusCode" }) ?? false
  }

  func matchContinueUrl(_ url: URL, _ continueUrl: URL) -> Bool {
    guard let urlComponents = url.components else { return false }
    guard let continueUrlComponents = continueUrl.components else { return false }

    guard let urlScheme = urlComponents.scheme else { return false }
    guard let continueUrlScheme = continueUrlComponents.scheme else { return false }

    guard let urlHost = urlComponents.host else { return false }
    guard let continueUrlHost = continueUrlComponents.host else { return false }

    return urlScheme == continueUrlScheme && urlHost == continueUrlHost
  }

  func matchContinueUrlWithError(_ url: URL) -> Bool {
    guard let urlComponents = url.components else { return false }
    return urlComponents.hasQueryItem("error") || urlComponents.hasQueryItem("failure")
  }
}
