//
//  SelectableListViewModel.swift
//  Example
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation

protocol SelectableListViewModelProtocol {
  associatedtype T
}

final class SelectableListViewModel<T: Selectable> {

  // MARK: - Private Properties
  private(set) var items: [T]
  private(set) var selected: T?

  // MARK: - Initialization
  init(items: [T], selected: T? = nil) {
    self.items = items
    self.selected = selected
  }

}

// MARK: - FeatureListViewModelProtocol
extension SelectableListViewModel: SelectableListViewModelProtocol {  }


