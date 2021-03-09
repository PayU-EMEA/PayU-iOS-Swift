//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUVisualStyle.h"
#import "PUPaymentMethodsConfiguration.h"
#import "PUPaymentMethodListViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Represents clickable PaymentMethod widget.

 @warning Created by PaymentWidgetService

 User available action:
 - click: creates PaymentMethodListViewController
 */

@interface PUPaymentWidget : UIView

@property (strong, nonatomic) PUVisualStyle *visualStyle;

@end

NS_ASSUME_NONNULL_END
