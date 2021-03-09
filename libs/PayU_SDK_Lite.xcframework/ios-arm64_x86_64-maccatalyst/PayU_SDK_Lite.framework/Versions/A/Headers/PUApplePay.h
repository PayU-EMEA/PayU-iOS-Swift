//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUPaymentMethod.h"
#import "PUApplePayStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface PUApplePay : NSObject <PUPaymentMethod>

@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) PUBrandImageProvider* brandImageProvider;
@property (copy, readonly, nonatomic) NSString *tokenHash;
@property (readonly, nonatomic) BOOL isEnabled;

@property (copy, readonly, nonatomic) NSString *value;
@property (readonly, nonatomic) PUApplePayStatus status;
@property (copy, readonly, nullable, nonatomic) NSString *statusDescription;

- (instancetype)initWithName:(NSString *)name
               brandImageUrl:(NSURL *)brandImageUrl
                      status:(PUApplePayStatus)status
                   isEnabled:(BOOL)isEnabled DEPRECATED_MSG_ATTRIBUTE("use init with 'brandImageProvider' instead.");

- (instancetype)initWithName:(NSString *)name
          brandImageProvider:(PUBrandImageProvider *)brandImageProvider
                      status:(PUApplePayStatus)status
                   isEnabled:(BOOL)isEnabled;

@end

NS_ASSUME_NONNULL_END
