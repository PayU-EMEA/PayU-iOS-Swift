//
//  POS.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Represents the Point of Sale. See [developers.payu.com](https://developers.payu.com/en/restapi.html#overview) for more details
public struct POS {

  // MARK: - Public Properties

  /// merchantPosId. For ex: "145227"
  public let id: String

  /// The ``Environment`` which will be user in dependant packages
  public let environment: Environment

  // MARK: - Initialization
  public init(id: String, environment: Environment) {
    self.id = id
    self.environment = environment
  }
}
