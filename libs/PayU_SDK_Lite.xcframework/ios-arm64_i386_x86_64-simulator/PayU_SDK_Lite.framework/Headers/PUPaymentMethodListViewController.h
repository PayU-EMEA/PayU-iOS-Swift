//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUVisualStyle.h"
#import "PUPaymentMethod.h"
#import "PUApplePay.h"
#import "PUPaymentMethodsConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class PUPaymentMethodListViewController;

/**
 PUPaymentMethodListViewController delegate - allows receiving user interaction callbacks.
 */
@protocol PUPaymentMethodListViewControllerDelegate
- (void)paymentMethodListViewController:(PUPaymentMethodListViewController *)paymentMethodListViewController didSelectCardToken:(PUCardToken *)cardToken;
- (void)paymentMethodListViewController:(PUPaymentMethodListViewController *)paymentMethodListViewController didSelectPayByLink:(PUPayByLink *)payByLink;
- (void)paymentMethodListViewController:(PUPaymentMethodListViewController *)paymentMethodListViewController didSelectBlikCode:(PUBlikCode *)blikCode;
- (void)paymentMethodListViewController:(PUPaymentMethodListViewController *)paymentMethodListViewController didSelectBlikToken:(PUBlikToken *)blikToken;
- (void)paymentMethodListViewController:(PUPaymentMethodListViewController *)paymentMethodListViewController didSelectApplePay:(PUApplePay *)applePay;
- (void)paymentMethodListViewController:(PUPaymentMethodListViewController *)paymentMethodListViewController didSelectPexToken:(PUPexToken *)pexToken;
- (void)paymentMethodListViewControllerDidDeselectPaymentMethod:(PUPaymentMethodListViewController *)paymentMethodListViewController;
- (void)paymentMethodListViewController:(PUPaymentMethodListViewController *)paymentMethodListViewController didDeleteCardToken:(PUCardToken *)cardToken;
- (void)paymentMethodListViewController:(PUPaymentMethodListViewController *)paymentMethodListViewController didDeletePexToken:(PUPexToken *)pexToken;

@end

@interface PUPaymentMethodListViewController : UIViewController
@property (weak, nonatomic) id<PUPaymentMethodListViewControllerDelegate> delegate;
+ (instancetype)paymentMethodListViewControllerWithConfiguration:(PUPaymentMethodsConfiguration *)configuration visualStyle:(PUVisualStyle *)visualStyle;
- (void)updateWithConfiguration:(PUPaymentMethodsConfiguration *)configuration;
- (void)clearCache; // clear stored selected method
@end

NS_ASSUME_NONNULL_END
