//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "PUVisualStyleElement.h"

NS_ASSUME_NONNULL_BEGIN

/**
 UILabel element with visual style
 */
@interface UILabel (PUVisualStyle)

/**
 builder method

 @param style [PUVisualStyleElement](#)
 */
+ (instancetype)pu_labelWithStyle:(PUVisualStyleElement *)style;

/**
 Apply visual style to given label.

 @param style [PUVisualStyleElement](#)
 */
- (void)pu_applyStyle:(PUVisualStyleElement *)style;


@end

NS_ASSUME_NONNULL_END
