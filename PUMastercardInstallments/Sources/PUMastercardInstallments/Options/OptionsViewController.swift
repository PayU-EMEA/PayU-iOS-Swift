//
//  OptionsViewController.swift
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

protocol OptionsViewControllerDelegate: AnyObject {
  func optionsViewController(_ viewController: OptionsViewController, didComplete result: InstallmentResult)
}

final class OptionsViewController: UITableViewController {

  // MARK: - Factory
  final class Factory {

    // MARK: - Private Properties
    private let assembler = MastercardInstallmentsAssembler()

    // MARK: - Initialization
    init() {  }

    // MARK: - Methods
    func make(proposal: InstallmentProposal) -> OptionsViewController {
      assembler.makeOptionsViewController(proposal: proposal)
    }
  }

  // MARK: - Public Properties
  weak var delegate: OptionsViewControllerDelegate?

  // MARK: - Private Properties
  private let viewModel: OptionsViewModel
  private let identifier = "Cell"

  // MARK: - Initialization
  init(viewModel: OptionsViewModel) {
    self.viewModel = viewModel
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
    navigationItem.titleView = PUImageView(brandImageProvider: .logo)
    view.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    tableView.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    tableView.register(OptionsCell.self, forCellReuseIdentifier: identifier)
    tableView.estimatedRowHeight = 80.0
    tableView.separatorStyle = .none
    tableView.rowHeight = UITableView.automaticDimension
  }

  private func setupViewModel() {
    viewModel.delegate = self
  }
}

// MARK: - UITableViewDataSource
extension OptionsViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfItems(in: section)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OptionsCell
    cell.bind(with: viewModel.item(at: indexPath))
    return cell
  }
}

// MARK: - UITableViewDelegate
extension OptionsViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.didSelectItem(at: indexPath)
  }
}

// MARK: - OptionsViewModelDelegate
extension OptionsViewController: OptionsViewModelDelegate {
  func optionsViewModel(_ viewModel: OptionsViewModel, didComplete result: InstallmentResult) {
    delegate?.optionsViewController(self, didComplete: result)
  }
}
