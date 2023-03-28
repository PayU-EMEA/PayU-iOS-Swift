//
//  ShowDemoThemeUseCase.swift
//  Example
//
//  Created by PayU S.A. on 07/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

final class ShowDemoThemeUseCase {
  private weak var presenter: UIViewController?

  init(presenter: UIViewController? = nil) {
    self.presenter = presenter
  }

  func execute() {
    let viewController = DemoThemeViewController()
    presenter?.navigationController?.pushViewController(viewController, animated: true)
  }
}
