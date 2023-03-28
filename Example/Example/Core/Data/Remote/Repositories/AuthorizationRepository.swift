//
//  AuthorizationRepository.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

final class AuthorizationRepository {
  private let client = NetworkClient<AuthorizationEndpoint>()
  private let settingsRepository = SettingsRepository()
  
  func authorize(completionHandler: @escaping () -> Void) {
    guard let environment = settingsRepository.getEnvironment() else { return }
    
    let authorizationBody = AuthorizationBody(
      clientId: environment.clientId,
      clientSecret: environment.clientSecret,
      grantType: environment.grantType.rawValue,
      email: Constants.Buyer.email,
      extCustomerId: Constants.Buyer.extCustomerId)
    
    client.request(
      endpoint: .authorize(authorizationBody),
      type: AuthorizationResponse.self,
      completionHandler: { result in
        switch result {
          case .success(let response):
            self.settingsRepository.setToken(response.accessToken)
            completionHandler()
          case .failure:
            completionHandler()
        }
      }
    )
  }
}
