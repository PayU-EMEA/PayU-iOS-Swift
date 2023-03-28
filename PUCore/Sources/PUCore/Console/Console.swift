//
//  Console.swift
//  
//  Created by PayU S.A. on 21/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

/// Helper class which allows to debug Package
public final class Console {

  // MARK: - Level

  /// Allows to set the level of the debug message.
  public enum Level: CustomStringConvertible {

    /// For now it is the only available ``Console/Level`` value
    case verbose

    // MARK: - CustomStringConvertible
    public var description: String {
      switch self {
        case .verbose:
          return "[I]"
      }
    }
  }

  // MARK: - Singleton

  /// Default console with `[PayU]` prefix
  public static let console = Console(prefix: "PayU")

  // MARK: - Private Properties
  private let prefix: String

  // MARK: - Initialization
  private init(prefix: String) {
    self.prefix = prefix
  }

  // MARK: - Public Methods


  /// Logs message to the console
  ///
  /// To enable console - set **PU_CONSOLE_ENABLED** in *Edit Scheme -> Arguments -> Environment* variables to **enable**
  /// - Parameters:
  ///   - file: Source file of message
  ///   - line: Source line of message
  ///   - function: Source function where this function was called
  ///   - value: message you want to display, for ex: server response, etc.
  ///   - level: ``Console/Level`` value. Default is ``Console/Level/verbose``
  public func log(_ value: Any? = nil, file: String = #file, line: Int = #line, function: String = #function, level: Console.Level = .verbose) {
    guard let variable = ProcessInfo.processInfo.environment["PU_CONSOLE_ENABLED"], variable == "enable" else { return }
    guard let url = URL(string: file) else { return }
    guard debug else { return }

    let level = String(describing: level)
    let file = url.deletingPathExtension().lastPathComponent
    print("\(level) \(prefix) \(file):\(line):\(function): \(value ?? "")")
  }
}
