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
- (void)addCardViewController:(PUAddCardViewController *)viewController didAddCardWithCardToken:(PUCardToken *)cardToken;
- (void)addCardViewController:(PUAddCardViewController *)viewController didFailToAddCardWithError:(NSError *)error;
@end

@interface PUAddCardViewController: UIViewController
@property (weak, nonatomic) id<PUAddCardViewControllerDelegate> delegate;

- (instancetype)initWithWithVisualStyle:(PUVisualStyle *)visualStyle
                          configuration:(PUAddCardConfiguration *)configuration;

/**
 @param footerView By using this class YOU take the full responsibility of
 presenting the TERMS OF SERVICE to the user. It is advised not to use it unless you contacted PayU before
 */
- (instancetype)initWithWithVisualStyle:(PUVisualStyle *)visualStyle
                          configuration:(PUAddCardConfiguration *)configuration
                             footerView:(nullable UIView *)footerView;
@end

NS_ASSUME_NONNULL_END
