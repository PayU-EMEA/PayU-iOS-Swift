//
//  PaymentMethodsViewController.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUPaymentCard)
import PUPaymentCard
#endif

#if canImport(PUTheme)
import PUTheme
#endif

#if canImport(PUTranslations)
import PUTranslations
#endif

/// Protocol which defines the completion result of ``PaymentMethodsViewController``
public protocol PaymentMethodsViewControllerDelegate: AnyObject {

  /// This method is called when user select the `PaymentMethod`
  /// - Parameters:
  ///   - viewController: Instance of ``PaymentMethodsViewController`` from where the action was triggered
  ///   - paymentMethod: `PaymentMethod` instance which was selected
  func viewController(_ viewController: PaymentMethodsViewController, didSelect paymentMethod: PaymentMethod)

  /// This method is called when user try to delete the `PaymentMethod` (only `CardToken` can be deleted). Remove it on backend as well ([developers.payu.com](https://developers.payu.com/en/card_tokenization.html#deleting_tokens))
  /// - Parameters:
  ///   - viewController: Instance of ``PaymentMethodsViewController`` from where the action was triggered
  ///   - paymentMethod: `PaymentMethod` instance to delete
  func viewController(_ viewController: PaymentMethodsViewController, didDelete paymentMethod: PaymentMethod)
}

/// ViewController which is responsible for `PaymentMethod` selection
public final class PaymentMethodsViewController: UITableViewController {

  // MARK: - Factory
  /// Factory which allows to create the ``PaymentMethodsViewController`` instance
  public final class Factory {

    // MARK: - Private Properties
    private let assembler = PaymentMethodsAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Public Methods
    /// Returns default implementation for ``PaymentMethodsViewController``
    /// - Parameter configuration: ``PaymentMethodsConfiguration`` instance
    /// - Parameter storage: Optional ``PaymentMethodsStorageProtocol`` instance, where last selected payment method value might be written
    /// - Returns: Default implementation for ``PaymentMethodsViewController``
    public func make(
      configuration: PaymentMethodsConfiguration,
      storage: PaymentMethodsStorageProtocol? = nil
    ) -> PaymentMethodsViewController {
      PaymentMethodsViewController(
        viewModel: assembler.makePaymentMethodsViewModel(
          configuration: configuration,
          storage: storage))
    }
  }

  // MARK: - Public Properties
  public weak var delegate: PaymentMethodsViewControllerDelegate?

  // MARK: - Private Properties
  private let viewModel: PaymentMethodsViewModel
  private let identifier = "Cell"

  // MARK: - Initialization
  init(viewModel: PaymentMethodsViewModel) {
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
  }

  // MARK: - Private Methods
  private func setupBasics() {
    setupNavigationTitleImage(image: PUImageView(brandImageProvider: .logo))
    view.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    tableView.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    tableView.register(PaymentMethodsCell.self, forCellReuseIdentifier: identifier)
    tableView.estimatedRowHeight = 80.0
    tableView.separatorStyle = .none
    tableView.rowHeight = UITableView.automaticDimension
  }

  private func setupViewModel() {
    viewModel.delegate = self
  }
}

// MARK: - UITableViewDataSource
extension PaymentMethodsViewController {
  public override func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.numberOfSections()
  }

  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.numberOfItems(in: section)
  }
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = viewModel.item(at: indexPath)
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PaymentMethodsCell
    let content = PaymentMethodsCell.Content(title: item.title, subtitle: item.subtitle, brandImageProvider: item.brandImageProvider)
    cell.bind(with: content)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension PaymentMethodsViewController {
  public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.didSelectItem(at: indexPath)
  }

  public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    viewModel.canDeleteItem(at: indexPath)
  }

  public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    viewModel.deleteItem(at: indexPath)
  }
}

// MARK: - PaymentMethodsViewModelDelegate
extension PaymentMethodsViewController: PaymentMethodsViewModelDelegate {
  func viewModel(_ viewModel: PaymentMethodsViewModel, didComplete paymentMethod: PaymentMethod) {
    delegate?.viewController(self, didSelect: paymentMethod)
  }

  func viewModel(_ viewModel: PaymentMethodsViewModel, didDelete paymentMethod: PaymentMethod) {
    delegate?.viewController(self, didDelete: paymentMethod)
    tableView.reloadData()
  }

  func viewModel(_ viewModel: PaymentMethodsViewModel, shouldNavigateToBankTransfer configuration: PaymentMethodsConfiguration) {
    let viewController = PBLPaymentMethodsViewController.Factory().make(configuration: configuration)
    navigationController?.pushViewController(viewController, animated: true)
    viewController.delegate = self
  }

  func viewModelDidUpdate(_ viewModel: PaymentMethodsViewModel) {
    tableView.reloadData()
  }

  func viewModelShouldNavigateToCard(_ viewModel: PaymentMethodsViewModel) {
    let configuration = PaymentCardViewController.Configuration()
    let viewController = PaymentCardViewController.Factory().make(configuration: configuration)
    navigationController?.pushViewController(viewController, animated: true)
    viewController.delegate = self
  }
}

// MARK: - PaymentCardViewControllerDelegate
extension PaymentMethodsViewController: PaymentCardViewControllerDelegate {
  public func paymentCardViewController(_ viewController: PaymentCardViewController, didComplete cardToken: CardToken) {
    viewController.navigationController?.popViewController(animated: true)
    viewModel.didSelectCardToken(cardToken)
  }
}

// MARK: - PBLPaymentMethodsViewControllerDelegate
extension PaymentMethodsViewController: PBLPaymentMethodsViewControllerDelegate {
  func viewController(_ viewController: PBLPaymentMethodsViewController, didSelect payByLink: PayByLink) {
    viewController.navigationController?.popViewController(animated: true)
    viewModel.didSelectPayByLink(payByLink)
  }
}
