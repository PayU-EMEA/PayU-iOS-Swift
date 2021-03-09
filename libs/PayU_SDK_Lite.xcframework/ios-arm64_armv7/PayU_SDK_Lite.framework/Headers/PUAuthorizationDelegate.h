//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUAuthorizationRequest.h"
#import "PUAuthorizationResult.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PUAuthorizationDelegate

/**

 Informs @b PUAuthorizationDelegate instance that @b PUAuthorizationRequest object did finish authorization. Based on result type, userInfo should contain next information if there were no errors during processing:

 Based on result type, userInfo should contain next information if there were no errors during processing:

 - @b PUAuthorizationResultSuccess - `userInfo` should be empty

 - @b PUAuthorizationResultFailure - `userInfo` should contain detailed NSError value for key `PUAuthorizationResultErrorUserInfoKey`

 - @b PUAuthorizationResultContinueCvv - `userInfo` should contain `refReqId` value for key `PUAuthorizationResultRefReqIdUserInfoKey`. After you receive this result, there is needed an additional action to authorize CVV via `PUCVVAuthorizationHandler`

 @param request The @b PUAuthorizationRequest instance.
 @param result The result of authorization. Presented as `enum` @b PUAuthorizationResult.
 @param userInfo The additional user info which may contain values for keys declared in `PUAuthorizationResult.h`.

*/
- (void)authorizationRequest:(id<PUAuthorizationRequest>)request
         didFinishWithResult:(PUAuthorizationResult)result
                    userInfo:(nullable NSDictionary*)userInfo;

@end

NS_ASSUME_NONNULL_END
