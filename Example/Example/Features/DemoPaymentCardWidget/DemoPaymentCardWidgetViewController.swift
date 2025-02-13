//
//  DemoPaymentCardWidgetViewController.swift
//  Example
//
//  Created by PayU S.A. on 15/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import PUSDK
import UIKit

protocol DemoPaymentCardWidgetViewControllerDelegate: AnyObject {
  func demoPaymentCardWidgetViewController(_ viewController: DemoPaymentCardWidgetViewController, didComplete cardToken: CardToken)
}

final class DemoPaymentCardWidgetViewController: ViewController {

  // MARK: - Properties
  weak var delegate: DemoPaymentCardWidgetViewControllerDelegate?

  // MARK: - Private Properties
  private let viewModel: DemoPaymentCardWidgetViewModel

  // MARK: - Initialization
  required init() {
    let service = PaymentCardService.Factory().make()
    viewModel = DemoPaymentCardWidgetViewModel(service: service)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
    Console.console.log()
  }

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupBasics()
    setupViewModel()
    setupObservers()
  }

  // MARK: - Privar Methods
  private func setupBasics() {
    title = Feature.demoPaymentCardWidget.title
  }

  private func setupViewModel() {
    viewModel.delegate = self
  }

  private func setupObservers() {
    NotificationCenter.default
      .addObserver(
        self,
        selector: #selector(DemoPaymentCardWidgetViewController.actionDidTapHintAccessoryViewInCVVField(_:)),
        name: NSNotification.Name.PayU.PaymentCardWidget.didTapHintAccessoryViewInCVVField,
        object: nil)
  }

  // MARK: - Actions
  @objc private func actionSaveAndUse(_ sender: Any) {
    viewModel.tokenize(type: TokenType.MULTI)
    Console.console.log()
  }

  @objc private func actionUse(_ sender: Any) {
    viewModel.tokenize(type: TokenType.SINGLE)
    Console.console.log()
  }

  @objc private func actionUseLongTerm(_ sender: Any) {
    viewModel.tokenize(type: TokenType.SINGLE_LONGTERM)
    Console.console.log()
  }

  @objc private func actionDidTapHintAccessoryViewInCVVField(_ sender: Any) {
    dialog(title: "NotificationCenter", message: "didTapHintAccessoryViewInCVVField")
  }
}

// MARK: - DemoPaymentCardWidgetViewModelDelegate
extension DemoPaymentCardWidgetViewController: DemoPaymentCardWidgetViewModelDelegate {
  func demoPaymentCardWidgetViewModel(_ viewModel: DemoPaymentCardWidgetViewModel, didComplete cardToken: CardToken) {
    delegate?.demoPaymentCardWidgetViewController(self, didComplete: cardToken)
    Console.console.log()
  }

  func demoPaymentCardWidgetViewModel(_ viewModel: DemoPaymentCardWidgetViewModel, didFail error: Error) {
    dialog(message: error.localizedDescription)
    Console.console.log()
  }
}

private extension DemoPaymentCardWidgetViewController {
  func setupView() {
    func makeWidgetView() -> UIView {
      return PaymentCardWidget.Factory().make(
        configuration: viewModel.configuration,
        service: viewModel.service)
    }

    func makeSaveAndUseButtonView() -> UIView {
      let button = UIButton(type: .system)
      button.setTitle("Save And Use", for: .normal)
      button.addTarget(self, action: #selector(actionSaveAndUse(_:)), for: .touchUpInside)
      return button
    }

    func makeUseButtonView() -> UIView {
      let button = UIButton(type: .system)
      button.setTitle("Use", for: .normal)
      button.addTarget(self, action: #selector(actionUse(_:)), for: .touchUpInside)
      return button
    }

    func makeUseLongTermButtonView() -> UIView {
      let button = UIButton(type: .system)
      button.setTitle("Use (long term)", for: .normal)
      button.addTarget(self, action: #selector(actionUseLongTerm(_:)), for: .touchUpInside)
      return button
    }

    func makeEmptyView() -> UIView {
      return UIView()
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

    stackView.addArrangedSubview(makeWidgetView())
    stackView.addArrangedSubview(makeSaveAndUseButtonView())
    stackView.addArrangedSubview(makeUseButtonView())
    stackView.addArrangedSubview(makeUseLongTermButtonView())
    stackView.addArrangedSubview(makeEmptyView())
  }
}
