//
// Copyright © 2019 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "PUVisualStyle.h"
#import "PUBlikAlternative.h"

NS_ASSUME_NONNULL_BEGIN

@class PUBlikAlternativesViewController;

@protocol PUBlikAlternativesViewControllerDelegate
- (void)blikAlternativesViewController:(PUBlikAlternativesViewController *)blikAlternativesViewController
              didSelectBlikAlternative:(PUBlikAlternative *)blikAlternative;
@end

@interface PUBlikAlternativesViewController : UIViewController

@property (weak, nonatomic) id<PUBlikAlternativesViewControllerDelegate> delegate;

+ (instancetype)blikAlternativesViewControllerWithItemsList:(NSArray<PUBlikAlternative *> *)itemsList
                                                visualStyle:(PUVisualStyle *)visualStyle;
@end

NS_ASSUME_NONNULL_END

