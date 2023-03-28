//
//  NetworkClientAuthenticationChallengeHandler.swift
//  
//  Created by PayU S.A. on 14/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation
import Security

class NetworkClientAuthenticationChallengeHandler: NSObject {

  // MARK: - Private Properties
  private let certificates: [NetworkClientCertificate]
  private let configuration: NetworkClientConfiguration

  // MARK: - Initialization
  init(configuration: NetworkClientConfiguration) {
    self.certificates = NetworkClientCertificate.certificates()
    self.configuration = configuration
  }
}

// MARK: - URLSessionDelegate
extension NetworkClientAuthenticationChallengeHandler: URLSessionDelegate {
  func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

      guard let serverTrust = challenge.protectionSpace.serverTrust else {
        completionHandler(.cancelAuthenticationChallenge, nil)
        return
      }

      let hostname = configuration.baseUrl.absoluteString
      let policy = SecPolicyCreateSSL(true, hostname as CFString)
      let policies = NSArray(object: policy)
      let status = SecTrustSetPolicies(serverTrust, policies)

      guard status == noErr else {
        completionHandler(.cancelAuthenticationChallenge, nil)
        return
      }

      guard serverTrust.valid else {
        completionHandler(.cancelAuthenticationChallenge, nil)
        return
      }

      let serverTrustPublicKeys = serverTrust.publicKeys
      let certificatePublicKeys = certificates.compactMap { $0.publicKey }

      for serverTrustPublicKey in serverTrustPublicKeys {
        for certificatePublicKey in certificatePublicKeys {
          if serverTrustPublicKey == certificatePublicKey {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
            return
          }
        }
      }

      completionHandler(.cancelAuthenticationChallenge, nil)
    }
}

private extension SecTrust {
  var valid: Bool {
    var result: SecTrustResultType = .invalid
    var status: OSStatus!

    status = SecTrustEvaluate(self, &result)

    guard status == noErr else { return false }
    guard result == .recoverableTrustFailure else { return result == .unspecified || result == .proceed }

    let exceptions = SecTrustCopyExceptions(self)
    _ = SecTrustSetExceptions(self, exceptions)
    status = SecTrustEvaluate(self, &result)

    guard status == noErr else { return false }
    return result == .unspecified || result == .proceed
  }

  var publicKeys: [SecKey] {
    var publicKeys: [SecKey] = []
    let count = SecTrustGetCertificateCount(self)

    for ix in 0..<count {
      guard let certificate = SecTrustGetCertificateAtIndex(self, ix) else { continue }
      let certificates = [certificate] as CFArray

      var result: SecTrustResultType = .invalid
      var trust: SecTrust!
      var status: OSStatus!

      status = SecTrustCreateWithCertificates(
        certificates,
        SecPolicyCreateBasicX509(),
        &trust)

      guard status == noErr else { continue }
      status = SecTrustEvaluate(trust, &result)
      guard status == noErr else { continue }

      guard let publicKey = SecTrustCopyPublicKey(trust) else { continue }
      publicKeys.append(publicKey)
    }
    return publicKeys
  }
}
