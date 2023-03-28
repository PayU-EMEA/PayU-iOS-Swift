//
//  String+Extensions.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//
// https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift

import Foundation

public extension String {

  /// Removes all characters from the string, leaving only digits.
  ///
  /// ```swift
  /// let string = "1234 abcd".digitsOnly
  /// print(string) // prints: "1234"
  /// ```
  var digitsOnly: String {
    components(separatedBy: .decimalDigits.inverted)
      .joined()
  }

  /// Indicates if the String consists of only digits
  var isDecimalDigits: Bool {
    CharacterSet(charactersIn: self)
      .isSubset(of: .decimalDigits)
  }

  /// Indicates if the String is of BLIK format
  ///
  /// * Must consists of only digits
  /// * Must be of 6 characters length
  ///
  /// ```swift
  /// "123 abc".isBlikCode // false
  /// "123456".isBlikCode // true
  /// ```
  var isBlikCode: Bool {
    isDecimalDigits && count == 6
  }

  /// Indicates if the String is of possible BLIK format
  ///
  /// * Must consists of only digits
  /// * Must be of 6 characters length of less
  ///
  /// ```swift
  /// "123".isBlikCodePart // true
  /// "123456".isBlikCode // true
  /// ```
  var isBlikCodePart: Bool {
    isDecimalDigits && count <= 6
  }

  /// Indicates if the String is of CVV format
  ///
  /// * Must consists of only digits
  /// * Must be of 3 characters length
  ///
  /// ```swift
  /// "12".isCVV // false
  /// "123".isCVV // true
  /// ```
  var isCVV: Bool {
    isDecimalDigits && count == 3
  }

  static func ~= (lhs: String, rhs: String) -> Bool {
    guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
    let range = NSRange(location: 0, length: lhs.utf16.count)
    return regex.firstMatch(in: lhs, options: [], range: range) != nil
  }

  static func *= (lhs: String, rhs: String) -> Bool {
    guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
    let range = NSRange(location: 0, length: lhs.utf16.count)
    return regex.numberOfMatches(in: lhs, range: range) > 0
  }
}
