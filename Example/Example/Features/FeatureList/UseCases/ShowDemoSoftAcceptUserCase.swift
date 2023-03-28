//
//  ShowDemoSoftAcceptUserCase.swift
//  Example
//
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit
import PUSDK

final class ShowDemoSoftAcceptUserCase {
  private weak var presenter: UIViewController?
  private let service = SoftAcceptService.Factory().make()
  private var alertViewController: UIAlertController?

  init(presenter: UIViewController? = nil) {
    self.presenter = presenter
  }

  func execute() {
    let redirectUrl = URL(string: "https://merch-prod.snd.payu.com/front/threeds/?authenticationId=b4e5781&refReqId=f0bd2a9f")!
    let request = SoftAcceptRequest(redirectUrl: redirectUrl)
    service.authenticate(request: request)
    service.delegate = self
  }
}

// MARK: - SoftAcceptServiceDelegate
extension ShowDemoSoftAcceptUserCase: SoftAcceptServiceDelegate {
  func softAcceptService(_ service: SoftAcceptService, didStartAuthentication request: SoftAcceptRequest) {
    Console.console.log(request)
    alertViewController = UIAlertController(title: "SoftAccept", message: "Authenticating ...", preferredStyle: .alert)
    alertViewController?.addAction(.init(title: "Cancel", style: .cancel))
    presenter?.present(alertViewController!, animated: true)
  }

  func softAcceptService(_ service: SoftAcceptService, didCompleteAuthentication status: SoftAcceptStatus) {
    Console.console.log(status)
    alertViewController?.dismiss(animated: true) { [weak self] in
      self?.presenter?.dialog(
        title: "ShowDemoSoftAcceptUserCase",
        message: status.rawValue)
    }
  }
}
