//
//  PaymentCardWidget.swift
//  
//  Created by PayU S.A. on 12/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

#if canImport(PUTranslations)
import PUTranslations
#endif

/// This class allows to put the ``PaymentCardWidget`` in any ViewController you want with the ``PaymentCardWidget/Configuration``
public final class PaymentCardWidget: UIView {

  // MARK: - Factory

  /// Factory which allows to create the ``PaymentCardWidget`` instance
  public final class Factory {

    // MARK: - Private Properties
    private let assembler = PaymentCardAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Public Methods
    /// Returns default implementation for ``PaymentCardWidget``
    /// - Parameters:
    ///   - configuration: ``PaymentCardWidget/Configuration`` instance which allows to setup the elements of the widget
    ///   - service: ``PaymentCardServiceProtocol`` implementation to which is the service for widget with validation and  tokenization incapsulation.
    /// - Returns: Default implementation for ``PaymentCardWidget``
    public func make(
      configuration: PaymentCardWidget.Configuration,
      service: PaymentCardServiceProtocol
    ) -> PaymentCardWidget {
      assembler.makePaymentCardWidget(
        configuration: configuration,
        service: service)
    }
  }

  // MARK: - Configuration

  /// Allows to setup the elements of the ``PaymentCardWidget``
  public struct Configuration {

    // MARK: - Decoration

    /// Allows to setup the elements of each text input field
    public struct Decoration {

      ///  Default value for cvv text input field
      public static let cvv = Decoration(hintText: "cvv_code")

      ///  Default value for date text input field
      public static let date = Decoration(hintText: "MM/YY")

      ///  Default value for number text input field
      public static let number = Decoration(hintText: "card_number")

      // MARK: - Public Properties

      ///  Placeholder for text input field
      public let hintText: String

      ///  Subtitle for text input field
      public let labelText: String?

      // MARK: - Initialization
      public init(hintText: String, labelText: String? = nil) {
        self.hintText = hintText
        self.labelText = labelText
      }

      // MARK: - Public Methods


      /// Creates the copy of current instance with changed `labelText`
      /// - Parameter labelText: New value for `labelText`
      /// - Returns: The copy of current instance with changed `labelText`
      public func copyWith(labelText: String) -> Decoration {
        return Decoration(
          hintText: hintText,
          labelText: labelText)
      }
    }

    // MARK: - Public Properties

    /// Indicates if to display header (text and horizontal line). Default is **true**
    public let shouldDisplayHeader: Bool

    /// Indicates if to display payment card providers stack. Default is **true**
    public let shouldDisplayCardProviders: Bool

    /// Indicates if to display payment card provider in the number input text field. Default is **false**
    public let shouldDisplayCardProvidersInTextField: Bool

    /// Indicates if to display the information stack at the bottom of the screen. Default is **true**
    public let shouldDisplayTermsAndConditions: Bool

    /// Indicates if to display the Scanner button in the number input text field. Default is **false**
    public let shouldDisplayCardScannerInNumberInputField: Bool

    /// Holder for ``PaymentCardWidget/Configuration/Decoration`` instance for cvv input text field
    public let cvvDecoration: Configuration.Decoration

    /// Holder for ``PaymentCardWidget/Configuration/Decoration`` instance for number input text field
    public let numberDecoration: Configuration.Decoration

    /// Holder for ``PaymentCardWidget/Configuration/Decoration`` instance for date input text field
    public let dateDecoration: Configuration.Decoration

    // MARK: - Initialization
    public init(
      shouldDisplayHeader: Bool = true,
      shouldDisplayCardProviders: Bool = true,
      shouldDisplayCardProvidersInTextField: Bool = false,
      shouldDisplayTermsAndConditions: Bool = true,
      shouldDisplayCardScannerInNumberInputField: Bool = true,
      cvvDecoration: Configuration.Decoration = .cvv,
      dateDecoration: Configuration.Decoration = .date,
      numberDecoration: Configuration.Decoration = .number) {

        self.shouldDisplayHeader = shouldDisplayHeader
        self.shouldDisplayCardProviders = shouldDisplayCardProviders
        self.shouldDisplayTermsAndConditions = shouldDisplayTermsAndConditions

        self.shouldDisplayCardProvidersInTextField = shouldDisplayCardProvidersInTextField
        self.shouldDisplayCardScannerInNumberInputField = shouldDisplayCardScannerInNumberInputField

        self.cvvDecoration = cvvDecoration
        self.dateDecoration = dateDecoration
        self.numberDecoration = numberDecoration
      }
  }

  // MARK: - Private Properties
  private let configuration: Configuration
  private let service: PaymentCardServiceProtocol
  private var _service: PaymentCardServiceInternalProtocol?

  private let paymentCardProvidersView: PaymentCardProvidersView

  private let cvvTextInputView: PaymentCardTextInputView
  private let dateTextInputView: PaymentCardTextInputView
  private let numberTextInputView: PaymentCardTextInputView

  // MARK: - Initialization
  init(
    configuration: Configuration,
    service: PaymentCardServiceProtocol,
    paymentCardFormatterCVV: PaymentCardFormatterProtocol,
    paymentCardFormatterDate: PaymentCardFormatterProtocol,
    paymentCardFormatterNumber: PaymentCardFormatterProtocol,
    paymentCardValidatorCVV: PaymentCardValidatorProtocol,
    paymentCardValidatorDate: PaymentCardValidatorProtocol,
    paymentCardValidatorNumber: PaymentCardValidatorProtocol
  ) {

    self.configuration = configuration
    self.service = service
    self._service = service as? PaymentCardServiceInternalProtocol

    paymentCardProvidersView = PaymentCardProvidersView()

    cvvTextInputView = PaymentCardTextInputView(
      decoration: configuration.cvvDecoration,
      formatter: paymentCardFormatterCVV,
      validator: paymentCardValidatorCVV)

    dateTextInputView = PaymentCardTextInputView(
      decoration: configuration.dateDecoration,
      formatter: paymentCardFormatterDate,
      validator: paymentCardValidatorDate)

    numberTextInputView = PaymentCardTextInputView(
      decoration: configuration.numberDecoration,
      formatter: paymentCardFormatterNumber,
      validator: paymentCardValidatorNumber)

    super.init(frame: .zero)
    setupLayout()
    setupService()
    setupGestures()

    cvvTextInputView.onTextDidChange = { [weak self] text in self?._service?.didChangeCVV(text) }
    cvvTextInputView.onHintAccessoryTap = { [weak self] in self?._service?.didTapHintCVV() }

    dateTextInputView.onTextDidChange = { [weak self] text in self?._service?.didChangeDate(text) }
    numberTextInputView.onTextDidChange = { [weak self] text in self?._service?.didChangeNumber(text) }

    cvvTextInputView.keyboardType = .numberPad
    dateTextInputView.keyboardType = .numberPad
    numberTextInputView.keyboardType = .numberPad

    cvvTextInputView.nextActiveResponder = nil
    dateTextInputView.nextActiveResponder = cvvTextInputView
    numberTextInputView.nextActiveResponder = dateTextInputView

    updatePaymentCardProviderInSeparateView()
    updatePaymentCardProviderInNumberInputField()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions
  @objc private func actionTap(_ sender: Any) {
    endEditing(true)
  }

  // MARK: - Private Methods
  private func setupGestures() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(actionTap(_:)))
    addGestureRecognizer(tap)
  }

  private func setupService() {
    _service?.delegate = self
  }

  private func updatePaymentCardProviderInSeparateView() {
    paymentCardProvidersView.paymentCardProvider = _service?.paymentCardProvider
  }

  private func updatePaymentCardProviderInNumberInputField() {
    if configuration.shouldDisplayCardProvidersInTextField {
      let brandImageProvider = _service?.paymentCardProvider?.brandImageProvider
      numberTextInputView.leadingImageProvider = brandImageProvider ?? BrandImageProvider.creditcard
    }
  }
}

// MARK: - PaymentCardServiceDelegate
extension PaymentCardWidget: PaymentCardServiceDelegate {
  func paymentCardServiceShouldValidate(_ service: PaymentCardService) throws {
    try? cvvTextInputView.validate()
    try? dateTextInputView.validate()
    try? numberTextInputView.validate()

    try cvvTextInputView.validate()
    try dateTextInputView.validate()
    try numberTextInputView.validate()
  }

  func paymentCardServiceShouldUpdate(_ service: PaymentCardService) {
    cvvTextInputView.text = service.cvv
    dateTextInputView.text = service.date
    numberTextInputView.text = service.number
  }

  func paymentCardServiceShouldUpdatePaymentCardProvider(_ service: PaymentCardService) {
    updatePaymentCardProviderInSeparateView()
    updatePaymentCardProviderInNumberInputField()
  }
}

private extension PaymentCardWidget {
  func setupLayout() {
    func makeInformationView() -> UIView {
      func makeLabel() -> UIView {
        let label = PULabel(style: PUTheme.theme.textTheme.caption)
        label.text = "new_card".localized()
        return label
      }

      func makeLine() -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = PUTheme.theme.colorTheme.secondaryGray3
        return view
      }

      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.spacing = 8.0
      stackView.distribution = .fill
      stackView.alignment = .center
      stackView.addArrangedSubview(makeLabel())
      stackView.addArrangedSubview(makeLine())
      return stackView
    }

    func makeProvidersView() -> UIView {
      paymentCardProvidersView
    }

    func makePaymentCardView() -> UIView {
      func makePaymentCardTopView() -> UIView {
        return numberTextInputView
      }
      
      func makePaymentCardBottomView() -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16.0
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(dateTextInputView)
        stackView.addArrangedSubview(cvvTextInputView)
        return stackView
      }

      let stackView = UIStackView()
      stackView.axis = .vertical
      stackView.spacing = 0.0
      stackView.addArrangedSubview(makePaymentCardTopView())
      stackView.addArrangedSubview(makePaymentCardBottomView())
      return stackView
    }

    func makeTermsAndConditionsView() -> UIView {
      return TermsAndConditionsView()
    }

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16.0
    stackView.distribution = .fill
    stackView.alignment = .fill

    if let secureView = SecureField().secureContainer {
      secureView.addSubview(stackView)
      stackView.pinEdges()
      addSubview(secureView)
      secureView.pinEdges()
    } else {
      addSubview(stackView)
    }

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

    if configuration.shouldDisplayHeader { stackView.addArrangedSubview(makeInformationView()) }
    if configuration.shouldDisplayCardProviders { stackView.addArrangedSubview(makeProvidersView()) }
    stackView.addArrangedSubview(makePaymentCardView())
    if configuration.shouldDisplayTermsAndConditions { stackView.addArrangedSubview(makeTermsAndConditionsView()) }
  }
}

extension UIView {
    func pin(_ type: NSLayoutConstraint.Attribute) {
      translatesAutoresizingMaskIntoConstraints = false
      let constraint = NSLayoutConstraint(item: self, attribute: type,
                                          relatedBy: .equal,
                                          toItem: superview, attribute: type,
                                          multiplier: 1, constant: 0)

      constraint.priority = UILayoutPriority.init(999)
      constraint.isActive = true
  }

  func pinEdges() {
      pin(.top)
      pin(.bottom)
      pin(.leading)
      pin(.trailing)
  }
}
