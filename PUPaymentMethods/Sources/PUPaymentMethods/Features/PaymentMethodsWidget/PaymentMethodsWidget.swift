//
//  PaymentMethodsWidget.swift
//
//  Copyright © PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

/// Protocol which defines the completion result of ``PaymentMethodsWidget``
public protocol PaymentMethodsWidgetDelegate: AnyObject {

  /// This method is called when user select the `PaymentMethod`
  /// - Parameters:
  ///   - widget: Instance of ``PaymentMethodsWidget`` from where the action was triggered
  ///   - paymentMethod: `PaymentMethod` instance which was selected
  func paymentMethodsWidget(_ widget: PaymentMethodsWidget, didSelect paymentMethod: PaymentMethod)

  /// This method is called when user try to delete the `PaymentMethod` (only `CardToken` can be deleted). Remove it on backend as well ([developers.payu.com](https://developers.payu.com/en/card_tokenization.html#deleting_tokens))
  /// - Parameters:
  ///   - widget: Instance of ``PaymentMethodsWidget`` from where the action was triggered
  ///   - paymentMethod: `PaymentMethod` instance to delete
  func paymentMethodsWidget(_ widget: PaymentMethodsWidget, didDelete paymentMethod: PaymentMethod)
}

public final class PaymentMethodsWidget: UIView {

  // MARK: - Factory
  /// Factory which allows to create the ``PaymentMethodsWidget`` instance
  public struct Factory {
    // MARK: - Private Properties
    private let assembler = PaymentMethodsAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Publuc Methods
    /// Returns default implementation for ``PaymentMethodsWidget``
    /// - Parameter configuration: ``PaymentMethodsConfiguration`` instance
    /// - Parameter storage: Optional ``PaymentMethodsStorageProtocol`` instance, where last selected payment method value might be written
    /// - Returns: Default implementation for ``PaymentMethodsWidget``
    public func make(
      configuration: PaymentMethodsConfiguration,
      storage: PaymentMethodsStorageProtocol?
    ) -> PaymentMethodsWidget {
      PaymentMethodsWidget(
        viewModel: assembler.makePaymentMethodsWidgetViewModel(
          configuration: configuration,
          storage: storage),
        service: assembler.makePaymentMethodsService(
          storage: storage),
        configuration: configuration
        )
    }
  }

  // MARK: - Public Properties

  /// Returns selected `PaymentMethod`
  public var paymentMethod: PaymentMethod? { viewModel.paymentMethod }

  public weak var delegate: PaymentMethodsWidgetDelegate?
  public weak var presentingViewController: UIViewController?

  // MARK: - Private Properties
  private let viewModel: PaymentMethodsWidgetViewModel
  private let service: PaymentMethodsServiceProtocol
  private let configuration: PaymentMethodsConfiguration

  private let paymentMethodImageView = PUImageView()
  private let paymentMethodTitleLabel = PULabel(style: PUTheme.theme.textTheme.subtitle1)
  private let paymentMethodSubtitleLabel = PULabel(style: PUTheme.theme.textTheme.bodyText2)

  private let blikTokenButton = PUTextButton()
  private let blikCodeTextField = PUTextField()

  // MARK: - Initialization
  required init(viewModel: PaymentMethodsWidgetViewModel, service: PaymentMethodsServiceProtocol, configuration: PaymentMethodsConfiguration) {
    self.viewModel = viewModel
    self.service = service
    self.configuration = configuration

    super.init(frame: .zero)

    setupLayout()
    setupAppearance()
    initState()
    setupViewModel()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods
  private func setupAppearance() {
    backgroundColor = PUTheme.theme.colorTheme.secondaryGray4

    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionDidTapWidget(_:)))
    addGestureRecognizer(tapGestureRecognizer)
    isUserInteractionEnabled = true

    blikTokenButton.setTitle("enter_new_blik_code".localized(), for: .normal)
    blikTokenButton.addTarget(self, action: #selector(actionDidTapEnterNewBlikCode(_:)), for: .touchUpInside)

    blikCodeTextField.placeholder = "enter_blik_code".localized()
    blikCodeTextField.delegate = self
  }

  private func initState() {
    if let paymentMethod = service.getSavedPaymentMethod(for: configuration) {
      setupState(.paymentMethod(paymentMethod))
      viewModel.didSelect(paymentMethod)
    } else {
      setupState(.initial)
    }
  }

  private func setupState(_ state: PaymentMethodsWidgetState) {
    let factory = PaymentMethodsWidgetStateDecoratorFactory()
    let decorator = factory.decorator(state)

    paymentMethodTitleLabel.text = decorator.title
    paymentMethodSubtitleLabel.text = decorator.subtitle
    paymentMethodImageView.brandImageProvider = decorator.logo

    paymentMethodImageView.isHidden = !decorator.isPaymentMethodLogoVisible
    paymentMethodTitleLabel.isHidden = !decorator.isPaymentMethodTitleVisible
    paymentMethodSubtitleLabel.isHidden = !decorator.isPaymentMethodSubtitleVisible
    blikTokenButton.isHidden = !decorator.isBlikTokenButtonVisible
    blikCodeTextField.isHidden = !decorator.isBlikCodeTextInputViewVisible
  }

  private func setupViewModel() {
    viewModel.delegate = self
  }

  // MARK: - Actions
  @objc private func actionDidTapWidget(_ sender: Any) {
    viewModel.didTapWidget()
  }

  @objc private func actionDidTapEnterNewBlikCode(_ sender: Any) {
    viewModel.didTapEnterNewBlikCode()
  }
}

// MARK: - UITextFieldDelegate
extension PaymentMethodsWidget: UITextFieldDelegate {
  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return false }
    let editedText = (text as NSString).replacingCharacters(in: range, with: string)
    let formattedBlikAuthorizationCode = viewModel.formattedBlikAuthorizationCode(editedText)
    viewModel.didEnterNewBlikCode(formattedBlikAuthorizationCode)
    textField.text = formattedBlikAuthorizationCode
    return false
  }
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

// MARK: - PaymentMethodsWidgetViewModelDelegate
extension PaymentMethodsWidget: PaymentMethodsWidgetViewModelDelegate {
  func viewModel(_ viewModel: PaymentMethodsWidgetViewModel, didUpdateState state: PaymentMethodsWidgetState) {
    setupState(state)
  }

  func viewModel(_ viewModel: PaymentMethodsWidgetViewModel, shouldPresentPaymentMethods configuration: PaymentMethodsConfiguration, storage: PaymentMethodsStorageProtocol?) {
    let viewController = PaymentMethodsViewController.Factory().make(configuration: configuration, storage: storage)
    let navigationController = UINavigationController(rootViewController: viewController)
    presentingViewController?.present(navigationController, animated: true)
    viewController.delegate = self
  }
}

// MARK: - PaymentMethodsViewControllerDelegate
extension PaymentMethodsWidget: PaymentMethodsViewControllerDelegate {
  public func viewController(_ viewController: PaymentMethodsViewController, didSelect paymentMethod: PaymentMethod) {
    viewController.navigationController?.dismiss(animated: true)
    delegate?.paymentMethodsWidget(self, didSelect: paymentMethod)
    viewModel.didSelect(paymentMethod)
  }
  public func viewController(_ viewController: PaymentMethodsViewController, didDelete paymentMethod: PaymentMethod) {
    delegate?.paymentMethodsWidget(self, didDelete: paymentMethod)
    viewModel.didDelete(paymentMethod)
  }
}

// MARK: - Layout
private extension PaymentMethodsWidget {
  private func setupLayout() {
    let contentVerticalStackView = UIStackView()
    contentVerticalStackView.axis = .vertical
    contentVerticalStackView.alignment = .fill
    contentVerticalStackView.distribution = .fill
    contentVerticalStackView.spacing = 8.0
    addSubview(contentVerticalStackView)

    contentVerticalStackView.pinToSuperviewLeft(withConstant: 16.0)
    contentVerticalStackView.pinToSuperviewTop(withConstant: 8.0)
    contentVerticalStackView.pinToSuperviewRight(withConstant: -16.0)
    contentVerticalStackView.pinToSuperviewBottom(withConstant: 8.0)

    let paymentMethodHorizontalStackView = UIStackView()
    paymentMethodHorizontalStackView.axis = .horizontal
    paymentMethodHorizontalStackView.alignment = .center
    paymentMethodHorizontalStackView.distribution = .fill
    paymentMethodHorizontalStackView.spacing = 8.0

    let logoImageView = PUImageView(brandImageProvider: .logo)
    logoImageView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
    logoImageView.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
    paymentMethodHorizontalStackView.addArrangedSubview(logoImageView)

    let verticalDividerView = UIView()
    verticalDividerView.backgroundColor = PUTheme.theme.colorTheme.secondaryGray3
    verticalDividerView.addWidthConstraint(with: 1.0)
    verticalDividerView.addHeightConstraint(with: 24.0)
    paymentMethodHorizontalStackView.addArrangedSubview(verticalDividerView)

    paymentMethodImageView.addWidthConstraint(with: 48.0)
    paymentMethodImageView.addHeightConstraint(with: 48.0)
    paymentMethodHorizontalStackView.addArrangedSubview(paymentMethodImageView)

    let paymentMethodTextsVerticalStackView = UIStackView()
    paymentMethodTextsVerticalStackView.axis = .vertical
    paymentMethodTextsVerticalStackView.addArrangedSubview(paymentMethodTitleLabel)
    paymentMethodTextsVerticalStackView.addArrangedSubview(paymentMethodSubtitleLabel)
    paymentMethodHorizontalStackView.addArrangedSubview(paymentMethodTextsVerticalStackView)

    paymentMethodHorizontalStackView.addArrangedSubview(UIView())

    let imageView = PUImageView(brandImageProvider: .chevronRight)
    imageView.contentMode = .right
    imageView.addWidthConstraint(with: 24)
    imageView.addHeightConstraint(with: 24)
    paymentMethodHorizontalStackView.addArrangedSubview(imageView)

    contentVerticalStackView.addArrangedSubview(paymentMethodHorizontalStackView)
    contentVerticalStackView.addArrangedSubview(blikTokenButton)
    contentVerticalStackView.addArrangedSubview(blikCodeTextField)
  }
}
