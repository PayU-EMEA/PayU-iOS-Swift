//
//  PaymentMethodsRepository.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation
import PUCore

final class PaymentMethodsRepository {
  private let client = NetworkClient<PaymentMethodsEndpoint>()
  private let settingsRepository = SettingsRepository()

  func getPaymentMethods(completionHandler: @escaping (Result<PaymentMethodsResponse, Error>) -> Void) {
    client.request(
      endpoint: .getPaymentMethods,
      type: PaymentMethodsResponse.self,
      completionHandler: wrapWithMockedBlikTokens(completionHandler: completionHandler)
    )
  }

  func deletePaymentMethod(token: String, completionHandler: @escaping (Result<EmptyResponse, Error>) -> Void) {
    client.request(
      endpoint: .deletePaymentMethod(token),
      type: EmptyResponse.self,
      completionHandler: completionHandler)
  }
}

extension PaymentMethodsRepository {
  /// Wraps the completion handler to modify the response by mocking blikTokens before returning.
  func wrapWithMockedBlikTokens(completionHandler: @escaping (Result<PaymentMethodsResponse, Error>) -> Void) -> (Result<PaymentMethodsResponse, Error>) -> Void {
    if(settingsRepository.mockBlikToken()){
      return { result in
        switch result {
        case .success(let response):
          let mockedResponse = self.mockBlikTokens(response: response)
          completionHandler(.success(mockedResponse))
        case .failure(let error):
          completionHandler(.failure(error))
        }
      }
    }
    return completionHandler;
  }
  
  func mockBlikTokens(response: PaymentMethodsResponse) -> PaymentMethodsResponse {
    let blikTokenJson = """
            [
                {
                    \"type\": \"token\",
                    \"brandImageUrl\": \"https://static.payu.com/images/mobile/logos/pbl_blik.png\",
                    \"value\": \"MockedBlikToken\"
                }
            ]
            """.data(using: .utf8)!
    do {
      let mockedBlikTokens = try JSONDecoder().decode([BlikToken].self, from: blikTokenJson)
      var blikTokens = response.blikTokens ?? []
      
      blikTokens.append(contentsOf: mockedBlikTokens)
      
      return PaymentMethodsResponse(
        blikTokens: blikTokens,
        cardTokens: response.cardTokens,
        payByLinks: response.payByLinks
      )
    } catch {}
    
    return response;
  }
}
