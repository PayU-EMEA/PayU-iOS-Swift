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
        return "api/front/tokens"
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
        return try? JSONEncoder().encode(tokenCreateRequest)
    }
  }

  var httpHeaders: Dictionary<String, String> {
    switch self {
      case .tokenize:
        return ["Content-Type": "application/json"]
    }
  }
}
