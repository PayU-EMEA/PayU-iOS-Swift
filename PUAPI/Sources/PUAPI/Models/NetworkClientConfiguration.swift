//
//  NetworkClientConfiguration.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

public struct NetworkClientConfiguration {

  // MARK: - Public Properties
  public let baseUrl: URL

  // MARK: - Initialization
  public init(environment: Environment) {
    switch environment {
      case .production:
        self.init(baseUrl: URL(string: "https://mobilesdk.secure.payu.com")!)
      case .sandbox:
        self.init(baseUrl: URL(string: "https://secure.snd.payu.com")!)
      case .sandboxBeta:
        self.init(baseUrl: URL(string: "https://secure.sndbeta.payu.com")!)
    }
  }

  private init(baseUrl: URL) {
    self.baseUrl = baseUrl
  }
}
