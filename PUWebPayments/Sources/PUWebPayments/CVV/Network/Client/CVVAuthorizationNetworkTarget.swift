//
//  CVVAuthorizationNetworkTarget.swift
//  
//  Created by PayU S.A. on 20/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUAPI)
import PUAPI
#endif

enum CVVAuthorizationNetworkTarget {
  case authorizeCVV(CVVAuthorizationRequest)
}

extension CVVAuthorizationNetworkTarget: NetworkTarget {
  var path: String {
    switch self {
      case .authorizeCVV:
        return "api/v2/token/token.json"
    }
  }

  var httpMethod: String {
    switch self {
      case .authorizeCVV:
        return "POST"
    }
  }

  var httpBody: Data? {
    switch self {
      case .authorizeCVV(let cvvAuthorizationRequest):
        let cvvAuthorizationRequestData = try! JSONEncoder().encode(cvvAuthorizationRequest)
        let cvvAuthorizationRequestDataString = String(data: cvvAuthorizationRequestData, encoding: .utf8)!
        let formattedCVVAuthorizationRequestDataString = "data=\(cvvAuthorizationRequestDataString)"
        return formattedCVVAuthorizationRequestDataString.data(using: .utf8)
    }
  }

  var httpHeaders: Dictionary<String, String> {
    switch self {
      case .authorizeCVV:
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
  }
}
