//
//  WebPaymentsAssembler.swift
//  
//  Created by PayU S.A. on 09/03/2023.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

#if canImport(PUAPI)
import PUAPI
#endif

#if canImport(PUCore)
import PUCore
#endif

final class WebPaymentsAssembler {

  func makeCVVAuthorizationTextFormatter() -> TextFormatterProtocol {
    TextFormatterFactory().makeCVV()
  }

  func makeCVVAuthorizationPresenter() -> CVVAuthorizationPresenter {
    CVVAuthorizationPresenter(formatter: makeCVVAuthorizationTextFormatter())
  }

  func makeCVVAuthorizationNetworkClient() -> CVVAuthorizationNetworkClient {
    CVVAuthorizationNetworkClient(client: makeNetworkClient())
  }

  func makeCVVAuthorizationRepository() -> CVVAuthorizationRepository {
    CVVAuthorizationRepository(client: makeCVVAuthorizationNetworkClient())
  }

  func makeCVVAuthorizationService() -> CVVAuthorizationService {
    CVVAuthorizationService(
      presenter: makeCVVAuthorizationPresenter(),
      repository: makeCVVAuthorizationRepository())
  }

  func makeNetworkClient() -> NetworkClient {
    NetworkClient.Factory().make()
  }

  func makeWebPaymentsUrlMatcherFactory() -> WebPaymentsUrlMatcherFactory {
    WebPaymentsUrlMatcherFactory()
  }

  func makePaymentsViewController(request: WebPaymentsRequest) -> WebPaymentsViewController {
    WebPaymentsViewController(viewModel: makeWebPaymentsViewModel(request: request))
  }

  func makeWebPaymentsViewModel(request: WebPaymentsRequest) -> WebPaymentsViewModel {
    WebPaymentsViewModel(
      matcher: makeWebPaymentsUrlMatcherFactory().make(for: request),
      request: request)
  }
}
