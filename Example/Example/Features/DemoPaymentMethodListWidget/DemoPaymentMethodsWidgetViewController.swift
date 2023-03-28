//
//  DemoPaymentMethodsWidgetViewController.swift
//  Example
//
//  Created by PayU S.A. on 23/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import PUSDK
import UIKit

final class DemoPaymentMethodsWidgetViewController: ViewController {

  // MARK: - Private Properties
  private var payBarButtonItem: UIBarButtonItem!
  private let viewModel: DemoPaymentMethodsWidgetViewModel
  private let configuration: PaymentMethodsConfiguration
  private let widget: PaymentMethodsWidget

  // MARK: - Initialization
  required init(configuration: PaymentMethodsConfiguration) {
    let storage = PaymentMethodsDatabase.database
    self.widget = PaymentMethodsWidget.Factory().make(configuration: configuration, storage: storage)
    self.viewModel = DemoPaymentMethodsWidgetViewModel()
    self.configuration = configuration
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBasics()
    setupViewModel()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setToolbarHidden(false, animated: true)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setToolbarHidden(true, animated: true)
  }

  // MARK: - Private Methods
  private func setupBasics() {
    title = Feature.demoPaymentMethodsWidget.title
    widget.delegate = self
    widget.presentingViewController = self
    view.addSubview(widget)

    widget.translatesAutoresizingMaskIntoConstraints = false
    widget.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    widget.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0).isActive = true
    widget.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

    payBarButtonItem = UIBarButtonItem(title: "Pay", style: .plain, target: self, action: #selector(actionAdd(_:)))
    payBarButtonItem.isEnabled = false

    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    toolbarItems = [spacer, payBarButtonItem, spacer]
  }

  private func setupViewModel() {
    viewModel.presenter = self
  }

  // MARK: - Actions
  @objc private func actionAdd(_ sender: Any) {
    if let paymentMethod = widget.paymentMethod {
      Console.console.log(paymentMethod)
      viewModel.didSelect(paymentMethod)
    }
  }
}

// MARK: - PaymentMethodsWidgetDelegate
extension DemoPaymentMethodsWidgetViewController: PaymentMethodsWidgetDelegate {
  func paymentMethodsWidget(_ widget: PaymentMethodsWidget, didSelect paymentMethod: PaymentMethod) {
    payBarButtonItem.isEnabled = true
    Console.console.log(paymentMethod)
  }

  func paymentMethodsWidget(_ widget: PaymentMethodsWidget, didDelete paymentMethod: PaymentMethod) {
    viewModel.didDelete(paymentMethod)
    Console.console.log(paymentMethod)
  }
}

// MARK: - DemoPaymentMethodsWidgetViewModelPresenter
extension DemoPaymentMethodsWidgetViewController: DemoPaymentMethodsWidgetViewModelPresenter {
  var presenterViewController: UIViewController? {
    self
  }
}
