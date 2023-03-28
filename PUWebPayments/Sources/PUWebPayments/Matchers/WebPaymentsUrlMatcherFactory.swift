//
//  WebPaymentsUrlMatcherFactory.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

protocol WebPaymentsUrlMatcherFactoryProtocol {
  func make(for request: WebPaymentsRequest) -> WebPaymentsUrlMatcher
}

struct WebPaymentsUrlMatcherFactory: WebPaymentsUrlMatcherFactoryProtocol {

  // MARK: - WebPaymentsUrlMatcherFactoryProtocol
  func make(for request: WebPaymentsRequest) -> WebPaymentsUrlMatcher {
    switch request.requestType {
      case .payByLink:
        return PayByLinkUrlMatcher(continueUrl: request.continueUrl)
      case .threeDS:
        return ThreeDSUrlMatcher(continueUrl: request.continueUrl)
    }
  }
}
