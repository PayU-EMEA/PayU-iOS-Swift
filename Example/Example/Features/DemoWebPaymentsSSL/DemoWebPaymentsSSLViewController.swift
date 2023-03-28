//
//  DemoWebPaymentsSSLViewController.swift
//  Example
//
//  Created by PayU S.A. on 06/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import PUSDK
import UIKit

final class DemoWebPaymentsSSLViewController: ListViewController<ListViewCell>, DemoWebPaymentsSSLViewModelDelegate, WebPaymentsViewControllerDelegate {

  // MARK: - Private Properties
  private let viewModel: DemoWebPaymentsSSLViewModel

  // MARK: - Initialization
  required init() {
    self.viewModel = DemoWebPaymentsSSLViewModel()
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

  // MARK: - Private Methods
  private func setupBasics() {
    title = Feature.demoWebPaymentsSSL.title
  }

  private func setupViewModel() {
    viewModel.delegate = self
  }


  // MARK: - Overrides
  override func numberOfRows(in section: Int) -> Int {
    return viewModel.domains.count
  }

  override func content(at indexPath: IndexPath) -> ListViewCell.Content {
    return ListViewCell.Content(
      title: viewModel.domains[indexPath.row],
      accessoryType: .disclosureIndicator)
  }

  override func didSelectRow(at indexPath: IndexPath) {
    viewModel.didSelect(at: indexPath)
  }

  // MARK: - DemoWebPaymentsSSLViewModelDelegate
  func demoWebPaymentsSSLViewModel(_ viewModel: DemoWebPaymentsSSLViewModel, shouldPresentWebPayments request: WebPaymentsRequest) {
    let viewController = WebPaymentsViewController.Factory().make(request: request)
    let navigationController = UINavigationController(rootViewController: viewController)
    present(navigationController, animated: true)
    viewController.delegate = self
  }
  // MARK: - WebPaymentsViewControllerDelegate
  func webPaymentsViewController(_ viewController: WebPaymentsViewController, didComplete result: WebPaymentsResult) {
    viewController.navigationController?.dismiss(animated: true) {
      self.dialog(title: "WebPaymentsResult", message: "status: \(result.status)")
    }
  }

}

