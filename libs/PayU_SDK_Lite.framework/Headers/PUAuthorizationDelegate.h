//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUAuthorizationRequest.h"

/**
 Describes authorization results/status.
 */

typedef NS_ENUM(NSInteger, PUAuthorizationResult) {
    PUAuthorizationResultSuccess,
    PUAuthorizationResultFailure,
    PUAuthorizationResultContinueCvv
};

NS_ASSUME_NONNULL_BEGIN

/**
 Authorization object delegate,

 Used to inform about authorization status.
 */

@protocol PUAuthorizationDelegate

- (void)authorizationRequest:(id<PUAuthorizationRequest>)request
         didFinishWithResult:(PUAuthorizationResult)result
                       error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
