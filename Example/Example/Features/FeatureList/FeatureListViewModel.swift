//
//  FeatureListViewModel.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation
import UIKit

protocol FeatureListViewModelProtocol {
  func didSelect(_ item: Feature)
  func didTapSettings()
}

protocol FeatureListViewModelDelegate: AnyObject {
  func featureListViewModelShouldNavigateToSettings(_ viewModel: FeatureListViewModelProtocol)
}

protocol FeatureListViewModelPresenter: AnyObject {
  var presenterViewController: UIViewController? { get }
}

final class FeatureListViewModel {

  // MARK: - Public Properties
  weak var delegate: FeatureListViewModelDelegate?
  weak var presenter: FeatureListViewModelPresenter?
  private(set) var features = Feature.all

  // MARK: - Private Properties
  private let repository = DataRepository()

  private lazy var showDemoApplePayUseCase = ShowDemoApplePayUseCase(presenter: presenter?.presenterViewController)
  private lazy var showDemoCVVAuthorizationUseCase = ShowDemoCVVAuthorizationUseCase(presenter: presenter?.presenterViewController)
  private lazy var showDemoMastercardInstallmentsVNOIUseCase = ShowDemoMastercardInstallmentsUseCase(presenter: presenter?.presenterViewController, format: .vnoi)
  private lazy var showDemoMastercardInstallmentsVNOOUseCase = ShowDemoMastercardInstallmentsUseCase(presenter: presenter?.presenterViewController, format: .vnoo)
  private lazy var showDemoPaymentCardScannerUseCase = ShowDemoPaymentCardScannerUseCase(presenter: presenter?.presenterViewController)
  private lazy var showDemoPaymentCardViewControllerUseCase = ShowDemoPaymentCardViewControllerUseCase(presenter: presenter?.presenterViewController)
  private lazy var showDemoPaymentCardWidgetUseCase = ShowDemoPaymentCardWidgetUseCase(presenter: presenter?.presenterViewController)
  private lazy var showDemoPaymentMethodsUseCase = ShowDemoPaymentMethodsUseCase(presenter: presenter?.presenterViewController)
  private lazy var showDemoPaymentMethodsWidgetUseCase = ShowDemoPaymentMethodsWidgetUseCase(presenter: presenter?.presenterViewController)
  private lazy var showDemoSoftAcceptUserCase = ShowDemoSoftAcceptUserCase(presenter: presenter?.presenterViewController)
  private lazy var showDemoThemeUseCase = ShowDemoThemeUseCase(presenter: presenter?.presenterViewController)
  private lazy var showDemoWebPaymentsUseCase = ShowDemoWebPaymentsUseCase(presenter: presenter?.presenterViewController)
  private lazy var showExampleOrderUseCase = ShowExampleOrderUseCase(presenter: presenter?.presenterViewController)
}

// MARK: - FeatureListViewModelProtocol
extension FeatureListViewModel: FeatureListViewModelProtocol {
  func didSelect(_ item: Feature) {
    
    switch item.type {
      case .demoApplePay:
        showDemoApplePayUseCase.execute()
      case .demoCVVAuthorization:
        showDemoCVVAuthorizationUseCase.execute()
      case .demoPaymentCardScanner:
        showDemoPaymentCardScannerUseCase.execute()
      case .demoPaymentCardViewController:
        showDemoPaymentCardViewControllerUseCase.execute()
      case .demoPaymentCardWidget:
        showDemoPaymentCardWidgetUseCase.execute()
      case .demoPaymentMethods:
        showDemoPaymentMethodsUseCase.execute()
      case .demoPaymentWidget:
        showDemoPaymentMethodsWidgetUseCase.execute()
      case .demoSoftAccept:
        showDemoSoftAcceptUserCase.execute()
      case .demoTheme:
        showDemoThemeUseCase.execute()
      case .demoVaryingNumberOfInstallments:
        showDemoMastercardInstallmentsVNOIUseCase.execute()
      case .demoVaryingNumberOfOptions:
        showDemoMastercardInstallmentsVNOOUseCase.execute()
      case .demoWebPaymentsSSL:
        showDemoWebPaymentsUseCase.execute()
      case .exampleOrder:
        showExampleOrderUseCase.execute()
    }
  }
  
  func didTapSettings() {
    delegate?.featureListViewModelShouldNavigateToSettings(self)
  }
}
