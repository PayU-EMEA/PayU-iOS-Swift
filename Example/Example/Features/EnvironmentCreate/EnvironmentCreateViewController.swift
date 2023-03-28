//
//  EnvironmentCreateViewController.swift
//  Example
//
//  Created by PayU S.A. on 22/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

protocol EnvironmentCreateViewControllerDelegate: AnyObject {
  func environmentCreateViewControllerDidComplete(_ viewController: EnvironmentCreateViewController)
}

final class EnvironmentCreateViewController: ViewController {

  // MARK: - Public Properties
  weak var delegate: EnvironmentCreateViewControllerDelegate?

  // MARK: - Private Properties
  private let viewModel: EnvironmentCreateViewModel
  private let environmentTypes = EnvironmentType.allCases.enumerated().map { (index: $0, value: $1) }
  private let grantTypes = GrantType.allCases.enumerated().map { (index: $0, value: $1) }

  private lazy var environmentTypesSegmentedControl: UISegmentedControl = {
    let items = environmentTypes.map { $0.value.rawValue }
    let segmentedControl = UISegmentedControl(items: items)
    segmentedControl.selectedSegmentIndex = environmentTypes.first(where: { $0.value == .sandbox })?.index ?? 0
    return segmentedControl
  }()

  private lazy var grantTypesSegmentedControl: UISegmentedControl = {
    let items = grantTypes.map { $0.value.rawValue }
    let segmentedControl = UISegmentedControl(items: items)
    segmentedControl.selectedSegmentIndex = grantTypes.first(where: { $0.value == .trustedMerchant })?.index ?? 0
    return segmentedControl
  }()

  private let clientIdTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "client_id"
    textField.returnKeyType = .done
    return textField
  }()

  private let clientSecretTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "client_secret"
    textField.returnKeyType = .done
    return textField
  }()

  // MARK: - Initialization
  required init() {
    self.viewModel = EnvironmentCreateViewModel()
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
    title = "Create Environment"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(actionSave(_:)))

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16.0
    view.addSubview(stackView)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0).isActive = true
    stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0).isActive = true
    stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0).isActive = true

    stackView.addArrangedSubview(environmentTypesSegmentedControl)
    stackView.addArrangedSubview(grantTypesSegmentedControl)
    stackView.addArrangedSubview(clientIdTextField)
    stackView.addArrangedSubview(clientSecretTextField)
    stackView.addArrangedSubview(UIView())
  }

  private func setupViewModel() {
    viewModel.dataSource = self
    viewModel.delegate = self
  }

  // MARK: - Actions
  @objc private func actionSave(_ sender: Any) {
    viewModel.didTapSave()
  }
}

// MARK: - EnvironmentCreateViewModelDataSource
extension EnvironmentCreateViewController: EnvironmentCreateViewModelDataSource {
  func environmentType() -> EnvironmentType? {
    return environmentTypes[environmentTypesSegmentedControl.selectedSegmentIndex].value
  }

  func grantType() -> GrantType? {
    return grantTypes[grantTypesSegmentedControl.selectedSegmentIndex].value
  }

  func clientId() -> String? {
    return clientIdTextField.text
  }

  func clientSecret() -> String? {
    return clientSecretTextField.text
  }
}

// MARK: - EnvironmentCreateViewModelDelegate
extension EnvironmentCreateViewController: EnvironmentCreateViewModelDelegate {
  func environmentCreateViewModelDidComplete(_ viewModel: EnvironmentCreateViewModel) {
    delegate?.environmentCreateViewControllerDidComplete(self)
  }
}

