//
//  CVVAuthorizationNetworkTarget.swift
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
    case .authorizeCVV(let cvvAuthorizationRequest):
      return "api/front/card-authorizations/\(cvvAuthorizationRequest.refReqId)/cvv"
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
      return cvvAuthorizationRequest.cvv.data(using: .utf8)
    }
  }

  var httpHeaders: [String: String] {
    switch self {
    case .authorizeCVV:
      return ["Content-Type": "application/json"]
    }
  }
}
