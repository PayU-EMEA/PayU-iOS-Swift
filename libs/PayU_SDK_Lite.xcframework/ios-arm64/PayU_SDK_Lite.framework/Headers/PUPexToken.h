//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUPaymentMethod.h"

NS_ASSUME_NONNULL_BEGIN

/**
 PEX payment method status.
 */

typedef NS_ENUM(NSUInteger, PUPexTokenStatus) {
    PUPexTokenStatusActive,
    PUPexTokenStatusDisabled,
};

/**
 Describes PEX payment method.
 */

@interface PUPexToken : NSObject <PUPaymentMethod>

@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) NSString *value;
@property (copy, readonly, nonatomic) PUBrandImageProvider* brandImageProvider;
@property (readonly, nonatomic) BOOL isEnabled;

@property (copy, readonly, nonatomic) NSString *accountNumber;
@property (readonly, nonatomic) PUPexTokenStatus status;
@property (copy, readonly, nonatomic) NSString *payType;
@property (readonly, nonatomic) BOOL preferred;

@property (copy, readonly, nonatomic) NSString *tokenHash;

- (instancetype)initWithName:(NSString *)name
                       value:(NSString *)value
               brandImageUrl:(NSURL *)brandImageUrl
               accountNumber:(NSString *)accountNumber
                      status:(PUPexTokenStatus)status
                     payType:(NSString *)payType
                   preferred:(BOOL)preferred
                   isEnabled:(BOOL)isEnabled DEPRECATED_MSG_ATTRIBUTE("use init with 'brandImageProvider' instead.");

- (instancetype)initWithName:(NSString *)name
                       value:(NSString *)value
          brandImageProvider:(PUBrandImageProvider *)brandImageProvider
               accountNumber:(NSString *)accountNumber
                      status:(PUPexTokenStatus)status
                     payType:(NSString *)payType
                   preferred:(BOOL)preferred
                   isEnabled:(BOOL)isEnabled;

@end

NS_ASSUME_NONNULL_END
