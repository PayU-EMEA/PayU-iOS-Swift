//
//  ShowDemoCVVAuthorizationUseCase.swift
//  Example
//
//  Created by PayU S.A. on 20/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit
import PUSDK

final class ShowDemoCVVAuthorizationUseCase {

  // MARK: - Private Properties
  private weak var presenter: UIViewController?
  private let service = CVVAuthorizationService.Factory().make()

  // MARK: - Initialization
  init(presenter: UIViewController? = nil) {
    self.presenter = presenter
    self.service.delegate = self
    self.service.presentingViewController = presenter
  }

  func execute() {
    let redirectUrl = URL(string: "https://merch-prod.snd.payu.com/front/threeds/?authenticationId=e8fb5f55b&refReqId=19a1b4d3c416b6df943d6b337831faaa")!
    let extractor = CVVAuthorizationExtractor()
    let refReqId = extractor.extractRefReqId(redirectUrl)!
    service.authorize(refReqId: refReqId)
  }
}

// MARK: - CVVAuthorizationServiceDelegate
extension ShowDemoCVVAuthorizationUseCase: CVVAuthorizationServiceDelegate {
  func cvvAuthorizationService(_ service: CVVAuthorizationService, didComplete status: CVVAuthorizationResult) {
    presenter?.dialog(title: "ShowDemoCVVAuthorizationUseCase", message: status.rawValue)
    Console.console.log(status)
  }

  func cvvAuthorizationService(_ service: CVVAuthorizationService, didFail error: Error) {
    presenter?.dialog(title: "ShowDemoCVVAuthorizationUseCase", message: error.localizedDescription)
    Console.console.log(error)
  }
}
