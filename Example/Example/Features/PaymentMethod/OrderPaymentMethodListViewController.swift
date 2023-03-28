//
//  OrderPaymentMethodListViewController.swift
//  Example
//
//  Created by PayU S.A. on 30/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit
import PUSDK

final class OrderPaymentMethodListViewController: ListViewController<ListViewCell>, OrderPaymentMethodViewModelDelegate, OrderPaymentMethodViewModelPresenter, PaymentMethodsViewControllerDelegate {

  // MARK: - Private Properties
  private let viewModel: OrderPaymentMethodViewModel
  private lazy var createOrderItem = UIBarButtonItem(title: "Create Order", style: .plain, target: self, action: #selector(actionCreateOrder(_:)))

  // MARK: - Initialization
  required init() {
    self.viewModel = OrderPaymentMethodViewModel()
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewModel()
    setupBasics()
    setupData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setToolbarHidden(false, animated: true)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setToolbarHidden(true, animated: true)
  }

  // MARK: - Private Methods
  private func setupBasics() {
    title = "Example · Payment Method"

    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    toolbarItems = [spacer, createOrderItem, spacer]
  }

  private func setupData() {
    createOrderItem.isEnabled = viewModel.canCreateOrder()
    performUpdates()
  }

  private func setupViewModel() {
    viewModel.delegate = self
    viewModel.presenter = self
  }

  // MARK: - Actions
  @objc private func actionCreateOrder(_ sender: Any) {
    viewModel.didTapCreateOrder()
  }

  // MARK: - Overrides
  override func numberOfRows(in section: Int) -> Int {
    return viewModel.items.count
  }

  override func content(at indexPath: IndexPath) -> ListViewCell.Content {
    return ListViewCell.Content(
      title: viewModel.items[indexPath.row].title,
      subtitle: viewModel.items[indexPath.row].subtitle,
      accessoryType: .disclosureIndicator
    )
  }

  override func didSelectRow(at indexPath: IndexPath) {
    viewModel.didSelectItem(viewModel.items[indexPath.row])
  }

  // MARK: - OrderPaymentMethodViewModelDelegate
  func orderPaymentMethodViewModelDidUpdate(_ viewModel: OrderPaymentMethodViewModel) {
    setupData()
  }

  func orderPaymentMethodViewModel(_ viewModel: OrderPaymentMethodViewModel, shouldPresentPaymentMethods configuration: PaymentMethodsConfiguration) {
    let viewController = PaymentMethodsViewController.Factory().make(configuration: configuration, storage: PaymentMethodsDatabase.database)
    navigationController?.pushViewController(viewController, animated: true)
    viewController.delegate = self
  }

  // MARK: - OrderPaymentMethodViewModelPresenter
  var presenterViewController: UIViewController? {
    return self
  }

  // MARK: - PaymentMethodsViewControllerDelegate
  func viewController(_ viewController: PaymentMethodsViewController, didSelect paymentMethod: PaymentMethod) {
    viewController.navigationController?.popViewController(animated: true)
    viewModel.didSelectPaymentMethod(paymentMethod)
  }

  func viewController(_ viewController: PaymentMethodsViewController, didDelete paymentMethod: PaymentMethod) {
    Console.console.log()
  }
}
