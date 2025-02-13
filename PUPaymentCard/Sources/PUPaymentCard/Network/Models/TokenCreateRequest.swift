//
//  TokenizeRequest.swift
//

struct TokenCreateRequest: Codable, Equatable {

  // MARK: - Public Properties
  public let posId: String
  public let type: String
  public let card: PaymentCard

  // MARK: - Public Methods
  public static func build(
    posId: String,
    tokenType: TokenType,
    card: PaymentCard
  ) -> TokenCreateRequest {
    return TokenCreateRequest(
      posId: posId,
      type: tokenType.rawValue,
      card: card
    )
  }
}
