//
//  DemoWebPaymentsSSLViewModel.swift
//  Example
//
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation
import PUSDK

protocol DemoWebPaymentsSSLViewModelDelegate: AnyObject {
  func demoWebPaymentsSSLViewModel(_ viewModel: DemoWebPaymentsSSLViewModel, shouldPresentWebPayments request: WebPaymentsRequest)
}

final class DemoWebPaymentsSSLViewModel {

  // MARK: - Public Properties
  weak var delegate: DemoWebPaymentsSSLViewModelDelegate?
  let domains = [
    "https://expired.badssl.com/",
    "https://wrong.host.badssl.com/",
    "https://self-signed.badssl.com/",
    "https://untrusted-root.badssl.com/",
    "https://revoked.badssl.com/",
    "https://pinning-test.badssl.com/",
    "https://some-unknown-domain.hello.world/"
  ]

  // MARK: - Public Methods
  func didSelect(at indexPath: IndexPath) {
    let redirectUrl = URL(string: domains[indexPath.row])!
    let continueUrl = URL(string: Constants.Order.continueUrl)!
    let request = WebPaymentsRequest(requestType: .payByLink, redirectUrl: redirectUrl, continueUrl: continueUrl)
    delegate?.demoWebPaymentsSSLViewModel(self, shouldPresentWebPayments: request)
  }
}

