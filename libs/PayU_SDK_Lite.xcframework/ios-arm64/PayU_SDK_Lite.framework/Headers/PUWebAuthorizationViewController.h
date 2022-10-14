//
//  Copyright © 2018 PayU SA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUAuthorizationDelegate.h"
#import "PUVisualStyle.h"

NS_ASSUME_NONNULL_BEGIN

@class PUWebAuthorizationViewController;

@interface PUWebAuthorizationViewController : UIViewController

@property (weak, nonatomic) id <PUAuthorizationDelegate> authorizationDelegate;
@property (strong, nonatomic) PUVisualStyle *visualStyle;

@end

NS_ASSUME_NONNULL_END
