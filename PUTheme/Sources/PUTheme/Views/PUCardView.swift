//
//  PUCardView.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

final public class PUCardView: UIView {

  // MARK: - Private Properties
  private var style: PUTheme.CardTheme.Style?

  // MARK: - Initialization
  public convenience init(style: PUTheme.CardTheme.Style) {
    self.init(frame: .zero)
    self.style = style
    prepareAppearance()
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    prepareAppearance()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods
  private func prepareAppearance() {
    if let style = style {
      apply(style: style)
    }
  }

  // MARK: - Overrides
  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    prepareAppearance()
  }
}
