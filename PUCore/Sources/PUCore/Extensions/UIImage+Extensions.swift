//
//  UIImage+Extensions.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import UIKit

public extension UIImage {

  // MARK: - ImageName
  private struct ImageName {
    static let calendar = "calendar"
    static let camera = "camera"
    static let chevronLeft = "chevron.left"
    static let chevronRight = "chevron.right"
    static let creditcard = "creditcard"
    static let lock = "lock"
    static let logo = "logo"
    static let paperplaneFill = "paperplane.fill"
  }

  // MARK: - Public Methods
  static func asset(_ name: String, renderingMode: UIImage.RenderingMode = .alwaysTemplate) -> UIImage? {
    UIImage(
      named: name,
      in: .current(.PUCore),
      compatibleWith: nil)?
      .withRenderingMode(renderingMode)
  }

  static var calendar: UIImage? {
    UIImage.asset(ImageName.calendar)
  }

  static var camera: UIImage? {
    UIImage.asset(ImageName.camera)
  }

  static var chevronLeft: UIImage? {
    UIImage.asset(ImageName.chevronLeft)
  }

  static var chevronRight: UIImage? {
    UIImage.asset(ImageName.chevronRight)
  }

  static var creditcard: UIImage? {
    UIImage.asset(ImageName.creditcard)
  }

  static var lock: UIImage? {
    UIImage.asset(ImageName.lock)
  }

  static var logo: UIImage? {
    UIImage.asset(ImageName.logo, renderingMode: .alwaysOriginal)
  }

  static var paperplane: UIImage? {
    UIImage.asset(ImageName.paperplaneFill)
  }
}
