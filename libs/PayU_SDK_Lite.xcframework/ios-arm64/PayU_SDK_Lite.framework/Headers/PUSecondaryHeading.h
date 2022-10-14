//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "PUVisualStyle.h"
#import "PUVisualStyleElement.h"

NS_ASSUME_NONNULL_BEGIN

/**
 SecondaryHeading UI element
 */
@interface PUSecondaryHeading : UIView

/// property allows text change
@property (strong, nonatomic) NSString *text;

/**
 builder method

 @param style [PUVisualStyle](#)
 */
+ (instancetype)secondaryHeadingWithStyle:(PUVisualStyle *)style;

@end

NS_ASSUME_NONNULL_END
