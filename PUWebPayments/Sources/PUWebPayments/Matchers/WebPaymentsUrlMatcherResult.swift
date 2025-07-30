//
//  WebPaymentsUrlMatcherResult.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

enum WebPaymentsUrlMatcherResult {
  case notMatched
  case success
  case failure
  case continue3DS
  case continueCvv
  case externalApplication
  case creditExternalApplication
}
