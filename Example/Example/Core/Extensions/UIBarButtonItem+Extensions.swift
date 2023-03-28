//
//  UIBarButtonItem+Extensions.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

extension UIBarButtonItem {
  static func settings(target: Any?, action: Selector?) -> UIBarButtonItem {
    return UIBarButtonItem(title: "Settings", style: .plain, target: target, action: action)
  }
}
