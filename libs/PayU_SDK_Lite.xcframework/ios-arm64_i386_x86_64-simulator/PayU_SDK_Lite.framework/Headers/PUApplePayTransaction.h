//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PUCurrencyCode) {
    PUCurrencyCodePLN,
    PUCurrencyCodeCZK,
    PUCurrencyCodeEUR,
    PUCurrencyCodeUSD,
    PUCurrencyCodeGBP,
    PUCurrencyCodeRON,
    PUCurrencyCodeHUF,
    PUCurrencyCodeHRK,
    PUCurrencyCodeSEK,
    PUCurrencyCodeNOK,
    PUCurrencyCodeDKK,
};

typedef NS_ENUM(NSUInteger, PUCountryCode) {
    PUCountryCodePL,
    PUCountryCodeCZ,
    PUCountryCodeDE,
    PUCountryCodeUS,
    PUCountryCodeGB,
    PUCountryCodeRO,
    PUCountryCodeHU,
    PUCountryCodeHR,
    PUCountryCodeSE,
    PUCountryCodeNO,
    PUCountryCodeDK,
};

@interface PUApplePayTransaction : NSObject
- (instancetype)initWithMerchantIdentifier:(NSString *)merchantIdentifier
                              currencyCode:(PUCurrencyCode)currencyCode
                               countryCode:(PUCountryCode)countryCode
                       contactEmailAddress:(NSString *)contactEmailAddress
                   paymentItemDescription:(NSString *)paymentItemDescription
                                    amount:(NSDecimalNumber *)amount;
@end

NS_ASSUME_NONNULL_END
