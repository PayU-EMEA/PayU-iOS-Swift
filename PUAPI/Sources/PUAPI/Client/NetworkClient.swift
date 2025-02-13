//
//  NetworkClient.swift
//

import Foundation

#if canImport(PUCore)
  import PUCore
#endif

public protocol NetworkClientProtocol {
  func request<E: NetworkTarget, T: Codable>(
    target: E, type: T.Type,
    completionHandler: @escaping (Result<T, Error>) -> Void)
}

public struct NetworkClient: NetworkClientProtocol {

  // MARK: - Factory
  public final class Factory {
    // MARK: - Private Properties
    private let assembler = APIAssembler()

    // MARK: - Initialization
    public init() {}

    // MARK: - Public Methods
    public func make() -> NetworkClient {
      assembler.makeNetworkClient()
    }
  }

  // MARK: - Private Properties
  private let networkClientConfiguration: NetworkClientConfiguration
  private let session: URLSession

  // MARK: - Initialization
  init(
    networkClientConfiguration: NetworkClientConfiguration, session: URLSession
  ) {
    self.networkClientConfiguration = networkClientConfiguration
    self.session = session
  }

  // MARK: - Public Methods
  public func request<E, T>(
    target: E,
    type: T.Type,
    completionHandler: @escaping (Result<T, Error>) -> Void
  ) where E: NetworkTarget, T: Decodable, T: Encodable {

    var request = URLRequest(
      url: networkClientConfiguration.baseUrl.appendingPathComponent(
        target.path))
    request.httpMethod = target.httpMethod
    request.httpBody = target.httpBody
    target.httpHeaders.forEach {
      request.addValue($0.value, forHTTPHeaderField: $0.key)
    }

    session.dataTask(
      with: request,
      completionHandler: { (responseData, response, error) in
        if responseData != nil { Console.console.log(responseData) }
        if error != nil { Console.console.log(error) }
        if let response = response as? HTTPURLResponse {
          Console.console.log(response)

          guard (200...299).contains(response.statusCode) else {
            let httpError = NSError(
              domain: "", code: response.statusCode,
              userInfo: [
                NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(
                  forStatusCode: response.statusCode)
              ])
            Console.console.log(httpError)
            DispatchQueue.main.async { completionHandler(.failure(httpError)) }
            return
          }
        }
        guard let responseData = responseData else { return }

        do {
          let decoder = JSONDecoder()
          let data =
            responseData.isEmpty ? "{}".data(using: .utf8)! : responseData
          let decoded = try decoder.decode(T.self, from: data)
          Console.console.log(decoded)
          DispatchQueue.main.async { completionHandler(.success(decoded)) }
        } catch {
          Console.console.log(error)
          DispatchQueue.main.async { completionHandler(.failure(error)) }
        }
      }
    ).resume()
  }
}
