//
//  ListViewController.swift
//  Example
//
//  Created by PayU S.A. on 22/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import UIKit

class ListViewController<T: Cell & UITableViewCell>: ViewController, UITableViewDataSource, UITableViewDelegate {

  // MARK: - Private Properties
  private let tableView = UITableView(frame: .zero, style: .plain)
  private let identifier = "Cell"

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
  }

  // MARK: - Private Methods
  private func setupTableView() {
    view.addSubview(tableView)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(T.self, forCellReuseIdentifier: identifier)
  }

  // MARK: - ListViewProvider
  func performUpdates() {
    tableView.reloadData()
  }

  func numberOfSections() -> Int {
    return 1
  }

  func numberOfRows(in section: Int) -> Int {
    return 0
  }

  func content(at indexPath: IndexPath) -> T.Content {
    fatalError("Unimplemented")
  }

  func didSelectRow(at indexPath: IndexPath) {

  }

  func canDeleteRow(at indexPath: IndexPath) -> Bool {
    return false
  }

  func didDeleteRow(at indexPath: IndexPath) {

  }

  // MARK: - UITableViewDataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRows(in: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    cell.bind(with: content(at: indexPath))
    return cell
  }

  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    didSelectRow(at: indexPath)
  }

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return canDeleteRow(at: indexPath) ? .delete : .none
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    didDeleteRow(at: indexPath)
  }

}
