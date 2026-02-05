//
//  PBLPaymentMethodsViewController.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

protocol PBLPaymentMethodsViewControllerDelegate: AnyObject {
  func viewController(_ viewController: PBLPaymentMethodsViewController, didSelect payByLink: PayByLink)
}

final class PBLPaymentMethodsViewController: UICollectionViewController {

  // MARK: - Factory
  public final class Factory {

    // MARK: - Private Properties
    private let assembler = PaymentMethodsAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Public Methods
    public func make(
      configuration: PaymentMethodsConfiguration
    ) -> PBLPaymentMethodsViewController {
      PBLPaymentMethodsViewController(
        viewModel: assembler.makePBLPaymentMethodsViewModel(
          configuration: configuration))
    }
  }

  // MARK: - Constants
  private struct Constants {
    static let collectionViewItemsPerRow = 3
    static let collectionViewInteritemSpacing = 8
    static let collectionViewSectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
  }

  // MARK: - Public Properties
  weak var delegate: PBLPaymentMethodsViewControllerDelegate?

  // MARK: - Private Properties
  private let viewModel: PBLPaymentMethodsViewModel
  private let identifier = "Cell"

  // MARK: - Initialization
  init(viewModel: PBLPaymentMethodsViewModel) {
    self.viewModel = viewModel
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
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
    setupNavigationTitleImage(image: PUImageView(brandImageProvider: .logo))
    view.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    collectionView.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4
    collectionView.register(PBLPaymentMethodsCell.self, forCellWithReuseIdentifier: identifier)
  }
  
  private func setupViewModel() {
    viewModel.delegate = self
  }

}

// MARK: - UICollectionViewDataSource
extension PBLPaymentMethodsViewController {
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel.numberOfSections()
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.numberOfItems(in: section)
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = viewModel.item(at: indexPath)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PBLPaymentMethodsCell
    let contentConfiguration = PBLPaymentMethodsCell.Content(brandImageProvider: item.brandImageProvider)
    cell.bind(with: contentConfiguration)
    return cell
  }
  
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PBLPaymentMethodsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemsPerRow = CGFloat(Constants.collectionViewItemsPerRow)
    let interitemSpacing = CGFloat(Constants.collectionViewInteritemSpacing)
    let paddings = CGFloat(Constants.collectionViewSectionInsets.left) + interitemSpacing * (itemsPerRow - 1) + CGFloat(Constants.collectionViewSectionInsets.right)
    let availableWidth = collectionView.bounds.width - paddings
    let side = availableWidth / itemsPerRow
    return CGSize(width: side, height: side)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    CGFloat(Constants.collectionViewInteritemSpacing)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    Constants.collectionViewSectionInsets
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    CGFloat(Constants.collectionViewInteritemSpacing)
  }
}

// MARK: - UICollectionViewDelegate
extension PBLPaymentMethodsViewController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    viewModel.didSelectItem(at: indexPath)
  }
}

// MARK: - PBLPaymentMethodsViewModelDelegate
extension PBLPaymentMethodsViewController: PBLPaymentMethodsViewModelDelegate {
  func paymentMethodsViewModel(_ viewModel: PBLPaymentMethodsViewModel, didSelect payByLink: PayByLink) {
    delegate?.viewController(self, didSelect: payByLink)
  }
}
