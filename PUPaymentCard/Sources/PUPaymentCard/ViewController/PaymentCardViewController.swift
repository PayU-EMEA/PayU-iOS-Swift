//
//  PaymentCardViewController.swift
//  
//  Created by PayU S.A. on 12/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUPaymentCardScanner)
import PUPaymentCardScanner
#endif

#if canImport(PUTheme)
import PUTheme
#endif

#if canImport(PUTranslations)
import PUTranslations
#endif

/// Protocol which defines the completion result of ``PaymentCardViewController``
public protocol PaymentCardViewControllerDelegate: AnyObject {
  /// This method is called when user tokenized the payment card
  /// - Parameters:
  ///   - viewController: Instance of ``PaymentCardViewController`` from where the action was triggered
  ///   - cardToken: `CardToken` instance which contains information about the tokenized card
  func paymentCardViewController(_ viewController: PaymentCardViewController, didComplete cardToken: CardToken)
}

/// ViewController which is responsible for payment card tokenization
public final class PaymentCardViewController: UIViewController {
  
  // MARK: - Factory
  /// Factory which allows to create the ``PaymentCardViewController`` instance
  public struct Factory {

    // MARK: - Private Properties
    private let assembler = PaymentCardAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Public Methods
    /// Returns default implementation for ``PaymentCardViewController``
    /// - Parameter configuration: ``PaymentCardViewController/Configuration`` instance
    /// - Returns: Default implementation for ``PaymentCardViewController``
    public func make(configuration: PaymentCardViewController.Configuration) -> PaymentCardViewController {
      assembler.makePaymentCardViewController(configuration: configuration)
    }
  }
  
  // MARK: - Configuration

  /// Allows to customize the behavior of ``PaymentCardViewController``
  public struct Configuration {
    
    // MARK: - Public Properties

    /// Allows to display or hide example card screen (use it for testing). Default is **false**
    public let shouldDisplayExampleCards: Bool

    /// Allows to display or hide scan card button (use it for testing). Default is **true**
    public let shouldDisplayScanCardButton: Bool
    
    // MARK: - Initialization
    public init(
      shouldDisplayExampleCards: Bool = false,
      shouldDisplayScanCardButton: Bool = true
    ) {
      self.shouldDisplayExampleCards = shouldDisplayExampleCards
      self.shouldDisplayScanCardButton = shouldDisplayScanCardButton
    }
  }
  
  // MARK: - Public Properties
  public weak var delegate: PaymentCardViewControllerDelegate?
  
  // MARK: - Private Properties
  private let configuration: Configuration
  private let viewModel: PaymentCardViewModel
  
  // MARK: - Initialization
  required init(configuration: Configuration, viewModel: PaymentCardViewModel) {
    self.configuration = configuration
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupViewModel()
    setupNavigationItems()
    
    view.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    navigationItem.titleView = PUImageView(brandImageProvider: .logo)
  }
  
  // MARK: - Privar Methods
  private func setupViewModel() {
    viewModel.delegate = self
  }
  
  private func setupNavigationItems() {
#if DEBUG
    if configuration.shouldDisplayExampleCards {
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        image: .creditcard,
        style: .plain,
        target: self,
        action: #selector(actionOpenTestCards(_:)))
      navigationItem.rightBarButtonItem?.tintColor = PUTheme.theme.colorTheme.primary2
    }
#endif
  }
  
  // MARK: - Actions
  @objc private func actionOpenTestCards(_ sender: Any) {
    viewModel.didTapOpenTestCards(in: self)
  }

  @objc private func actionScanCard(_ sender: Any) {
    viewModel.didTapScanCard(in: self)
  }

  @objc private func actionSaveAndUse(_ sender: Any) {
    viewModel.didTapSaveAndUse()
  }
  
  @objc private func actionUse(_ sender: Any) {
    viewModel.didTapUse()
  }
}

private extension PaymentCardViewController {
  func setupView() {
    func makeWidgetView() -> UIView {
      return PaymentCardWidget.Factory().make(
        configuration: PaymentCardWidget.Configuration(shouldDisplayTermsAndConditions: false),
        service: viewModel.service)
    }

    func makeScanCardButtonView() -> UIView {
      let button = PUPrimaryButton()
      let title = "scan_card".localized()
      button.setTitle(title, for: .normal)
      button.setImage(UIImage.camera, for: .normal)
      button.addTarget(self, action: #selector(actionScanCard(_:)), for: .touchUpInside)
      return button
    }

    func makeSaveAndUseButtonView() -> UIView {
      let button = PUPrimaryButton()
      let title = "save_and_use".localized()
      button.setTitle(title, for: .normal)
      button.addTarget(self, action: #selector(actionSaveAndUse(_:)), for: .touchUpInside)
      return button
    }
    
    func makeUseButtonView() -> UIView {
      let button = PUSecondaryButton()
      let title = "use".localized()
      button.setTitle(title, for: .normal)
      button.addTarget(self, action: #selector(actionUse(_:)), for: .touchUpInside)
      return button
    }
    
    func makeEmptyView() -> UIView {
      return UIView()
    }
    
    func makeTermsAndConditionsView() -> UIView {
      return TermsAndConditionsView()
    }
    
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
    scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant:16.0).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16.0).isActive = true
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16.0
    stackView.distribution = .fill
    scrollView.addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

    let canDisplayScanCardButton = PaymentCardScanner.isAvailable()
    let shouldDisplayScanCardButton = configuration.shouldDisplayScanCardButton

    stackView.addArrangedSubview(makeWidgetView())
    if canDisplayScanCardButton && shouldDisplayScanCardButton {
      stackView.addArrangedSubview(makeScanCardButtonView())
    }
    stackView.addArrangedSubview(makeSaveAndUseButtonView())
    stackView.addArrangedSubview(makeUseButtonView())
    stackView.addArrangedSubview(makeEmptyView())
    
    let termsAndConditionsWidget = makeTermsAndConditionsView()
    view.addSubview(termsAndConditionsWidget)
    termsAndConditionsWidget.translatesAutoresizingMaskIntoConstraints = false
    termsAndConditionsWidget.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
    termsAndConditionsWidget.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
    termsAndConditionsWidget.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
  }
}

// MARK: - PaymentCardViewModelDelegate
extension PaymentCardViewController: PaymentCardViewModelDelegate {
  func paymentCardViewModel(_ viewModel: PaymentCardViewModel, didComplete cardToken: CardToken) {
    view.endEditing(true)
    delegate?.paymentCardViewController(self, didComplete: cardToken)
  }
  
  func paymentCardViewModel(_ viewModel: PaymentCardViewModel, didFail error: Error) {
    let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel))
    present(alertController, animated: true)
  }
}
