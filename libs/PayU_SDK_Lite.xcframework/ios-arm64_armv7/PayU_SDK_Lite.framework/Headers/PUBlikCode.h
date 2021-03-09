//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUPaymentMethod.h"

NS_ASSUME_NONNULL_BEGIN

@interface PUBlikCode : NSObject <PUPaymentMethod>

@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) NSString *value;
@property (copy, readonly, nonatomic) PUBrandImageProvider* brandImageProvider;
@property (readonly, nonatomic) BOOL isEnabled;

@property (copy, readonly, nonatomic) NSString *tokenHash;

@end

NS_ASSUME_NONNULL_END
