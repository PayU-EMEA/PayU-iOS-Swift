//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUBrandImageProvider.h"

/**
 Describes generic payment method.
 */

@protocol PUPaymentMethod <NSObject>

@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) PUBrandImageProvider* brandImageProvider;
@property (copy, readonly, nonatomic) NSString *tokenHash;

@property (readonly, nonatomic) BOOL isEnabled;

@end
