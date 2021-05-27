//
// Copyright © 2021 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "PUVisualStyle.h"

NS_ASSUME_NONNULL_BEGIN

@class PUMastercardInstallmentsMobileOfferViewController;

@protocol PUMastercardInstallmentsMobileOfferViewControllerDelegate
- (void)mobileOfferViewControllerDidConfirmOffer:(PUMastercardInstallmentsMobileOfferViewController*)viewController;
- (void)mobileOfferViewControllerDidDeclineOffer:(PUMastercardInstallmentsMobileOfferViewController*)viewController;
@end


@interface PUMastercardInstallmentsMobileOfferViewController : UIViewController
@property (weak, nonatomic) id <PUMastercardInstallmentsMobileOfferViewControllerDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithVisualStyle:(PUVisualStyle *)visualStyle;
@end

NS_ASSUME_NONNULL_END
