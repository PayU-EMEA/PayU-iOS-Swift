//
//  SoftAcceptRepository.swift
//  
//  Created by PayU S.A. on 16/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUAPI)
import PUAPI
#endif

protocol SoftAcceptRepositoryProtocol {
  func create(log: SoftAcceptLog, completionHandler: @escaping (Result<SoftAcceptResponse, Error>) -> Void)
}

struct SoftAcceptRepository: SoftAcceptRepositoryProtocol {

  // MARK: - Private Properties
  private let client: NetworkClientProtocol

  // MARK: - Initialization
  init(client: NetworkClientProtocol) {
    self.client = client
  }

  // MARK: - Public Methods
  func create(log: SoftAcceptLog, completionHandler: @escaping (Result<SoftAcceptResponse, Error>) -> Void) {
    client.request(target: SoftAcceptNetworkTarget.create(log), type: SoftAcceptResponse.self, completionHandler: completionHandler)
  }
}
