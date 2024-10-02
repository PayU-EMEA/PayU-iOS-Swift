//
//  TestPaymentCardsViewController.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

protocol TestPaymentCardsViewControllerDelegate: AnyObject {
  func viewController(_ viewController: TestPaymentCardsViewController, didSelect card: PaymentCard)
}

final class TestPaymentCardsViewController: UITableViewController {

  // MARK: - Factory
  struct Factory {

    // MARK: - Private Properties
    private let assembler = PaymentCardAssembler()

    // MARK: - Initialization
    init() {  }

    // MARK: - Public Methods
    func make() -> TestPaymentCardsViewController {
      assembler.makeTestPaymentCardsViewController()
    }
  }

  // MARK: - Properties
  weak var delegate: TestPaymentCardsViewControllerDelegate?

  // MARK: - Private Properties
  private let viewModel: TestPaymentCardsViewModel
  private let identifier = "Cell"

  // MARK: - Initialization
  init(viewModel: TestPaymentCardsViewModel) {
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
    tableView.register(TestPaymentCardCell.self, forCellReuseIdentifier: identifier)
    tableView.estimatedRowHeight = 80.0
    tableView.rowHeight = UITableView.automaticDimension
  }

  private func setupViewModel() {
    viewModel.delegate = self
  }

}

// MARK: - UITableViewDataSource
extension TestPaymentCardsViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfItems(in: section)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = viewModel.card(at: indexPath)
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TestPaymentCardCell
    cell.bind(with: TestPaymentCardCell.Content(
      title: "\(item.number) (\(item.expirationMonth)/\(item.expirationYear))",
      subtitle: [
        "Behavior: \(item.behavior)",
        "3DS: \(item.is3DSecure)"
      ].joined(separator: "\n")))
    return cell
  }
}

// MARK: - UITableViewDelegate
extension TestPaymentCardsViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.didSelectItem(at: indexPath)
  }
}

// MARK: - TestPaymentCardsViewModelDelegate
extension TestPaymentCardsViewController: TestPaymentCardsViewModelDelegate {
  func viewModel(_ viewModel: TestPaymentCardsViewModel, didSelect card: PaymentCard) {
    delegate?.viewController(self, didSelect: card)
  }
}
