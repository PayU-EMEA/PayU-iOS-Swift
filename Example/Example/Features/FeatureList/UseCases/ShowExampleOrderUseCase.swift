//
//  ShowExampleOrderUseCase.swift
//  Example
//
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

final class ShowExampleOrderUseCase {
  private weak var presenter: UIViewController?

  init(presenter: UIViewController? = nil) {
    self.presenter = presenter
  }

  func execute() {
    let viewController = ProductListViewController()
    let navigationController = UINavigationController(rootViewController: viewController)
    presenter?.present(navigationController, animated: true)
  }
}
