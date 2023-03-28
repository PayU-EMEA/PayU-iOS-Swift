//
//  CVVAuthorizationRepository.swift
//  
//  Created by PayU S.A. on 20/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

protocol CVVAuthorizationRepositoryProtocol {
  func authorizeCVV(
    cvvAuthorizationRequest: CVVAuthorizationRequest,
    completionHandler: @escaping (Result<CVVAuthorizationResult, Error>) -> Void)
}

struct CVVAuthorizationRepository: CVVAuthorizationRepositoryProtocol {

  // MARK: - Private Properties
  private let client: CVVAuthorizationNetworkClientProtocol

  // MARK: - Initialization
  init(client: CVVAuthorizationNetworkClientProtocol) {
    self.client = client
  }

  // MARK: - CVVAuthorizationRepositoryProtocol
  func authorizeCVV(
    cvvAuthorizationRequest: CVVAuthorizationRequest,
    completionHandler: @escaping (Result<CVVAuthorizationResult, Error>) -> Void) {

      client.authorizeCVV(
        cvvAuthorizationRequest: cvvAuthorizationRequest,
        completionHandler: { response in
          switch response {
            case .success:
              completionHandler(.success(.success))
            case .failure(let error):
              completionHandler(.failure(error))
          }
        }
      )
    }
}
