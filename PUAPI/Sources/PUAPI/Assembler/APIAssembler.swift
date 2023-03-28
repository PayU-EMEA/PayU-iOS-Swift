//
//  APIAssembler.swift
//  
//  Created by PayU S.A. on 23/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUCore)
import PUCore
#endif

struct APIAssembler {

  func makeNetworkClientConfiguration() -> NetworkClientConfiguration {
    NetworkClientConfiguration(environment: PayU.pos.environment)
  }

  func makeNetworkClientAuthenticationChallengeHandler() -> NetworkClientAuthenticationChallengeHandler {
    NetworkClientAuthenticationChallengeHandler(configuration: makeNetworkClientConfiguration())
  }

  func makeNetworkClient() -> NetworkClient {
    NetworkClient(
      networkClientConfiguration: makeNetworkClientConfiguration(),
      session: makeSession())
  }

  func makeSession() -> URLSession {
    URLSession(
      configuration: makeSessionConfiguration(),
      delegate: makeNetworkClientAuthenticationChallengeHandler(),
      delegateQueue: nil)
  }

  func makeSessionConfiguration() -> URLSessionConfiguration {
    URLSessionConfiguration.default
  }
}
