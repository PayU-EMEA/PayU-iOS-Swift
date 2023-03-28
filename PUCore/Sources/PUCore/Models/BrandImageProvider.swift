//
//  BrandImageProvider.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation
import UIKit

/// An absraction over the source of the image.
public enum BrandImageProvider: Equatable {

  // MARK: - Constants
  private struct Constants {
    static let blik = "https://static.payu.com/images/mobile/logos/pbl_blik.png"
    static let maestroLight = "https://static.payu.com/images/mobile/maestro-light.png"
    static let maestroDark = "https://static.payu.com/images/mobile/maestro-dark.png"
    static let mastercardLight = "https://static.payu.com/images/mobile/mastercard-light.png"
    static let mastercardDark = "https://static.payu.com/images/mobile/mastercard-dark.png"
    static let visaLight = "https://static.payu.com/images/mobile/visa-light.png"
    static let visaDark = "https://static.payu.com/images/mobile/visa-dark.png"
  }

  // MARK: - Public Values
  public static let blik: BrandImageProvider = .url(Constants.blik)
  public static let maestro: BrandImageProvider = .dynamic(Constants.maestroLight, Constants.maestroDark)
  public static let mastercard: BrandImageProvider = .dynamic(Constants.mastercardLight, Constants.mastercardDark)
  public static let visa: BrandImageProvider = .dynamic(Constants.visaLight, Constants.visaDark)
  public static let calendar: BrandImageProvider = .asset(UIImage.calendar, .center)
  public static let camera: BrandImageProvider = .asset(UIImage.camera, .center)
  public static let chevronLeft: BrandImageProvider = .asset(UIImage.chevronLeft, .center)
  public static let chevronRight: BrandImageProvider = .asset(UIImage.chevronRight, .center)
  public static let creditcard: BrandImageProvider = .asset(UIImage.creditcard, .center)
  public static let lock: BrandImageProvider = .asset(UIImage.lock, .center)
  public static let logo: BrandImageProvider = .asset(UIImage.logo, .scaleAspectFit)
  public static let paperplane: BrandImageProvider = .asset(UIImage.paperplane, .center)


  /// Where the source of image is local asset
  case asset(UIImage?, UIImageView.ContentMode)

  /// Where the source of image is url and it has light and dark images url
  case dynamic(String?, String?)

  /// Where the source of image is remote url
  case url(String?)
}

extension BrandImageProvider {
  public var url: String? {
    switch self {
      case .asset:
        return nil
      case .dynamic(let light, let dark):
        guard #available(iOS 13.0, *) else { return light }
        return UITraitCollection.current.userInterfaceStyle == .light ? light : dark
      case .url(let string):
        return string
    }
  }
}

