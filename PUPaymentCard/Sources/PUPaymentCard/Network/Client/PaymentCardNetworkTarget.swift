//
//  PaymentCardNetworkTarget.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUAPI)
import PUAPI
#endif

enum PaymentCardNetworkTarget {
  case tokenize(TokenCreateRequest)
}

extension PaymentCardNetworkTarget: NetworkTarget {
  var path: String {
    switch self {
      case .tokenize:
        return "api/v2/token/token.json"
    }
  }

  var httpMethod: String {
    switch self {
      case .tokenize:
        return "POST"
    }
  }

  var httpBody: Data? {
    switch self {
      case .tokenize(let tokenCreateRequest):
        let tokenCreateRequestData = try! JSONEncoder().encode(tokenCreateRequest)
        let tokenCreateRequestDataString = String(data: tokenCreateRequestData, encoding: .utf8)!
        let formattedTokenCreateRequestDataString = "data=\(tokenCreateRequestDataString)"
        return formattedTokenCreateRequestDataString.data(using: .utf8)
    }
  }

  var httpHeaders: Dictionary<String, String> {
    switch self {
      case .tokenize:
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
  }
}
