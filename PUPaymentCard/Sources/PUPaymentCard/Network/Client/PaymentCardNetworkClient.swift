//
//  PaymentCardNetworkClient.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUAPI)
import PUAPI
#endif

#if canImport(PUCore)
import PUCore
#endif

protocol PaymentCardNetworkClientProtocol {
  func tokenize(
    tokenCreateRequest: TokenCreateRequest,
    completionHandler: @escaping (Result<TokenCreateResponse, Error>) -> Void)
}

struct PaymentCardNetworkClient: PaymentCardNetworkClientProtocol {
  
  // MARK: - Private Properties
  private let client: NetworkClientProtocol

  // MARK: - Initialization
  init(client: NetworkClientProtocol) {
    self.client = client
  }
  
  // MARK: - PaymentCardNetworkClientProtocol
  func tokenize(
    tokenCreateRequest: TokenCreateRequest,
    completionHandler: @escaping (Result<TokenCreateResponse, Error>) -> Void) {

      client.request(
        target: PaymentCardNetworkTarget.tokenize(tokenCreateRequest),
        type: TokenCreateResponse.self) { result in
          switch result {
            case .success(let response):
              completionHandler(.success(response))

            case .failure(let error):
              completionHandler(.failure(error))
          }
        }
    }
}
