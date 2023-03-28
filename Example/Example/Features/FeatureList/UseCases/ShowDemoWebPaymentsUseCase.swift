//
//  ShowDemoWebPaymentsUseCase.swift
//  Example
//
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

final class ShowDemoWebPaymentsUseCase {
  private weak var presenter: UIViewController?

  init(presenter: UIViewController? = nil) {
    self.presenter = presenter
  }

  func execute() {
    let viewController = DemoWebPaymentsSSLViewController()
    presenter?.navigationController?.pushViewController(viewController, animated: true)
  }
}
