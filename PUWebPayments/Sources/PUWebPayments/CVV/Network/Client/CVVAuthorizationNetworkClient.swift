//
//  CVVAuthorizationNetworkClient.swift
//  
//  Created by PayU S.A. on 20/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUAPI)
import PUAPI
#endif

protocol CVVAuthorizationNetworkClientProtocol {
  func authorizeCVV(
    cvvAuthorizationRequest: CVVAuthorizationRequest,
    completionHandler: @escaping (Result<Void, Error>) -> Void)
}

struct CVVAuthorizationNetworkClient: CVVAuthorizationNetworkClientProtocol {

  // MARK: - Private Properties
  private let client: NetworkClientProtocol

  // MARK: - Initialization
  init(client: NetworkClientProtocol) {
    self.client = client
  }

  // MARK: - CVVAuthorizationNetworkClientProtocol
  func authorizeCVV(
    cvvAuthorizationRequest: CVVAuthorizationRequest,
    completionHandler: @escaping (Result<Void, Error>) -> Void) {

      client.request(
        target: CVVAuthorizationNetworkTarget.authorizeCVV(cvvAuthorizationRequest),
        type: EmptyResponse.self,
        completionHandler: { response in
          switch response {
            case .success(_):
              completionHandler(.success(()))
            case .failure(let error):
              completionHandler(.failure(error))
          }
        })
    }
}
