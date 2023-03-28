//
//  DataRepository.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation
import Combine

public final class DataRepository {

  // MARK: - Private Properties
  private let authorizationRepository = AuthorizationRepository()
  private let ordersRepository = OrdersRepository()
  private let paymentMethodsRepository = PaymentMethodsRepository()

  // MARK: - Public Methods
  public func getPaymentMethods(completionHandler: @escaping (Result<PaymentMethodsResponse, Error>) -> Void) {
    authorizationRepository.authorize {
      self.paymentMethodsRepository.getPaymentMethods(completionHandler: completionHandler)
    }
  }

  public func deletePaymentMethod(token: String, completionHandler: @escaping (Result<EmptyResponse, Error>) -> Void) {
    authorizationRepository.authorize {
      self.paymentMethodsRepository.deletePaymentMethod(token: token, completionHandler: completionHandler)
    }
  }

  public func createOrder(orderCreateRequest: OrderCreateRequest, completionHandler: @escaping (Result<OrderCreateResponse, Error>) -> Void) {
    ordersRepository.createOrder(orderCreateRequest: orderCreateRequest, completionHandler: completionHandler)
  }
}
