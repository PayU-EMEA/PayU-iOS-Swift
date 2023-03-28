//
//  DefaultTextFormatter.swift
//  
//  Created by PayU S.A. on 16/01/2023.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct DefaultTextFormatter: TextFormatterProtocol {

  // MARK: - Mask
  enum Mask: String {
    case blik = "######"
    case cvv = "###"
  }

  // MARK: - Private Properties
  private let mask: Mask

  // MARK: - Initialization
  init(mask: Mask) {
    self.mask = mask
  }

  // MARK: - Public Methods
  func formatted(_ text: String) -> String {
    var result = ""
    let digitsOnly = text.digitsOnly
    var index = digitsOnly.startIndex

    for character in mask.rawValue where index < digitsOnly.endIndex {
      if character == "#" {
        result.append(digitsOnly[index])
        index = digitsOnly.index(after: index)
      } else {
        result.append(character)
      }
    }
    return result
  }
}

