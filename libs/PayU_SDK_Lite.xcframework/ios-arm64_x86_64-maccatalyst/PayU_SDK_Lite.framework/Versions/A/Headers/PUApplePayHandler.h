//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUApplePayTransaction.h"

@class PUApplePayHandler;

@protocol PUApplePayHandlerDelegate <NSObject>
- (void)paymentTransactionCanceledByUser:(PUApplePayTransaction *)transaction;
- (void)paymentTransaction:(PUApplePayTransaction *)transaction result:(NSString *)result;
@end

@interface PUApplePayHandler : NSObject
@property (weak, nonatomic) id<PUApplePayHandlerDelegate> delegate;
- (void)authorizeTransaction:(PUApplePayTransaction *)transaction withUIparent:(UIViewController *)UIParent;
@end
