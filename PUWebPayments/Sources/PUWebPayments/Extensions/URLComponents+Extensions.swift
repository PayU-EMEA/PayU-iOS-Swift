//
//  URLComponents+Extensions.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

extension URLComponents {
  func isHTTP() -> Bool {
    self.scheme == "http"
  }

  func isHTTPS() -> Bool {
    self.scheme == "https"
  }

  func hasQueryItem(_ name: String) -> Bool {
    queryItems?.contains(where: { $0.name == name }) ?? false
  }

  func queryItem(_ name: String) -> URLQueryItem? {
    queryItems?.first(where: { $0.name == name })
  }
}
