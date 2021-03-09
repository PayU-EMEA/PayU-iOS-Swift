//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>

#import "PUVisualStyle.h"
#import "PUCardToken.h"
#import "PUEnvironment.h"

NS_ASSUME_NONNULL_BEGIN

@class PUAddCardViewController;

@protocol PUAddCardViewControllerDelegate

- (void)addCardViewController:(PUAddCardViewController *)viewController didAddCardWithCardToken:(PUCardToken *)cardToken;
- (void)addCardViewController:(PUAddCardViewController *)viewController didFailToAddCardWithError:(NSError *)error;

@end

@interface PUAddCardViewController: UIViewController
@property (weak, nonatomic) id<PUAddCardViewControllerDelegate> delegate;

+ (instancetype)addCardViewControllerWithVisualStyle:(PUVisualStyle *)visualStyle posID:(NSString *)posID environment:(PUEnvironment)environment;
@end

NS_ASSUME_NONNULL_END
