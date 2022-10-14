//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PUApplePayTransaction : NSObject
- (instancetype)initWithMerchantIdentifier:(NSString *)merchantIdentifier
                              currencyCode:(NSString *)currencyCode
                               countryCode:(NSString *)countryCode
                       contactEmailAddress:(NSString *)contactEmailAddress
                    paymentItemDescription:(NSString *)paymentItemDescription
                                    amount:(NSDecimalNumber *)amount;
@end

NS_ASSUME_NONNULL_END
