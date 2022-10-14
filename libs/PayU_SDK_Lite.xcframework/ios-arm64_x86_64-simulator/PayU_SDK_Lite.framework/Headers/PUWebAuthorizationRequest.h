//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUAuthorizationRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Describes authorization request.
 */

@protocol PUWebAuthorizationRequest <PUAuthorizationRequest>

@property (copy, readonly, nonatomic) NSURL *redirectUri;

@end

NS_ASSUME_NONNULL_END
