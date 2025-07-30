//
//  WebPaymentsViewModel.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation
import WebKit

protocol WebPaymentsViewModelDelegate: AnyObject {
  func webPaymentsViewModel(_ viewModel: WebPaymentsViewModel, didComplete result: WebPaymentsResult)
  func webPaymentsViewModel(_ viewModel: WebPaymentsViewModel, didUpdate currentUrl: URL?)

  func webPaymentsViewModelShouldPresentBackAlertDialog(_ viewModel: WebPaymentsViewModel)
  func webPaymentsViewModelShouldPresentSSLAlertDialog(_ viewModel: WebPaymentsViewModel)
  func webPaymentsViewModelShouldPresentProviderRedirectDialog(_ viewModel: WebPaymentsViewModel, _ url: URL)
}

final class WebPaymentsViewModel {

  // MARK: - Public Properties
  weak var delegate: WebPaymentsViewModelDelegate?

  var currentError: Error?
  var currentUrl: URL!
  var redirectUrl: URL { request.redirectUrl }

  // MARK: - Private Properties
  private let request: WebPaymentsRequest
  private let matcher: WebPaymentsUrlMatcher

  // MARK: - Initialization
  init(matcher: WebPaymentsUrlMatcher, request: WebPaymentsRequest) {
    self.matcher = matcher
    self.request = request
    self.currentUrl = request.redirectUrl
  }

  // MARK: - Public Methods
  @discardableResult
  func navigationPolicy(_ url: URL) -> WKNavigationActionPolicy {
    currentUrl = url
    currentError = nil
    delegate?.webPaymentsViewModel(self, didUpdate: currentUrl)

    switch matcher.result(url) {
      case .notMatched:
        return .allow

      case .success:
        complete(with: .success)
        return .cancel

      case .failure:
        complete(with: .failure)
        return .cancel

      case .continue3DS:
        complete(with: .continue3DS)
        return .allow

      case .continueCvv:
        complete(with: .continueCvv)
        return .allow

      case .externalApplication:
        UIApplication.shared.open(url)
        complete(with: .externalApplication)
        return .cancel
        
      case .creditExternalApplication:
        delegate?.webPaymentsViewModelShouldPresentProviderRedirectDialog(self, url)
        return .cancel
    }
  }

  func didTapBack() {
    delegate?.webPaymentsViewModelShouldPresentBackAlertDialog(self)
  }

  func didTapConfirmBack() {
    complete(with: .cancelled)
  }

  func didFailNavigation(with error: Error) {
    if error.isSSL {
      currentError = error
      delegate?.webPaymentsViewModel(self, didUpdate: currentUrl)
      delegate?.webPaymentsViewModelShouldPresentSSLAlertDialog(self)
    }
  }

  func didProceedWithInstallmentsExternalApplication(_ url: URL) {
    UIApplication.shared.open(url)
    complete(with: .creditExternalApplication)
  }

  func didAbortInstallmentsExternalApplication() {
    complete(with: .cancelled)
  }

  // MARK: - Private Methods
  private func complete(with status: WebPaymentsResult.Status) {
    let result = WebPaymentsResult(status: status, url: currentUrl)
    delegate?.webPaymentsViewModel(self, didComplete: result)
  }
}
