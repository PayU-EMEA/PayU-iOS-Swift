//
// Copyright © 2021 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "PUVisualStyle.h"
#import "PUMastercardInstallmentOrder.h"

NS_ASSUME_NONNULL_BEGIN

@class PUMastercardInstallmentsRouter;

@protocol PUMastercardInstallmentsRouterDelegate
- (void)mastercardInstallmentsRouter:(PUMastercardInstallmentsRouter *)router didConfirmOfferWithOption:(PUMastercardInstallmentOption *)option;
- (void)mastercardInstallmentsRouterDidDeclineOffer:(PUMastercardInstallmentsRouter *)router;
@end

@interface PUMastercardInstallmentsRouter : NSObject
@property (weak, nonatomic) id <PUMastercardInstallmentsRouterDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithVisualStyle:(PUVisualStyle *)visualStyle order:(PUMastercardInstallmentOrder *)order;

- (void)runFromRootViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
