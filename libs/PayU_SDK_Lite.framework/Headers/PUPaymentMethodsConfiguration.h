//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUCardToken.h"
#import "PUPayByLink.h"
#import "PUBlikCode.h"
#import "PUBlikToken.h"
#import "PUPexToken.h"
#import "PUEnvironment.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Global configuration object
 */

@interface PUPaymentMethodsConfiguration : NSObject

/// Describes MerchantID
@property (copy, nonatomic) NSString *posID;

/// Describes which environment should be used for network calls
@property (nonatomic) PUEnvironment environment;

/// CardTokens retrived for user from PayU backend
@property (copy, nonatomic) NSArray <PUCardToken *> *cardTokens;

/// BlikTokens retrived for user from PayU backend
@property (copy, nonatomic) NSArray <PUBlikToken *> *blikTokens;

/// PayByLinks retrived for user from PayU backend
@property (copy, nonatomic) NSArray <PUPayByLink *> *payByLinks;

/// PEX Tokens retrived for user from PayU backend
@property (copy, nonatomic) NSArray <PUPexToken *> *pexTokens;

/// Describes whether Add Card action should be presented in PaymentMethodListViewController
@property (nonatomic) BOOL showAddCard;

/// Describes whether Bank Transfer action should be presented in PaymentMethodListViewController
@property (nonatomic) BOOL showPayByLinks;

/// Describes whether BLIK payment method should be available. Requires POS with configured BLIK payment method.
@property (nonatomic) BOOL isBlikEnabled;


@end

NS_ASSUME_NONNULL_END
