//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Describes authorization request.
 */

@protocol PUAuthorizationRequest

@property (copy, readonly, nonatomic) NSString *orderId;
@property (copy, readonly, nonatomic) NSString *extOrderId;

@end

NS_ASSUME_NONNULL_END
