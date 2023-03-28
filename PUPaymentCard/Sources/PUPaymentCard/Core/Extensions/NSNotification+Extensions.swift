//
//  NSNotification+Extensions.swift
//  
//  Created by PayU S.A. on 07/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import Foundation

extension NSNotification.Name {
  public struct PayU {
    public struct PaymentCardWidget {
      public static let didTapHintAccessoryViewInCVVField = NSNotification.Name("didTapHintAccessoryViewInCVVField")
    }
  }
}
