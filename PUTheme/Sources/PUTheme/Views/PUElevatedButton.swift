//
//  PUElevatedButton.swift
//
//  Created by PayU S.A. on 15/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

public class PUElevatedButton: UIButton {

  // MARK: - Public Properties
  public override var intrinsicContentSize: CGSize {
    return CGSize(
      width: super.intrinsicContentSize.width,
      height: style.height)
  }

  public var style: PUTheme.ElevatedButtonTheme.Style {
    return PUTheme.theme.buttonTheme.primary
  }

  // MARK: - Initialization
  public override init(frame: CGRect) {
    super.init(frame: frame)
    prepareAppearance()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    prepareAppearance()
  }

  public override func awakeFromNib() {
    super.awakeFromNib()
    prepareAppearance()
  }

  // MARK: - Private Methods
  private func prepareAppearance() {
    apply(style: style)
  }
}

// MARK: - PUPrimaryButton
public final class PUPrimaryButton: PUElevatedButton {
  public override var style: PUTheme.ElevatedButtonTheme.Style {
    return PUTheme.theme.buttonTheme.primary
  }
}

// MARK: - PUSecondaryButton
public final class PUSecondaryButton: PUElevatedButton {
  public override var style: PUTheme.ElevatedButtonTheme.Style {
    return PUTheme.theme.buttonTheme.secondary
  }
}

// MARK: - PUTextButton
public final class PUTextButton: PUElevatedButton {
  public override var style: PUTheme.ElevatedButtonTheme.Style {
    return PUTheme.theme.buttonTheme.text
  }
}
