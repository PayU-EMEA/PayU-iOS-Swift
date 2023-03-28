//
//  PaymentCardRepository.swift
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

protocol PaymentCardRepositoryProtocol {
  func tokenize(
    tokenCreateRequest: TokenCreateRequest,
    completionHandler: @escaping (Result<CardToken, Error>) -> Void)
}

struct PaymentCardRepository: PaymentCardRepositoryProtocol {

  // MARK: - Private Properties
  private let client: PaymentCardNetworkClientProtocol
  private let finder: PaymentCardProviderFinderProtocol

  // MARK: - Initialization
  init(client: PaymentCardNetworkClientProtocol, finder: PaymentCardProviderFinderProtocol) {
    self.client = client
    self.finder = finder
  }

  // MARK: - PaymentCardRepositoryProtocol
  func tokenize(
    tokenCreateRequest: TokenCreateRequest,
    completionHandler: @escaping (Result<CardToken, Error>) -> Void) {
      client.tokenize(tokenCreateRequest: tokenCreateRequest) { result in
        switch result {
          case .success(let success):
            completionHandler(
              .success(
                mapTokenCreateResponseToCardToken(
                  tokenCreateRequest: tokenCreateRequest,
                  tokenCreateResponseResult: success)))

          case .failure(let failure):
            completionHandler(.failure(failure))
        }
      }
    }

  // MARK: - Private Methods
  private func mapTokenCreateResponseToCardToken(
    tokenCreateRequest: TokenCreateRequest,
    tokenCreateResponseResult: TokenCreateResponse.Result) -> CardToken {
      let paymentCardProvider = finder.find(tokenCreateRequest.data.card.number)

      return CardToken(
        brandImageUrl: paymentCardProvider?.brandImageProvider.url ?? "",
        cardExpirationMonth: Int(tokenCreateRequest.data.card.expirationMonth) ?? 0,
        cardExpirationYear: Int(tokenCreateRequest.data.card.expirationYear) ?? 0,
        cardNumberMasked: tokenCreateResponseResult.mask,
        cardScheme: paymentCardProvider?.scheme,
        preferred: false,
        status: .active,
        value: tokenCreateResponseResult.token)
    }
}
