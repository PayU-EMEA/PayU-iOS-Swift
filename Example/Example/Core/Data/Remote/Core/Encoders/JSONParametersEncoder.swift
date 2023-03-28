//
//  JSONParametersEncoder.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

struct JSONParametersEncoder: HTTPParametersEncoder {
  let encoder: JSONEncoder

  func encode(request: inout URLRequest, with parameters: HTTPParameters) throws {
    do {
      request.httpBody = try encoder.encode(parameters)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    } catch {
      throw error
    }
  }
}
