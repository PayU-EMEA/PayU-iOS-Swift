//
//  URLParametersEncoder.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

struct URLParametersEncoder: HTTPParametersEncoder {
  let encoder: JSONEncoder

  func encode(request: inout URLRequest, with parameters: HTTPParameters) throws {
    let data = try encoder.encode(parameters)
    let encodedParameters = try JSONSerialization.jsonObject(with: data) as! [String:Any]

    var components = URLComponents()
    components.queryItems = encodedParameters.map {
      URLQueryItem(name: $0.key, value: "\($0.value)")
    }
    
    request.httpBody = components.query?.data(using: .utf8)
    request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
  }
}
