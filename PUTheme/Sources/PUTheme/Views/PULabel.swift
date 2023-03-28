//
//  PULabel.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

final public class PULabel: UILabel {

  // MARK: - Initialization
  public convenience init(style: PUTheme.TextTheme.Style) {
    self.init(frame: .zero)
    self.apply(style: style)
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
