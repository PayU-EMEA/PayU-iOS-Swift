//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUVisualStyle.h"
#import "PUVisualStyleElement.h"

NS_ASSUME_NONNULL_BEGIN

/**
 UIButton element with visula style
 */
@interface UIButton (PUVisualStyle)

/**
 builder method

 @param style [PUVisualStyle](#)
 */
+ (instancetype)primaryButtonWithStyle:(PUVisualStyle *)style;

/**
 builder method

 @param style [PUVisualStyle](#)
 */
+ (instancetype)basicButtonWithStyle:(PUVisualStyle *)style;

/**
 builder method

 @param style [PUVisualStyle](#)
 */
+ (instancetype)inactiveButtonWithStyle:(PUVisualStyle *)style;

@end

NS_ASSUME_NONNULL_END
