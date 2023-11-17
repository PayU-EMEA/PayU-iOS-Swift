//
//  OrdersEndpoint.swift
//  Example
//
//  Created by PayU S.A. on 30/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

enum OrdersEndpoint {
  case createOrder(OrderCreateRequest)
}

extension OrdersEndpoint: HTTPEndpoint {
  var baseURL: URL {
    return URL(string: "https://secure.sndbeta.payu.com")!
  }

  var path: String {
    switch self {
      case .createOrder(_):
        return "api/v2_1/orders"
    }
  }

  var method: HTTPMethod {
    switch self {
      case .createOrder:
        return .post
    }
  }

  var task: HTTPTask {
    switch self {
      case .createOrder(let orderCreateRequest):
        return .requestParameters(body: orderCreateRequest, url: nil)
    }
  }

  var headers: HTTPHeaders {
    switch self {
      case .createOrder:
        return [:]
    }
  }
}
