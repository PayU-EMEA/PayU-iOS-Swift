//
//  HTTPHeaders.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

public typealias HTTPHeaders = [String: String]

extension URLRequest {
  mutating func addAuthorizationHTTPHeader(_ token: String?) {
    if let token = token {
      addHTTPHeaders(["Authorization": "Bearer \(token)"])
    }
  }

  mutating func addHTTPHeaders(_ headers: HTTPHeaders?) {
    headers?.forEach { self.setValue($0.value, forHTTPHeaderField: $0.key) }
  }
}
