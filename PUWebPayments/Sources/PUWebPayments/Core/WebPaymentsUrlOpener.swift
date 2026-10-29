//
//  WebPaymentsUrlOpener.swift
//
//  Created by PayU S.A. on 23/10/2026.
//  Copyright © 2026 PayU S.A. All rights reserved.
//

import UIKit

/// @mockable
protocol WebPaymentsUrlOpener {
  func open(_ url: URL)
  func openUniversalLink(_ url: URL, completion: @escaping (Bool) -> Void)
}

struct WebPaymentsApplicationUrlOpener: WebPaymentsUrlOpener {

  // MARK: - WebPaymentsUrlOpener
  func open(_ url: URL) {
    UIApplication.shared.open(url)
  }

  /// Opens `url` only if it's a universal link registered by an installed application.
  /// `completion` receives `false` when no application handles the link.
  func openUniversalLink(_ url: URL, completion: @escaping (Bool) -> Void) {
    UIApplication.shared.open(url, options: [.universalLinksOnly: true], completionHandler: completion)
  }
}
