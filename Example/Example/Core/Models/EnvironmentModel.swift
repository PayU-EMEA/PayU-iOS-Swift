//
//  EnvironmentModel.swift
//  Example
//
//  Created by PayU S.A. on 18/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

struct EnvironmentModel: DatabaseObject {
  let id: String
  let environmentType: EnvironmentType
  let grantType: GrantType
  let clientId: String
  let clientSecret: String

  private init(id: String, environmentType: EnvironmentType, grantType: GrantType, clientId: String, clientSecret: String) {
    self.id = id
    self.environmentType = environmentType
    self.grantType = grantType
    self.clientId = clientId
    self.clientSecret = clientSecret
  }

  static func sandbox() -> EnvironmentModel {
    return EnvironmentModel(
      id: UUID().uuidString,
      environmentType: .sandbox,
      grantType: .trustedMerchant,
      clientId: "300746",
      clientSecret: "2ee86a66e5d97e3fadc400c9f19b065d")
  }

  static func create(environmentType: EnvironmentType, grantType: GrantType, clientId: String, clientSecret: String) -> EnvironmentModel {
    return EnvironmentModel(
      id: UUID().uuidString,
      environmentType: environmentType,
      grantType: grantType,
      clientId: clientId,
      clientSecret: clientSecret)
  }
}

extension EnvironmentModel: Equatable {
  static func ==(lhs: EnvironmentModel, rhs: EnvironmentModel) -> Bool {
    return lhs.id == rhs.id
  }
}
