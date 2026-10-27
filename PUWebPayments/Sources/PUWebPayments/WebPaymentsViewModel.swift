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
  private let urlOpener: WebPaymentsUrlOpener

  // MARK: - Initialization
  init(matcher: WebPaymentsUrlMatcher, urlOpener: WebPaymentsUrlOpener, request: WebPaymentsRequest) {
    self.matcher = matcher
    self.urlOpener = urlOpener
    self.request = request
    self.currentUrl = request.redirectUrl
  }

  // MARK: - Public Methods
  /// Decides whether `url` should be loaded in the WebView. Before loading a not matched http(s) url in the main frame
  /// it tries to open it as a universal link (e.g. bank application). If an application handles the link,
  /// the navigation is cancelled and the payment completes with `externalApplication` status.
  func navigationPolicy(for url: URL, inMainFrame: Bool, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    let result = matcher.result(url)
    let policy = navigationPolicy(for: url, result: result, inMainFrame: inMainFrame)

    guard result == .notMatched, inMainFrame, isUniversalLinkCandidate(url) else {
      decisionHandler(policy)
      return
    }

    urlOpener.openUniversalLink(url) { [weak self] opened in
      guard opened, let self else {
        decisionHandler(policy)
        return
      }
      self.complete(with: .externalApplication)
      decisionHandler(.cancel)
    }
  }

  private func navigationPolicy(for url: URL, result: WebPaymentsUrlMatcherResult, inMainFrame: Bool) -> WKNavigationActionPolicy {
    currentUrl = url
    currentError = nil

    // Don't update the address bar if the navigation occurs outside the main frame, like within iframes
    if (inMainFrame) {
      delegate?.webPaymentsViewModel(self, didUpdate: currentUrl)
    }

    switch result {
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
        urlOpener.open(url)
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

  func didProceedWithCreditExternalApplication(_ url: URL) {
    urlOpener.open(url)
    complete(with: .externalBrowser)
  }

  func didAbortCreditExternalApplication() {
    complete(with: .cancelled)
  }

  // MARK: - Private Methods
  /// PayU payment pages (`redirectUrl`) and merchant's `continueUrl` are never opened as universal links,
  /// otherwise e.g. the merchant application could catch its own `continueUrl` and leave the payment flow.
  private func isUniversalLinkCandidate(_ url: URL) -> Bool {
    guard let urlComponents = url.components else { return false }
    guard urlComponents.isHTTP() || urlComponents.isHTTPS() else { return false }
    guard let host = urlComponents.host else { return false }
    return host != request.redirectUrl.host && host != request.continueUrl.host
  }

  private func complete(with status: WebPaymentsResult.Status) {
    let result = WebPaymentsResult(status: status, url: currentUrl)
    delegate?.webPaymentsViewModel(self, didComplete: result)
  }
}
