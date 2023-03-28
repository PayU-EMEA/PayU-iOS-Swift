//
//  Array+Extensions.swift
//  Example
//
//  Created by PayU S.A. on 22/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

// Inspired by: https://stackoverflow.com/questions/24938948/array-extension-to-remove-object-by-value
extension Array where Element: Equatable {
  /// Remove first collection element that is equal to the given `object` or `element`:
  mutating func remove(_ element: Element) {
    if let index = firstIndex(of: element) {
      remove(at: index)
    }
  }
}

extension Array where Element: DatabaseObject {
  static func decoded(from data: Data?) -> Array<Element> {
    guard let data = data else { return [] }
    guard let elements = try? PropertyListDecoder().decode([Element].self, from: data) else { return [] }
    return elements
  }

  func encoded() -> Data? {
    return try? PropertyListEncoder().encode(self)
  }
}
