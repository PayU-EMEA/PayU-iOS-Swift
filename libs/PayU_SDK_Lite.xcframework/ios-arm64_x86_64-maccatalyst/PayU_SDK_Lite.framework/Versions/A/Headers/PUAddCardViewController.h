//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>

#import "PUVisualStyle.h"
#import "PUCardToken.h"
#import "PUEnvironment.h"
#import "PUAddCardConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class PUAddCardViewController;

@protocol PUAddCardViewControllerDelegate <NSObject>

@required
- (void)addCardViewController:(PUAddCardViewController *)viewController
      didAddCardWithCardToken:(PUCardToken *)cardToken;
- (void)addCardViewController:(PUAddCardViewController *)viewController
    didFailToAddCardWithError:(NSError *)error;

@optional
- (void)addCardViewController:(PUAddCardViewController *)viewController
    didFailToScanCardWithError:(NSError *)error;

@end

@interface PUAddCardViewController: UIViewController

@property (weak, nonatomic) id<PUAddCardViewControllerDelegate> delegate;

+ (instancetype)addCardViewControllerWithVisualStyle:(PUVisualStyle *)visualStyle
                                       configuration:(PUAddCardConfiguration *)configuration;
@end

NS_ASSUME_NONNULL_END
