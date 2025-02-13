//
//  TokenCreateResponse.swift
//

import Foundation

#if canImport(PUAPI)
  import PUAPI
#endif

#if canImport(PUCore)
  import PUCore
#endif

struct TokenCreateResponse: Codable, Equatable {
  // MARK: - Public Properties
  let value: String
  let maskedCard: String

}
