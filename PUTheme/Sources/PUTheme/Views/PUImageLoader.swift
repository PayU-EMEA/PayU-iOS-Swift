//
//  PUImageLoader.swift
//
//  Created by PayU S.A. on 26/11/2026.
//  Copyright © 2026 PayU S.A. All rights reserved.
//

import UIKit

final class PUImageLoader {

  // MARK: - Public Properties
  static let shared = PUImageLoader()

  // MARK: - Private Properties
  private let session: URLSession
  private let cache = NSCache<NSURL, UIImage>()

  // MARK: - Initialization
  init(
    session: URLSession = URLSession(configuration: .ephemeral),
    memoryLimit: Int = 20 * 1024 * 1024
  ) {
    self.session = session
    cache.totalCostLimit = memoryLimit
  }

  // MARK: - Public Methods
  @discardableResult
  func loadImage(from url: URL, completion: @escaping (UIImage) -> Void) -> URLSessionDataTask? {
    if let image = cache.object(forKey: url as NSURL) {
      completion(image)
      return nil
    }

    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
    let task = session.dataTask(with: request) { [weak self] data, response, _ in
      guard let data = data,
            (response as? HTTPURLResponse).map({ (200..<300).contains($0.statusCode) }) ?? true,
            let image = UIImage(data: data)
      else { return }

      let cost = image.cgImage.map { $0.bytesPerRow * $0.height } ?? 0
      self?.cache.setObject(image, forKey: url as NSURL, cost: cost)
      DispatchQueue.main.async { completion(image) }
    }
    task.resume()
    return task
  }
}
