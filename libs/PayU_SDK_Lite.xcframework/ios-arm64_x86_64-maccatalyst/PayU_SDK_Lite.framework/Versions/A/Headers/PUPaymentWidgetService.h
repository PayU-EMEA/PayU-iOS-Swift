//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUPaymentWidget.h"
#import "PUPaymentMethodsConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class PUPaymentWidgetService;

/**
 PUPaymentWidgetService delegate - allows receiving user interaction callbacks.
 */
@protocol PUPaymentWidgetServiceDelegate

- (void)paymentWidgetService:(PUPaymentWidgetService *)paymentWidgetService didSelectCardToken:(PUCardToken *)cardToken;
- (void)paymentWidgetService:(PUPaymentWidgetService *)paymentWidgetService didSelectPayByLink:(PUPayByLink *)payByLink;
- (void)paymentWidgetService:(PUPaymentWidgetService *)paymentWidgetService didSelectApplePay:(PUApplePay *)applePay;
- (void)paymentWidgetService:(PUPaymentWidgetService *)paymentWidgetService didSelectBlikCode:(PUBlikCode *)blikCode;
- (void)paymentWidgetService:(PUPaymentWidgetService *)paymentWidgetService didSelectBlikToken:(PUBlikToken *)blikToken;
- (void)paymentWidgetService:(PUPaymentWidgetService *)paymentWidgetService didSelectPexToken:(PUPexToken *)pexToken;
- (void)paymentWidgetService:(PUPaymentWidgetService *)paymentWidgetService didSelectInstallment:(PUInstallment *)installment;
- (void)paymentWidgetServiceDidDeselectPaymentMethod:(PUPaymentWidgetService *)paymentWidgetService;
- (void)paymentWidgetService:(PUPaymentWidgetService *)paymentWidgetService didDeleteCardToken:(PUCardToken *)cardToken;
- (void)paymentWidgetService:(PUPaymentWidgetService *)paymentWidgetService didDeletePexToken:(PUPexToken *)pexToken;

@end

@interface PUPaymentWidgetService : NSObject

@property (weak, nullable, nonatomic) id<PUPaymentWidgetServiceDelegate> delegate;
@property (strong, readonly, nullable, nonatomic) id<PUPaymentMethod> selectedPaymentMethod;
@property (readonly, nonatomic) BOOL isBlikAuthorizationCodeRequired;
@property (strong, readonly, nullable, nonatomic) NSString *blikAuthorizationCode;

- (instancetype)initWithConfiguration:(PUPaymentMethodsConfiguration *)configuration NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)updateWithConfiguration:(PUPaymentMethodsConfiguration *)configuration;
- (PUPaymentWidget *)getWidgetWithStyle:(PUVisualStyle *)style;
- (void)clearCache; // clear stored selected method

@end

NS_ASSUME_NONNULL_END
