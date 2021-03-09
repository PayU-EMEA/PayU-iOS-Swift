//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUPaymentMethod.h"

NS_ASSUME_NONNULL_BEGIN

/**
 PayByLink payment method's status.
 */

typedef NS_ENUM(NSUInteger, PUPayByLinkStatus) {
    PUPayByLinkStatusEnabled,
    PUPayByLinkStatusDisabled,
    PUPayByLinkStatusTemporaryDisabled,
};

/**
 Describes PayByLink payment method.
 */

@interface PUPayByLink : NSObject <PUPaymentMethod>

@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) NSString *value;
@property (copy, readonly, nonatomic) PUBrandImageProvider* brandImageProvider;
@property (readonly, nonatomic) BOOL isEnabled;

@property (readonly, nonatomic) PUPayByLinkStatus status;

@property (copy, readonly, nonatomic) NSString *tokenHash;

- (instancetype)initWithName:(NSString *)name
                       value:(NSString *)value
               brandImageUrl:(NSURL *)brandImageUrl
                      status:(PUPayByLinkStatus)status DEPRECATED_MSG_ATTRIBUTE("use init with 'brandImageProvider' instead.");

- (instancetype)initWithName:(NSString *)name
                       value:(NSString *)value
          brandImageProvider:(PUBrandImageProvider *)brandImageProvider
                      status:(PUPayByLinkStatus)status;

@end

NS_ASSUME_NONNULL_END
