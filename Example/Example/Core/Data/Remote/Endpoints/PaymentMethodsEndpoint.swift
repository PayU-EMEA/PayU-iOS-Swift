//
//  PaymentMethodsEndpoint.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation
import PUAPI
import PUCore

enum PaymentMethodsEndpoint {
  case getPaymentMethods
  case deletePaymentMethod(String)
}

extension PaymentMethodsEndpoint: HTTPEndpoint {
  var baseURL: URL {
    let configuration = NetworkClientConfiguration(environment: PayU.pos.environment)

    return configuration.baseUrl
  }

  var path: String {
    switch self {
      case .getPaymentMethods:
        return "api/v2_1/paymethods"
      case .deletePaymentMethod(let token):
        return "api/v2_1/tokens/\(token)"
    }
  }

  var method: HTTPMethod {
    switch self {
      case .getPaymentMethods:
        return .get
      case .deletePaymentMethod:
        return .delete
    }
  }

  var task: HTTPTask {
    switch self {
      case .getPaymentMethods:
        return .request
      case .deletePaymentMethod:
        return .request
    }
  }

  var headers: HTTPHeaders {
    switch self {
      case .getPaymentMethods:
        return [:]
      case .deletePaymentMethod:
        return [:]
    }
  }
}
