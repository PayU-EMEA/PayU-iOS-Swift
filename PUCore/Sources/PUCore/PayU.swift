import Foundation

/// Holder of the core PayU properties which are needed to interact with packages.
public struct PayU {

  /// The country or region code for the locale.
  ///
  /// Examples of country or region codes include "GB", "FR", and "HK".
  public static var currencyCode: String! {
    didSet {
      Console.console.log(currencyCode)
    }
  }

  /// The language code for the locale.
  ///
  /// Available language codes:
  /// - `cs` (Czech)
  /// - `de` (German)
  /// - `en` (English)
  /// - `es` (Spanish)
  /// - `fr` (French)
  /// - `hu` (Hungarian)
  /// - `lv` (Latvian)
  /// - `pl` (Polish)
  /// - `ro` (Romanian)
  /// - `sl` (Slovenian)
  /// - `uk` (Ukrainian)
  ///
  /// If provided languageCode is not available - default system Locale should be used.
  public static var languageCode: String! {
    didSet {
      Console.console.log(languageCode)
    }
  }

  /// Merchant's Point of Sale
  public static var pos: POS! {
    didSet {
      Console.console.log(pos)
    }
  }
}
