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
#import "PUBrandImageProvider.h"

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

/// Based on this property `Save & Use` button should be presented (isGuestModeEnabled = NO)
/// or hidden (isGuestModeEnabled = YES) for `Add Card` flow. Default value is `NO`
@property (assign, nonatomic) BOOL isGuestModeEnabled;

/// Enable / disable card scanning option during Add Card process. If `yes`
/// and camera is available, it should show additional button `Scan Card` under
/// input fields on the Add Card Screen.
@property (assign, nonatomic) BOOL isCardScanningEnabled API_AVAILABLE(ios(13.0)); 

/// Describes whether Bank Transfer action should be presented in PaymentMethodListViewController
@property (nonatomic) BOOL showPayByLinks;

/// Describes whether BLIK payment method should be available. Requires POS with configured BLIK payment method.
@property (nonatomic) BOOL isBlikEnabled;

/**
 This property is used to set the custom image for 'Card' method payment in 'PUPaymentMethodListViewController'.
 To use custom icon, provide instance of `PUBrandImageProvider` class. Loaded image should be placed in UIImageView with size CGSizeMake(49, 29).
 In case when 'PUBrandImageProvider' instance should be initialized with only brandImageURL, white background in imageView should appear in dark mode.
 To remove imageView backgroundColor, provide both `lightBrandImageURL` and `darkBrandImageURL`.
*/
@property (nullable, strong, nonatomic) PUBrandImageProvider* cardBrandImageProvider;

/**
 This property is used to set the custom image for 'Bank' method payment in 'PUPaymentMethodListViewController'.
 To use custom icon, provide instance of `PUBrandImageProvider` class. Loaded image should be placed in UIImageView with size CGSizeMake(49, 29).
 In case when 'PUBrandImageProvider' instance should be initialized with only brandImageURL, white background in imageView should appear in dark mode.
 To remove imageView backgroundColor, provide both `lightBrandImageURL` and `darkBrandImageURL`.
*/
@property (nullable, strong, nonatomic) PUBrandImageProvider* bankBrandImageProvider;


@end

NS_ASSUME_NONNULL_END
