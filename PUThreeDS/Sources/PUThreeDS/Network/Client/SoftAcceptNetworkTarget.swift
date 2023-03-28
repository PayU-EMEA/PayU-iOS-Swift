//
//  SoftAcceptNetworkTarget.swift
//  
//  Created by PayU S.A. on 16/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUAPI)
import PUAPI
#endif

enum SoftAcceptNetworkTarget {
  case create(SoftAcceptLog)
}

extension SoftAcceptNetworkTarget: NetworkTarget {
  var path: String {
    switch self {
      case .create:
        return "front/logger"
    }
  }

  var httpMethod: String {
    switch self {
      case .create:
        return "POST"
    }
  }

  var httpBody: Data? {
    switch self {
      case .create(let log):
        return try? JSONEncoder().encode(log)
    }
  }

  var httpHeaders: Dictionary<String, String> {
    switch self {
      case .create:
        return ["Content-Type": "application/vnd.payu+json"]
    }
  }
}
