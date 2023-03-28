//
//  OfferViewController.swift
//  
//  Created by PayU S.A. on 05/12/2022.
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

/// Protocol which defines the completion result of ``OfferViewController``
public protocol OfferViewControllerDelegate: AnyObject {


  /// This method is called when user select any of proposed option
  /// - Parameters:
  ///   - viewController: Instance of ``OfferViewController`` from where the action was triggered
  ///   - result: ``InstallmentResult`` instance which contains information about the selectied option ([developers.payu.com](https://developers.payu.com/en/mci.html#mastercard_installments_integration_decision))
  func offerViewController(_ viewController: OfferViewController, didComplete result: InstallmentResult)

  /// This method is called when user cancels selection of any of proposed option
  /// - Parameters:
  ///   - viewController: Instance of ``OfferViewController`` from where the action was triggered
  func offerViewModelDidCancel(_ viewController: OfferViewController)
}

/// ViewController which is responsible for displaying of ``InstallmentProposal`` to user
public final class OfferViewController: UIViewController {

  // MARK: - Factory

  /// Factory which allows to create the ``OfferViewController`` instance
  public final class Factory {

    // MARK: - Private Properties
    private let assembler = MastercardInstallmentsAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Public Methods
    /// Returns default implementation for ``OfferViewController``
    /// - Parameter proposal: ``InstallmentProposal`` instance received from the backend ([developers.payu.com](https://developers.payu.com/en/mci.html#mastercard_installments_integration_proposal))
    /// - Returns: default implementation for ``OfferViewController``
    public func make(proposal: InstallmentProposal) -> OfferViewController {
      assembler.makeOfferViewController(proposal: proposal)
    }
  }

  // MARK: - Public Properties
  public weak var delegate: OfferViewControllerDelegate?

  // MARK: - Private Properties
  private let viewModel: OfferViewModel

  // MARK: - Initialization
  init(viewModel: OfferViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
    setupViewModel()
  }

  // MARK: - Private Methods
  private func setupAppearance() {
    edgesForExtendedLayout = []

    navigationController?.navigationBar.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    navigationController?.view.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    view.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    navigationItem.titleView = PUImageView(brandImageProvider: .logo)

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8.0
    view.addSubview(stackView)

    stackView.pinToSuperviewLeft(withConstant: 16.0)
    stackView.pinToSuperviewTop(withConstant: 16.0)
    stackView.pinToSuperviewRight(withConstant: -16.0)

    let transactionApprovedLabel = PULabel(style: PUTheme.theme.textTheme.bodyText1)
    transactionApprovedLabel.text = "transaction_approved".localized()
    transactionApprovedLabel.numberOfLines = 0
    stackView.addArrangedSubview(transactionApprovedLabel)

    let recipientLabel = PULabel(style: PUTheme.theme.textTheme.bodyText2)
    recipientLabel.text = "the_recipient_will_get_the_total_order_amount".localized()
    recipientLabel.numberOfLines = 0
    stackView.addArrangedSubview(recipientLabel)

    let mastercardInstallmentsLabel = PULabel(style: PUTheme.theme.textTheme.bodyText2)
    mastercardInstallmentsLabel.text = "you_can_split_this_payment_into_installments_with_mastercard".localized()
    mastercardInstallmentsLabel.numberOfLines = 0
    stackView.addArrangedSubview(mastercardInstallmentsLabel)

    let emptyView = UIView(frame: .zero)
    emptyView.addHeightConstraint(with: 8.0)
    stackView.addArrangedSubview(emptyView)

    let splitIntoInstallmentsButton = PUPrimaryButton()
    let splitIntoInstallmentsButtonTitle = "split_into_installments".localized()
    splitIntoInstallmentsButton.setTitle(splitIntoInstallmentsButtonTitle, for: .normal)
    splitIntoInstallmentsButton.addTarget(self, action: #selector(actionSplitIntoInstallments(_:)), for: .touchUpInside)
    stackView.addArrangedSubview(splitIntoInstallmentsButton)

    let noThanksButton = PUSecondaryButton()
    let noThanksButtonTitlte = "no_thanks".localized()
    noThanksButton.setTitle(noThanksButtonTitlte, for: .normal)
    noThanksButton.addTarget(self, action: #selector(actionNoThanks(_:)), for: .touchUpInside)
    stackView.addArrangedSubview(noThanksButton)
  }

  private func setupViewModel() {
    viewModel.delegate = self
  }

  // MARK: - Actions
  @objc private func actionSplitIntoInstallments(_ sender: Any) {
    viewModel.didTapSplitIntoInstallments()
  }

  @objc private func actionNoThanks(_ sender: Any) {
    viewModel.didTapNoThanks()
  }
}

// MARK: - OfferViewModelDelegate
extension OfferViewController: OfferViewModelDelegate {
  func offerViewModel(_ viewModel: OfferViewModel, shouldNavigateToOptions proposal: InstallmentProposal) {
    let viewController = OptionsViewController.Factory().make(proposal: proposal)
    navigationController?.pushViewController(viewController, animated: true)
    viewController.delegate = self
  }

  func offerViewModel(_ viewModel: OfferViewModel, didComplete result: InstallmentResult) {
    navigationController?.dismiss(animated: true) { [weak self] in
      guard let self = self else { return }
      self.delegate?.offerViewController(self, didComplete: result)
    }
  }

  func offerViewModelDidCancel(_ viewModel: OfferViewModel) {
    navigationController?.dismiss(animated: true) { [weak self] in
      guard let self = self else { return }
      self.delegate?.offerViewModelDidCancel(self)
    }
  }
}

// MARK: - OptionsViewControllerDelegate
extension OfferViewController: OptionsViewControllerDelegate {
  func optionsViewController(_ viewController: OptionsViewController, didComplete result: InstallmentResult) {
    viewModel.didSelect(result: result)
  }
}
