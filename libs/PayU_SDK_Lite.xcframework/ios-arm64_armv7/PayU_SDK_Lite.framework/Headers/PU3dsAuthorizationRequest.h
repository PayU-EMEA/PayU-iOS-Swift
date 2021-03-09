//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUWebAuthorizationRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PU3dsAuthorizationRequest : NSObject<PUWebAuthorizationRequest>

@property (copy, readonly, nonatomic) NSString *orderId;
@property (copy, readonly, nonatomic) NSString *extOrderId;
@property (copy, readonly, nonatomic) NSURL *redirectUri;

- (instancetype)initWithOrderId:(NSString *)orderId
                     extOrderId:(NSString *)extOrderId
                    redirectUri:(NSURL *)redirectUri NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
