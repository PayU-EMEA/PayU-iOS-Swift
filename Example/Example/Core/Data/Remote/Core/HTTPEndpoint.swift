//
//  HTTPEndpoint.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

protocol HTTPEndpoint {
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var task: HTTPTask { get }
  var headers: HTTPHeaders { get }
}

