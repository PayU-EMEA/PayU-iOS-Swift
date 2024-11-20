//
//  NetworkClientCertificate.swift
//  
//  Created by PayU S.A. on 20/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation
import Security

#if canImport(PUCore)
import PUCore
#endif

struct NetworkClientCertificate {

  // MARK: - Certificates
  static func certificate(name: String) -> NetworkClientCertificate? {
    guard
      let file = Bundle
        .current(.PUAPI)
        .url(forResource: name, withExtension: "cer"),
      let data = try? Data(contentsOf: file)
    else { return nil }

    return NetworkClientCertificate(data: data, name: name)
  }

  static func certificates() -> [NetworkClientCertificate] {
    let names = ["entrust-root-certificate-authority-G2", "payu-root-ca-01"]
    return names.compactMap { NetworkClientCertificate.certificate(name: $0) }
  }

  // MARK: - Public Properties
  let data: Data
  let name: String

  // MARK: - Certificate
  var certificate: SecCertificate? {
    SecCertificateCreateWithData(nil, data as CFData)
  }

  var publicKey: SecKey? {
    var trust: SecTrust!
    var error: CFError?

    guard let certificate = certificate else { return nil }

    let status = SecTrustCreateWithCertificates(
      certificate,
      SecPolicyCreateBasicX509(),
      &trust)

    guard status == noErr else { return nil }
    guard SecTrustEvaluateWithError(trust, &error) else {
      return nil
    }

    return SecTrustCopyPublicKey(trust)
  }
}
