//
//  PUImageView.swift
//
//  Created by PayU S.A. on 21/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

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

  // MARK: - Private Properties
  private var downloadTask: URLSessionDataTask?
  private var currentURL: URL?

  // MARK: - Initialization
  public convenience init(brandImageProvider: BrandImageProvider?) {
    self.init(frame: .zero)
    self.brandImageProvider = brandImageProvider
    setupWithBrandImageProvider()
  }

  // MARK: - Public Methods
  public func prepareForReuse() {
    downloadTask?.cancel()
    downloadTask = nil
    currentURL = nil
  }

  // MARK: - Private Methods
  private func loadImage(from urlString: String) {
    downloadTask?.cancel()
    downloadTask = nil
    currentURL = URL(string: urlString)
    guard let url = currentURL else { return }

    downloadTask = PUImageLoader.shared.loadImage(from: url) { [weak self] image in
      guard self?.currentURL == url else { return }

      self?.image = image
    }
  }

  private func setupWithBrandImageProvider() {
    guard let brandImageProvider = brandImageProvider else { return }

    switch brandImageProvider {
      case .asset(let image, let contentMode):
        self.image = image
        self.tintColor = PUTheme.theme.colorTheme.primary2
        self.contentMode = contentMode
    case .dynamicAsset(let imageFn, let contentMode):
        self.image = imageFn();
        self.tintColor = PUTheme.theme.colorTheme.primary2
        self.contentMode = contentMode
      case .dynamic:
        guard let url = brandImageProvider.url else { return }
        loadImage(from: url)
        self.contentMode = .scaleAspectFit
      case .url(let url):
        guard let url = url else { return }
        loadImage(from: url)
        self.contentMode = .scaleAspectFit
    }
  }

  // MARK: - Overrides
  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setupWithBrandImageProvider()
  }
}
