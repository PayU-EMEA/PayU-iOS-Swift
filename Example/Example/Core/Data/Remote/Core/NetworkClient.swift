//
//  NetworkClient.swift
//  Example
//
//  Created by PayU S.A. on 19/11/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//  

import Foundation
import PUSDK

class NetworkClient<E: HTTPEndpoint>: NSObject, URLSessionTaskDelegate {
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  private let parametersEncoderForJson: JSONParametersEncoder
  private let parametersEncoderForURL: URLParametersEncoder

  private let settingsRepository = SettingsRepository()

  override init() {
    parametersEncoderForJson = JSONParametersEncoder(encoder: encoder)
    parametersEncoderForURL = URLParametersEncoder(encoder: encoder)
  }

  func request<T: Codable>(endpoint: E, type: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {

    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)

    session.dataTask(
      with: buildURLRequest(from: endpoint),
      completionHandler: { data, response, error in

        if let error = error {
          Console.console.log(error)
          DispatchQueue.main.async {
            completionHandler(.failure(NetworkClientError.didReceiveRequestError))
          }
          return
        }

        if let response = response {
          print(response)
        }

        if let data = data {
          do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            Console.console.log(json)

            let model = try self.decoder.decode(T.self, from: data)
            Console.console.log(model)

            DispatchQueue.main.async {
              completionHandler(.success(model))
            }
          } catch {
            Console.console.log(error)
            DispatchQueue.main.async {
              completionHandler(.failure(error))
            }
          }
        }
      }).resume()

  }

  private func buildURLRequest(from endpoint: E) -> URLRequest {
    var request = URLRequest(
      url: endpoint.baseURL.appendingPathComponent(endpoint.path),
      cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
      timeoutInterval: 10.0)

    request.httpMethod = endpoint.method.rawValue

    let token = settingsRepository.getToken()
    request.addAuthorizationHTTPHeader(token)
    request.addHTTPHeaders(endpoint.headers)

    switch endpoint.task {
      case .request:
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      case .requestParameters(let body, let url):
        encode(body: body, url: url, request: &request)
    }

    print(request.allHTTPHeaderFields ?? "")
    print(request)

    return request
  }

  private func encode(body: HTTPParameters?, url: HTTPParameters?, request: inout URLRequest) {
    if let body = body { try? parametersEncoderForJson.encode(request: &request, with: body) }
    if let url = url { try? parametersEncoderForURL.encode(request: &request, with: url) }
  }

  // MARK: - URLSessionTaskDelegate
  func urlSession(
    _ session: URLSession,
    task: URLSessionTask,
    willPerformHTTPRedirection response: HTTPURLResponse,
    newRequest request: URLRequest,
    completionHandler: @escaping (URLRequest?) -> Void) {
      completionHandler(nil)
  }

    // Handle SSL challenges
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // Always accept the server's certificate without verification
        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
    }

}

