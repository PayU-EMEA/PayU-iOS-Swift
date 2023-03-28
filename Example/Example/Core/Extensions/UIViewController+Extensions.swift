//
//  UIViewController+Extensions.swift
//  Example
//
//  Created by PayU S.A. on 23/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

extension UIViewController {
  func dialog(title: String? = nil, message: String?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alertController, animated: true)
  }
}
