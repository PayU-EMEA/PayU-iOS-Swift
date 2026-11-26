//
//  PUImageLoader.swift
//
//  Created by PayU S.A. on 26/11/2026.
//  Copyright © 2026 PayU S.A. All rights reserved.
//

import UIKit

final class PUImageLoader {

  // MARK: - Constants
  private struct Constants {
    static let diskTimeToLive: TimeInterval = 14 * 24 * 60 * 60
    static let diskSizeLimit = 20 * 1024 * 1024
  }

  // MARK: - Public Properties
  static let shared = PUImageLoader()

  // MARK: - Private Properties
  private let session: URLSession
  private let cache = NSCache<NSURL, UIImage>()
  private let directory: URL

  // MARK: - Initialization
  init(
    session: URLSession = URLSession(configuration: .ephemeral),
    memoryLimit: Int = 20 * 1024 * 1024,
    directory: URL? = nil
  ) {
    self.session = session
    self.directory = directory
      ?? FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("PUSDK/Images", isDirectory: true)
    cache.totalCostLimit = memoryLimit
    DispatchQueue.global(qos: .utility).async { [weak self] in
      self?.clearDiskIfNeeded()
    }
  }

  // MARK: - Public Methods
  @discardableResult
  func loadImage(from url: URL, completion: @escaping (UIImage) -> Void) -> URLSessionDataTask? {
    if let image = cache.object(forKey: url as NSURL) ?? readFromDisk(url) {
      store(image, for: url)
      completion(image)
      return nil
    }

    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
    let task = session.dataTask(with: request) { [weak self] data, response, _ in
      guard let self = self,
            let data = data,
            (response as? HTTPURLResponse).map({ (200..<300).contains($0.statusCode) }) ?? true,
            let image = UIImage(data: data)
      else { return }

      self.store(image, for: url)
      self.writeToDisk(data, for: url)
      DispatchQueue.main.async { completion(image) }
    }
    task.resume()
    return task
  }

  // MARK: - Private Methods
  private func store(_ image: UIImage, for url: URL) {
    let cost = image.cgImage.map { $0.bytesPerRow * $0.height } ?? 0
    cache.setObject(image, forKey: url as NSURL, cost: cost)
  }

  private func fileURL(for url: URL) -> URL {
    let name = Data(url.absoluteString.utf8).base64EncodedString()
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "=", with: "")
    return directory.appendingPathComponent(name)
  }

  private func readFromDisk(_ url: URL) -> UIImage? {
    let file = fileURL(for: url)
    guard let modified = try? file.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate,
          Date().timeIntervalSince(modified) < Constants.diskTimeToLive,
          let data = try? Data(contentsOf: file)
    else { return nil }

    try? FileManager.default.setAttributes([.modificationDate: Date()], ofItemAtPath: file.path)
    return UIImage(data: data)
  }

  private func clearDiskIfNeeded() {
    let files = (try? FileManager.default.contentsOfDirectory(
      at: directory,
      includingPropertiesForKeys: [.fileSizeKey]
    )) ?? []
    let size = files.reduce(0) { $0 + ((try? $1.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0) }
    guard size > Constants.diskSizeLimit else { return }

    try? FileManager.default.removeItem(at: directory)
  }

  private func writeToDisk(_ data: Data, for url: URL) {
    try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    try? data.write(to: fileURL(for: url), options: .atomic)
  }
}
