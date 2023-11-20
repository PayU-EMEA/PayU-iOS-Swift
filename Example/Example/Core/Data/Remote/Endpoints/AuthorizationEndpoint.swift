//
//  AuthorizationEndpoint.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation
import PUAPI
import PUCore

enum AuthorizationEndpoint {
  case authorize(AuthorizationBody)
}

extension AuthorizationEndpoint: HTTPEndpoint {
  var baseURL: URL {
    let configuration = NetworkClientConfiguration(environment: PayU.pos.environment)

    return configuration.baseUrl
  }
  
  var path: String {
    switch self {
      case .authorize(_):
        return "pl/standard/user/oauth/authorize"
    }
  }
  
  var method: HTTPMethod {
    switch self {
      case .authorize:
        return .post
    }
  }
  
  var task: HTTPTask {
    switch self {
      case .authorize(let body):
        return .requestParameters(body: nil, url: body)
    }
  }
  
  var headers: HTTPHeaders {
    switch self {
      case .authorize:
        return [:]
    }
  }
}
