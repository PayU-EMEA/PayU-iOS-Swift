//
//  NetworkTarget.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

public protocol NetworkTarget {
  var path: String { get }
  var httpMethod: String { get }
  var httpBody: Data? { get }
  var httpHeaders: Dictionary<String, String> { get }
}
