//
//  SoftAcceptQueryParameterExtractor.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct SoftAcceptQueryParameterExtractor {
  
  // MARK: - Public Methods
  func extractAuthenticationId(_ url: URL) -> String? {
    return extractQueryParameter(url, "authenticationId")
  }
  
  // MARK: - Private Methods
  func extractQueryParameter(_ url: URL, _ name: String) -> String? {
    return URLComponents(url: url, resolvingAgainstBaseURL: false)?
      .queryItems?
      .first(where: { $0.name == name })?
      .value
  }
}
