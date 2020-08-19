//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUPaymentMethod.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Describes Card payment method
 */

@interface PUCardToken: NSObject <PUPaymentMethod>

@property (copy, nonatomic) NSString *name;
@property (nonatomic, copy) NSString *value;
@property (copy, readonly, nonatomic) PUBrandImageProvider* brandImageProvider;
@property (readonly, nonatomic) BOOL isEnabled;

@property (nonatomic, readonly, copy) NSString *brand DEPRECATED_MSG_ATTRIBUTE("Brand is deprecated and will be removed in future versions of the SDK. Please use 'scheme' instead.");
@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, copy) NSString *maskedNumber;
@property (nonatomic, copy) NSString *expirationYear;
@property (nonatomic, copy) NSString *expirationMonth;
@property (nonatomic, assign) BOOL preferred;

@property (copy, nonatomic) NSString *tokenHash;

- (instancetype)initWithValue:(NSString *)value
                brandImageUrl:(NSURL *)brandImageUrl
                        brand:(NSString *)brand
                 maskedNumber:(NSString *)maskedNumber
               expirationYear:(NSString *)expirationYear
              expirationMonth:(NSString *)expirationMonth
                    preferred:(BOOL)preferred
                    isEnabled:(BOOL)isEnabled DEPRECATED_MSG_ATTRIBUTE("use init with 'brandImageProvider' and 'scheme' instead.");

- (instancetype)initWithValue:(NSString *)value
           brandImageProvider:(PUBrandImageProvider *)brandImageProvider
                        brand:(NSString *)brand
                 maskedNumber:(NSString *)maskedNumber
               expirationYear:(NSString *)expirationYear
              expirationMonth:(NSString *)expirationMonth
                    preferred:(BOOL)preferred
                    isEnabled:(BOOL)isEnabled DEPRECATED_MSG_ATTRIBUTE("use init with 'brandImageProvider' and 'scheme' instead.");

- (instancetype)initWithValue:(NSString *)value
           brandImageProvider:(PUBrandImageProvider *)brandImageProvider
                       scheme:(NSString *)scheme
                 maskedNumber:(NSString *)maskedNumber
               expirationYear:(NSString *)expirationYear
              expirationMonth:(NSString *)expirationMonth
                    preferred:(BOOL)preferred
                    isEnabled:(BOOL)isEnabled;
@end

NS_ASSUME_NONNULL_END
