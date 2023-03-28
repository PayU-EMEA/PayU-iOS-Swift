//
//  URL+Extensions.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

extension URL {
  var components: URLComponents? {
    return URLComponents(
      url: self,
      resolvingAgainstBaseURL: true)
  }
}
