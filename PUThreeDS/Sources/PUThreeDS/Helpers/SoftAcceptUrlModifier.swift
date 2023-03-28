//
//  SoftAcceptUrlModifier.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct SoftAcceptUrlModifier {

  // MARK: - Public Methods
  func modify(_ redirectUrl: URL) -> URL {
    guard var components = URLComponents(url: redirectUrl, resolvingAgainstBaseURL: true) else { return redirectUrl }
    components.appendURLQueryItem(URLQueryItem(name: "sendCreq", value: "false"))
    return components.url ?? redirectUrl
  }
}
