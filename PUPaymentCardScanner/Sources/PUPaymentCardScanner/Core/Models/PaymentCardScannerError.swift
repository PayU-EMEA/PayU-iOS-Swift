//
//  PaymentCardScannerError.swift
//  
//  Created by PayU S.A. on 08/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import Foundation

/// Represents the error, thrown by ``PaymentCardScannerViewController``
public struct PaymentCardScannerError: LocalizedError {

  // MARK: - ErrorType

  /// Represents the error type, thrown by ``PaymentCardScannerViewController``
  public enum ErrorType {
    case couldNotCreateCaptureDevice
    case couldNotCreateCaptureDeviceInput
    case couldNotCreateCaptureConnection
    case videoOrientationIsNotSupported
  }

  // MARK: - Public Properties
  public let errorType: ErrorType

  /// Not nil, when the ``PaymentCardScannerError`` was instantiated by the underlying error
  public let errorReason: Error?

  public var errorDescription: String? {
    guard let errorReason = errorReason as? LocalizedError else { return nil }
    return errorReason.errorDescription
  }
}
