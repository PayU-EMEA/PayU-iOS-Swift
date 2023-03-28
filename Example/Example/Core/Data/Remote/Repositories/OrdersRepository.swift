//
//  OrdersRepository.swift
//  Example
//
//  Created by PayU S.A. on 30/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

final class OrdersRepository {
  private let client = NetworkClient<OrdersEndpoint>()

  func createOrder(orderCreateRequest: OrderCreateRequest, completionHandler: @escaping (Result<OrderCreateResponse, Error>) -> Void) {
    client.request(
      endpoint: .createOrder(orderCreateRequest),
      type: OrderCreateResponse.self,
      completionHandler: completionHandler)
  }
}
