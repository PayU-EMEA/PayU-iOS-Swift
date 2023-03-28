//
//  SelectableListViewController.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

final class SelectableListViewController<T: Selectable>: ListViewController<ListViewCell> {

  // MARK: - Arguments
  struct Arguments<T> {
    let items: [T]
    let selected: T?
  }

  // MARK: - Public Properties
  var onSelect: ((T) -> ())?

  // MARK: - Private Properties
  private let viewModel: SelectableListViewModel<T>

  // MARK: - Initialization
  required init(arguments: Arguments<T>) {
    self.viewModel = SelectableListViewModel<T>(items: arguments.items, selected: arguments.selected)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBasics()
  }

  // MARK: - Private Methods
  private func setupBasics() {
    title = "Settings"
  }

  // MARK: - Overrides
  override func numberOfRows(in section: Int) -> Int {
    return viewModel.items.count
  }

  override func content(at indexPath: IndexPath) -> ListViewCell.Content {
    return ListViewCell.Content(
      title: viewModel.items[indexPath.row].title,
      accessoryType: viewModel.items[indexPath.row].id == viewModel.selected?.id ? .checkmark : .none)
  }

  override func didSelectRow(at indexPath: IndexPath) {
    onSelect?(viewModel.items[indexPath.row])
    navigationController?.popViewController(animated: true)
  }

}
