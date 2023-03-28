//
//  ProductListViewController.swift
//  Example
//
//  Created by PayU S.A. on 29/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

final class ProductListViewController: ListViewController<ProductCell>, ProductListViewModelDelegate {

  // MARK: - Private Properties
  private let viewModel: ProductListViewModel
  private lazy var payBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(actionPay(_:)))

  // MARK: - Initialization
  required init() {
    self.viewModel = ProductListViewModel()
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
    title = "Example · Products"

    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    toolbarItems = [spacer, payBarButtonItem, spacer]
  }

  private func setupData() {
    payBarButtonItem.title = viewModel.formattedTotalPrice()
    payBarButtonItem.isEnabled = viewModel.totalPrice() > 0
  }

  private func setupViewModel() {
    viewModel.delegate = self
  }

  // MARK: - Actions
  @objc private func actionPay(_ sender: Any) {
    let viewController = OrderPaymentMethodListViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }

  // MARK: - Overrides
  override func numberOfRows(in section: Int) -> Int {
    return viewModel.viewModels.count
  }

  override func content(at indexPath: IndexPath) -> ProductViewModel {
    return viewModel.viewModels[indexPath.row]
  }

  // MARK: - ProductListViewModelDelegate
  func productListViewModelDidUpdate(_ viewModel: ProductListViewModel) {
    setupData()
  }
}
