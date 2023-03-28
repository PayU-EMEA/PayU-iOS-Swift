//
//  PUImageView.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Kingfisher
import UIKit

#if canImport(PUCore)
import PUCore
#endif

public class PUImageView: UIImageView {

  // MARK: - Public Properties
  public var brandImageProvider: BrandImageProvider? {
    didSet {
      setupWithBrandImageProvider()
    }
  }

  // MARK: - Initialization
  public convenience init(brandImageProvider: BrandImageProvider?) {
    self.init(frame: .zero)
    self.brandImageProvider = brandImageProvider
    setupWithBrandImageProvider()
  }

  // MARK: - Public Methods
  public func prepareForReuse() {
    kf.cancelDownloadTask()
  }

  // MARK: - Private Methods
  private func setupWithBrandImageProvider() {
    guard let brandImageProvider = brandImageProvider else { return }

    switch brandImageProvider {
      case .asset(let image, let contentMode):
        self.image = image
        self.tintColor = PUTheme.theme.colorTheme.primary2
        self.contentMode = contentMode
      case .dynamic:
        guard let url = brandImageProvider.url else { return }
        kf.setImage(with: URL(string: url))
        self.contentMode = .scaleAspectFit
      case .url(let url):
        guard let url = url else { return }
        kf.setImage(with: URL(string: url))
        self.contentMode = .scaleAspectFit
    }
  }

  // MARK: - Overrides
  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setupWithBrandImageProvider()
  }
}
