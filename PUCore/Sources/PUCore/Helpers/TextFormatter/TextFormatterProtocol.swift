//
//  TextFormatterProtocol.swift
//
//  Created by PayU S.A. on 16/01/2023.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// The protocol which allows to format the text into formatted text
public protocol TextFormatterProtocol {
  func formatted(_ text: String) -> String
}
