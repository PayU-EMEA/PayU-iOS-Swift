//
//  Date+Extensions.swift
//  
//  Created by PayU S.A. on 13/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

extension Date {

  /// Indicated if the Date is in future
  var isInFuture: Bool {
    compare(Date()) == .orderedDescending
  }

  /// Extracts the *month* from the date using *Calendar.current*
  var month: Int {
    Calendar.current.component(.month, from: self)
  }

  /// Extracts the *year* from the date using *Calendar.current*
  var year: Int {
    Calendar.current.component(.year, from: self)
  }
}
