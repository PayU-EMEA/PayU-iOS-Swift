//
//  SoftAcceptStatus.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// The status if the transaction during the [Handling iframe](https://developers.payu.com/en/3ds_2.html#handling_iframe). The `iframe` may post messages to its parent window with the following values in `message.data` property.
public enum SoftAcceptStatus: String, Codable {
  case displayFrame = "DISPLAY_FRAME"
  case authenticationSuccessful = "AUTHENTICATION_SUCCESSFUL"
  case authenticationCanceled = "AUTHENTICATION_CANCELED"
  case authenticationNotRequired = "AUTHENTICATION_NOT_REQUIRED"
  case unexpected = "UNEXPECTED"
}
