//
//  SoftAcceptConfiguration.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

struct SoftAcceptConfiguration {

  // MARK: - Constants
  struct Constants {
    static let javascriptChannelName = "javascriptChannelName"
  }

  // MARK: - Factory
  struct Factory {

    // MARK: - Private Properties
    private let environment: Environment

    // MARK: - Initialization
    init(environment: Environment) {
      self.environment = environment
    }

    // MARK: - Public Methods
    func make() -> SoftAcceptConfiguration {
      switch environment {
        case .production:
          return SoftAcceptConfiguration(origin: "'https://secure.payu.com'")
        case .sandbox:
          return SoftAcceptConfiguration(origin: "'https://merch-prod.snd.payu.com'")
        case .sandboxBeta:
          return SoftAcceptConfiguration(origin: "'https://secure.sndbeta.payu.com'")
      }
    }
  }

  // MARK: - Public Properties
  let origin: String
  let channelName: String

  // MARK: - Initialization
  init(origin: String, channelName: String = Constants.javascriptChannelName) {
    self.origin = origin
    self.channelName = channelName
  }
}
