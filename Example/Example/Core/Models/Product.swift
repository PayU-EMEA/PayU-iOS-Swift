//
//  Product.swift
//  Example
//
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

public final class Product: Codable {
  public static let products = [
    Product(name: "Futomaki", unitPrice: 1999),
    Product(name: "Napkin", unitPrice: 49),
    Product(name: "Set", unitPrice: 9999)]

  public let id: String
  public let name: String
  public let unitPrice: Int
  public var quantity: Int

  public var price: Int {
    unitPrice * quantity
  }

  public init(name: String, unitPrice: Int) {
    self.id = UUID().uuidString
    self.name = name
    self.unitPrice = unitPrice
    self.quantity = 0
  }
}
