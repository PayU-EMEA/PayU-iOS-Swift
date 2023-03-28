//
//  URLComponents+QueryItem.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

extension URLComponents {
  mutating func appendURLQueryItem(_ queryItem: URLQueryItem) {
    var queryItems = queryItems ??  []
    queryItems.append(queryItem)
    self.queryItems = queryItems
  }
}
