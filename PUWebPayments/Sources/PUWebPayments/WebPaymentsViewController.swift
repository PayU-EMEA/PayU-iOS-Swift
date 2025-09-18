//
//  WebPaymentsViewController.swift
//  
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation
@preconcurrency import WebKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

/// Implementing this protocol, you'll receive the callbacks from ``WebPaymentsViewController``
public protocol WebPaymentsViewControllerDelegate: AnyObject {

  /// This method is called when ``WebPaymentsViewController`` did complete transaction
  /// - Parameters:
  ///   - viewController: Instance of ``WebPaymentsViewController`` from where the action was triggered
  ///   - result: ``WebPaymentsResult`` object with ``WebPaymentsResult/Status-swift.enum`` value
  func webPaymentsViewController(_ viewController: WebPaymentsViewController, didComplete result: WebPaymentsResult)
}

/// ViewController which is responsible for WebView payments
public final class WebPaymentsViewController: UIViewController {

  // MARK: - Factory
  /// Factory which allows to create the ``WebPaymentsViewController`` instance
  public struct Factory {
    // MARK: - Private Properties
    private let assembler = WebPaymentsAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Initialization
    /// Returns default implementation for ``WebPaymentsViewController``
    /// - Parameter request: ``WebPaymentsRequest`` instance
    /// - Returns: Default implementation for ``WebPaymentsViewController``
    public func make(request: WebPaymentsRequest) -> WebPaymentsViewController {
      assembler.makePaymentsViewController(request: request)
    }
  }

  // MARK: - Public Properties
  public weak var delegate: WebPaymentsViewControllerDelegate?

  // MARK: - Private Properties
  private let viewModel: WebPaymentsViewModel
  private lazy var addressBar = WebPaymentsAddressBar()
  private lazy var activityIndicatorView = self.buildActivityIndicatorView()
  private lazy var webView = self.buildWebView()

  // MARK: - Initialization
  required init(viewModel: WebPaymentsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupBasics()
    setupViewModel()
    setupWebView()
    setupNavigationItems()
    setupToolbarItems()
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setToolbarHidden(false, animated: true)
  }

  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setToolbarHidden(true, animated: true)
  }

  // MARK: - Private Methods
  private func buildActivityIndicatorView() -> UIActivityIndicatorView {
    let activityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.color = PUTheme.theme.colorTheme.primary2
    activityIndicatorView.hidesWhenStopped = true
    return activityIndicatorView
  }

  private func buildWebView() -> WKWebView {
    let configuration = WKWebViewConfiguration()
    configuration.allowsInlineMediaPlayback = true
    configuration.mediaTypesRequiringUserActionForPlayback = []

    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = self
    webView.uiDelegate = self

    return webView
  }

  private func setupBasics() {
    edgesForExtendedLayout = []

    navigationController?.navigationBar.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    navigationController?.view.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    view.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    setupNavigationTitleImage(image: PUImageView(brandImageProvider: .logo))

    let verticalStackView = UIStackView()
    verticalStackView.axis = .vertical
    verticalStackView.distribution = .fill
    view.addSubview(verticalStackView)
    verticalStackView.pinToSuperviewEdges()

    verticalStackView.addArrangedSubview(addressBar)
    verticalStackView.addArrangedSubview(webView)

    webView.addSubview(activityIndicatorView)
    activityIndicatorView.centerXToSuperview()
    activityIndicatorView.centerYToSuperview()
  }

  private func setupViewModel() {
    viewModel.delegate = self
  }

  private func setupWebView() {
    let url = viewModel.redirectUrl
    let request = URLRequest(url: url)
    webView.load(request)
  }

  private func setupNavigationItems() {
    let backButtonItem = UIBarButtonItem(title: "back".localized(), style: .plain, target: self, action: #selector(actionBackForce(_:)))
    backButtonItem.tintColor = PUTheme.theme.colorTheme.primary2
    navigationItem.leftBarButtonItem = backButtonItem
  }

  private func setupToolbarItems() {
    let backItem = UIBarButtonItem(image: UIImage.chevronLeft, style: .plain, target: self, action: #selector(actionBack(_:)))
    let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    backItem.tintColor = PUTheme.theme.colorTheme.primary2
    toolbarItems = [backItem, spacerItem]
  }

  // MARK: - Actions
  @objc private func actionBack(_ sender: Any) {
    if webView.canGoBack {
      webView.goBack()
    } else {
      viewModel.didTapBack()
    }
  }

  @objc private func actionBackForce(_ sender: Any) {
    viewModel.didTapBack()
  }

}

// MARK: - WebPaymentsViewModelDelegate
extension WebPaymentsViewController: WebPaymentsViewModelDelegate {
  func webPaymentsViewModel(_ viewModel: WebPaymentsViewModel, didComplete result: WebPaymentsResult) {
    delegate?.webPaymentsViewController(self, didComplete: result)
  }

  func webPaymentsViewModel(_ viewModel: WebPaymentsViewModel, didUpdate currentUrl: URL?) {
    addressBar.url = currentUrl
    addressBar.isSecure = viewModel.currentError == nil
  }

  func webPaymentsViewModelShouldPresentBackAlertDialog(_ viewModel: WebPaymentsViewModel) {
    let alertController = UIAlertController(
      title: "close_and_go_back".localized(),
      message: "your_payment_will_be_canceled_continue".localized(),
      preferredStyle: .alert)

    alertController.addAction(
      UIAlertAction(
        title: "yes_go_back".localized(),
        style: .destructive,
        handler: { action in viewModel.didTapConfirmBack() }))

    alertController.addAction(
      UIAlertAction(
        title: "no_stay_on_one_payment_page".localized(),
        style: .cancel))

    present(alertController, animated: true)
  }

  func webPaymentsViewModelShouldPresentSSLAlertDialog(_ viewModel: WebPaymentsViewModel) {
    let alertController = UIAlertController(
      title: "your_connection_is_not_secure".localized(),
      message: "attackers_might_be_trying_to_steal_your_information_for_example_passwords_messages_or_credit_cards".localized(),
      preferredStyle: .alert)

    alertController.addAction(
      UIAlertAction(
        title: "cancel".localized(),
        style: .cancel))

    present(alertController, animated: true)
  }
    
  func webPaymentsViewModelShouldPresentProviderRedirectDialog(_ viewModel: WebPaymentsViewModel, _ url: URL) {
      let alertController = UIAlertController(
        title: "credit_provider_url_redirect".localized(),
        message: "credit_browser_provider_url_redirect".localized(),
        preferredStyle: .alert)

      alertController.addAction(
        UIAlertAction(
          title: "ok".localized(),
          style: .default,
          handler: { action in viewModel.didProceedWithCreditExternalApplication(url) }))

      alertController.addAction(
        UIAlertAction(
          title: "cancel".localized(),
          style: .destructive,
          handler: { action in viewModel.didAbortCreditExternalApplication() }))

      present(alertController, animated: true)
    }
}

// MARK: - WKNavigationDelegate
extension WebPaymentsViewController: WKNavigationDelegate {
  public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    guard let url = navigationAction.request.url else { decisionHandler(.cancel); return }
    let navigationPolicy = viewModel.navigationPolicy(for: url, inMainFrame: navigationAction.targetFrame?.isMainFrame == true)
    decisionHandler(navigationPolicy)
  }

  public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    activityIndicatorView.startAnimating()
  }

  public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    activityIndicatorView.stopAnimating()
    viewModel.didFailNavigation(with: error)
  }

  public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    activityIndicatorView.stopAnimating()
    viewModel.didFailNavigation(with: error)
  }

  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    activityIndicatorView.stopAnimating()
  }
}

// MARK: - WKUIDelegate
extension WebPaymentsViewController: WKUIDelegate {
  public func webView(
    _ webView: WKWebView,
    createWebViewWith configuration: WKWebViewConfiguration,
    for navigationAction: WKNavigationAction,
    windowFeatures: WKWindowFeatures
  ) -> WKWebView? {
    webView.load(navigationAction.request)
    return nil
  }
}
