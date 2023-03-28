//
//  SoftAcceptResult.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct SoftAcceptResult: Codable {

  // MARK: - Public Properties
  let data: String?
  let href: String?
  let userAgent: String?

  var status: SoftAcceptStatus {
    guard let data = data else { return .unexpected }
    return SoftAcceptStatus(rawValue: data) ?? .unexpected
  }

  // MARK: - Public Methods
  static func from(message: Any) -> SoftAcceptResult? {
    guard let body = message as? String else { return nil }
    guard let data = body.data(using: .utf8) else { return nil }
    do {
      let object = try JSONSerialization.jsonObject(with: data, options: [])
      let json = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
      return try JSONDecoder().decode(SoftAcceptResult.self, from: json)
    } catch { return nil }
  }
}
