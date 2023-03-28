//
//  ShowDemoMastercardInstallmentsUseCase.swift
//  Example
//
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit
import PUSDK

final class ShowDemoMastercardInstallmentsUseCase {

  enum Format: String {
    case vnoi = "mastercard_installments_vnoi"
    case vnoo = "mastercard_installments_vnoo"
  }

  private weak var presenter: UIViewController?
  private let format: Format

  init(presenter: UIViewController? = nil, format: Format) {
    self.presenter = presenter
    self.format = format
  }

  func execute() {
    let path = Bundle.main.path(forResource: format.rawValue, ofType: "json")!
    let data = FileManager.default.contents(atPath: path)!
    let proposal = try! JSONDecoder().decode(InstallmentProposal.self, from: data)

    let viewController = OfferViewController.Factory().make(proposal: proposal)
    let navigationController = UINavigationController(rootViewController: viewController)
    presenter?.present(navigationController, animated: true)
    viewController.delegate = self
  }
}

// MARK: - OfferViewControllerDelegate
extension ShowDemoMastercardInstallmentsUseCase: OfferViewControllerDelegate {
  func offerViewController(_ viewController: OfferViewController, didComplete result: InstallmentResult) {
    Console.console.log(result)
    viewController.navigationController?.dismiss(animated: true) { [weak self] in
      self?.presenter?.dialog(
        title: "ShowDemoMastercardInstallmentsUseCase",
        message: "numberOfInstallments: \(String(describing: result.numberOfInstallments))\noptionId:\(String(describing: result.optionId))")
    }
  }

  func offerViewModelDidCancel(_ viewController: OfferViewController) {
    Console.console.log()
    viewController.navigationController?.dismiss(animated: true) { [weak self] in
      self?.presenter?.dialog(
        title: "ShowDemoMastercardInstallmentsUseCase",
        message: "offerViewModelDidCancel")
    }
  }
}
