//
//  OrderCreateRequest.swift
//  Example
//
//  Created by PayU S.A. on 30/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import PUSDK

public struct OrderCreateRequest: Codable {
  
  // MARK: - Delivery
  public struct Delivery: Codable {

    // MARK: - Public Properties
    public let recipientName: String
    public let recipientEmail: String
    public let recipientPhone: String
    public let addressId: String
    public let street: String
    public let postalBox: String
    public let postalCode: String
    public let city: String
    public let state: String
    public let countryCode: String
    public let name: String
  }

  // MARK: - Buyer
  public struct Buyer: Codable {

    // MARK: - Public Properties
    public let email: String
    public let phone: String
    public let firstName: String
    public let lastName: String
    public let language: String
    public let extCustomerId: String
    public let delivery: Delivery
  }

  // MARK: - PayMethods
  public struct PayMethods: Codable {

    // MARK: - Public Properties
    public let payMethod: PayMethod
  }

  // MARK: - Public Properties
  public let continueUrl: String
  public let notifyUrl: String
  public let customerIp: String
  public let merchantPosId: String
  public let description: String
  public let currencyCode: String
  public let totalAmount: Int
  public let buyer: Buyer
  public let products: [Product]
  public let payMethods: PayMethods

  // MARK: - Public Methods
  public static func build(
    clientId: String,
    currencyCode: String,
    payMethod: PayMethod,
    products: [Product]
  ) -> OrderCreateRequest {

    return OrderCreateRequest(
      continueUrl: Constants.Order.continueUrl,
      notifyUrl: Constants.Order.continueUrl,
      customerIp: Constants.Order.customerIP,
      merchantPosId: clientId,
      description: Constants.Order.description,
      currencyCode: currencyCode,
      totalAmount: products
        .filter { $0.quantity > 0 }
        .map { $0.unitPrice * $0.quantity }
        .reduce(0, +),
      buyer: Buyer(
        email: Constants.Buyer.email,
        phone: Constants.Buyer.phone,
        firstName: Constants.Buyer.firstName,
        lastName: Constants.Buyer.lastName,
        language: Constants.Buyer.language,
        extCustomerId: Constants.Buyer.extCustomerId,
        delivery: Delivery(
          recipientName: Constants.Delivery.recipientName,
          recipientEmail: Constants.Delivery.recipientEmail,
          recipientPhone: Constants.Delivery.recipientPhone,
          addressId: Constants.Delivery.addressId,
          street: Constants.Delivery.street,
          postalBox: Constants.Delivery.postalBox,
          postalCode: Constants.Delivery.postalCode,
          city: Constants.Delivery.city,
          state: Constants.Delivery.state,
          countryCode: Constants.Delivery.countryCode,
          name: Constants.Delivery.name)),
      products: products
        .filter { $0.quantity > 0 },
      payMethods: PayMethods(
        payMethod: payMethod
      )
    )
  }
}
