//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PUVisualStyle.h"
#import "PUEnvironment.h"

NS_ASSUME_NONNULL_BEGIN

/**
 CVVAuthorization status.
 */
typedef NS_ENUM(NSInteger, PUCvvAuthorizationResult) {
    PUCvvAuthorizationStatusCanceled = 0,
    PUCvvAuthorizationStatusFailure,
    PUCvvAuthorizationStatusSuccess
};

typedef void(^PUCvvAuthorizationStatus)(PUCvvAuthorizationResult authorizationResult);

/**
 PUCvvAuthorizationHandler process whole CVV authorization (including presenting form).
 */
@interface PUCvvAuthorizationHandler : NSObject

/**
 *
 *  Use this init to create PUCvvAuthorizationHandler
 *
 *  @param visualStyle PUVisualStyle CVVAuthorization form will be stylized according to provided visual style.
 *  @param UIParent UIViewController parent ViewController to be able to present CVVAuthorization form
 */
- (instancetype)initWithVisualStyle:(PUVisualStyle *)visualStyle UIparent:(UIViewController *)UIParent environment:(PUEnvironment)environment;


/**
 *
 *  Use this method to start authorization process
 *
 *  @warning This will present UIAlertController on top of UIParent
 *
 *  @param refReqId NSString Received from PayU backend order identificator.
 *  @param status PUCvvAuthorizationStatus Callback with authorization status.
 */
- (void)authorizeRefReqId:(NSString *)refReqId status:(PUCvvAuthorizationStatus)status;
@end

NS_ASSUME_NONNULL_END
