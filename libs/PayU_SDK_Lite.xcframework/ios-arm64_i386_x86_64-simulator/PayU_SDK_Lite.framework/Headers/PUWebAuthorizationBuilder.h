//
//  Copyright © 2018 PayU SA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUPayByLinkAuthorizationRequest.h"
#import "PU3dsAuthorizationRequest.h"
#import "PUPexAuthorizationRequest.h"
#import "PUVisualStyle.h"

NS_ASSUME_NONNULL_BEGIN

@class PUWebAuthorizationViewController;

@interface PUWebAuthorizationBuilder : NSObject

- (PUWebAuthorizationViewController *)viewControllerForPayByLinkAuthorizationRequest:(PUPayByLinkAuthorizationRequest *)request
                                                                         visualStyle:(PUVisualStyle *)style NS_SWIFT_NAME(viewController(for:visualStyle:));

- (PUWebAuthorizationViewController *)viewControllerFor3dsAuthorizationRequest:(PU3dsAuthorizationRequest *)request
                                                                   visualStyle:(PUVisualStyle *)style NS_SWIFT_NAME(viewController(for:visualStyle:));

- (PUWebAuthorizationViewController *)viewControllerForPexAuthorizationRequest:(PUPexAuthorizationRequest *)request
                                                                   visualStyle:(PUVisualStyle *)style NS_SWIFT_NAME(viewController(for:visualStyle:));

@end

NS_ASSUME_NONNULL_END
