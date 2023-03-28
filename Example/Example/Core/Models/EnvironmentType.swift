//
//  EnvironmentType.swift
//  Example
//
//  Created by PayU S.A. on 18/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation
import PUSDK

enum EnvironmentType: String, Codable, CaseIterable {
  case production = "Production"
  case sandbox = "Sandbox"
  case sandboxBeta = "Sandbox (Beta)"
}

extension EnvironmentType {
  var payU: Environment {
    switch self {
      case .production:
        return .production
      case .sandbox:
        return .sandbox
      case .sandboxBeta:
        return .sandboxBeta
    }
  }
}
