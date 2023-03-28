//
//  SoftAcceptService.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation
import WebKit

#if canImport(PUCore)
import PUCore
#endif

/// Implementing this protocol, you'll receive the callbacks from ``SoftAcceptService``
public protocol SoftAcceptServiceDelegate: AnyObject {

  /// This method is called when ``SoftAcceptService`` is ready to start `authentication`
  /// - Parameters:
  ///   - service: Instance of ``SoftAcceptService`` from where the action was triggered
  ///   - request: ``SoftAcceptRequest`` instance which was passed to ``SoftAcceptService``
  func softAcceptService(_ service: SoftAcceptService, didStartAuthentication request: SoftAcceptRequest)

  /// This method is called when ``SoftAcceptService`` did receive message from `iframe`
  /// - Parameters:
  ///   - service: Instance of ``SoftAcceptService`` from where the action was triggered
  ///   - request: ``SoftAcceptStatus`` value received from `message.body`
  func softAcceptService(_ service: SoftAcceptService, didCompleteAuthentication status: SoftAcceptStatus)
}

/// Service which is responsible for processing of [Authentication](https://developers.payu.com/en/3ds_2.html#auth_page)
public final class SoftAcceptService: NSObject, WKScriptMessageHandler {

  // MARK: - Factory
  /// Factory which allows to create the ``SoftAcceptService`` instance
  public struct Factory {

    // MARK: - Private Properties
    private let assembler = ThreeDSAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Public Methods
    /// Returns default implementation for ``SoftAcceptService``
    /// - Returns: Default implementation for ``SoftAcceptService``
    public func make() -> SoftAcceptService {
      assembler.makeService()
    }
  }

  // MARK: - Public Properties
  public weak var delegate: SoftAcceptServiceDelegate?

  // MARK: - Private Properties
  private var request: SoftAcceptRequest!

  private let components: SoftAcceptComponents
  private let configuration: SoftAcceptConfiguration
  private let extractor: SoftAcceptQueryParameterExtractor
  private let repository: SoftAcceptRepository
  private let urlModifier: SoftAcceptUrlModifier

  private lazy var webView: WKWebView = buildWebView()

  // MARK: - Initialization
  init(
    components: SoftAcceptComponents,
    configuration: SoftAcceptConfiguration,
    extractor: SoftAcceptQueryParameterExtractor,
    repository: SoftAcceptRepository,
    urlModifier: SoftAcceptUrlModifier
  ) {
    self.components = components
    self.configuration = configuration
    self.extractor = extractor
    self.repository = repository
    self.urlModifier = urlModifier
  }

  // MARK: - Public Methods

  /// Call this method after you reveice the [OrderCreateResponse](https://developers.payu.com/en/3ds_2.html#api_response) with `WARNING_CONTINUE_3DS`
  /// ``SoftAcceptRequest/redirectUrl`` must contain `authenticationId` query parameter
  public func authenticate(request: SoftAcceptRequest) {
    self.request = request

    delegate?.softAcceptService(self, didStartAuthentication: request)

    let redirectUrl = urlModifier.modify(request.redirectUrl)
    let iframe = components.iframe(redirectUri: redirectUrl.absoluteString)
    webView.loadHTMLString(iframe, baseURL: nil)

    let configuration = SoftAcceptConfiguration.Factory(environment: PayU.pos.environment).make()
    let javascript = components.javascript(origin: configuration.origin, channelName: configuration.channelName)
    let userScript = WKUserScript(source: javascript, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    webView.configuration.userContentController.addUserScript(userScript)
  }

  // MARK: - Private Methods
  private func buildWebView() -> WKWebView {
    let webViewConfiguration = WKWebViewConfiguration()
    webViewConfiguration.userContentController.add(self, name: configuration.channelName)
    return WKWebView(frame: .zero, configuration: webViewConfiguration)
  }

  private func postSoftAcceptLog(_ log: SoftAcceptLog, completionHandler: @escaping (Result<SoftAcceptResponse, Error>) -> Void) {
    repository.create(log: log, completionHandler: completionHandler)
  }

  private func postSoftAcceptResult(_ result: SoftAcceptResult) {
    delegate?.softAcceptService(self, didCompleteAuthentication: result.status)
  }

  // MARK: - WKScriptMessageHandler
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    guard let request = request else { return }
    guard let result = SoftAcceptResult.from(message: message.body) else { return }
    guard let id = extractor.extractAuthenticationId(request.redirectUrl) else { return }
    let log = SoftAcceptLog(id: id, message: result.status.rawValue)

    postSoftAcceptLog(log) { [weak self] response in
      guard let self = self else { return }
      userContentController.removeAllUserScripts()
      self.postSoftAcceptResult(result)
    }
  }
}
