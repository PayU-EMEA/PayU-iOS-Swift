//
// Copyright © 2021 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUPaymentMethod.h"
#import "PUBrandImageProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface PUInstallment : NSObject <PUPaymentMethod>

@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) NSString *detail;
@property (copy, readonly, nonatomic) NSString *value;
@property (copy, readonly, nonatomic) PUBrandImageProvider* brandImageProvider;
@property (copy, readonly, nonatomic) NSString *tokenHash;
@property (readonly, nonatomic) BOOL isEnabled;

- (instancetype)initWithBrandImageProvider:(nullable PUBrandImageProvider *)brandImageProvider;

@end

NS_ASSUME_NONNULL_END
