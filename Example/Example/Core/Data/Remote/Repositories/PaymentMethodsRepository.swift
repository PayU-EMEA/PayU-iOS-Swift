//
//  PaymentMethodsRepository.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

final class PaymentMethodsRepository {
  private let client = NetworkClient<PaymentMethodsEndpoint>()

  func getPaymentMethods(completionHandler: @escaping (Result<PaymentMethodsResponse, Error>) -> Void) {
    client.request(
      endpoint: .getPaymentMethods,
      type: PaymentMethodsResponse.self,
      completionHandler: completionHandler)
  }

  func deletePaymentMethod(token: String, completionHandler: @escaping (Result<EmptyResponse, Error>) -> Void) {
    client.request(
      endpoint: .deletePaymentMethod(token),
      type: EmptyResponse.self,
      completionHandler: completionHandler)
  }
}
