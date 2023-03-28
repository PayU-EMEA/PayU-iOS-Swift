//
//  String+Extensions.swift
//  Example
//
//  Created by PayU S.A. on 22/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

extension String {
  func limited(_ maxLength: Int) -> String {
    return count > maxLength ? String(prefix(10)) + "..." : self
  }
}
