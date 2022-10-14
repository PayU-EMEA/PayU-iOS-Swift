//
// Copyright © 2020 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PUCardVisualStyle : NSObject

/**
 cell backgroundColor
*/
@property (strong, nonatomic) UIColor* backgroundColor;

/**
 cell titleTextColor
*/
@property (strong, nonatomic) UIColor* titleTextColor;

/**
 cell subtitleTextColor
*/
@property (strong, nonatomic) UIColor* subtitleTextColor;

/**
 cell borderCornerRadius
*/
@property (assign, nonatomic) CGFloat borderCornerRadius;

/**
 cell borderColor
*/
@property (strong, nonatomic) UIColor* borderColor;

/**
 cell borderWidth
*/
@property (assign, nonatomic) CGFloat borderWidth;

/**
 Initializes an `PUCardVisualStyle` object with default parameters for `enabled` state.
 Instance is adopted for Dark Appearance
 @return The newly-initialized PUCardVisualStyle instance
*/
+ (instancetype) preferredCardVisualStyleEnabled;

/**
 Initializes an `PUCardVisualStyle` object with default parameters for `disabled` state.
 Instance is adopted for Dark Appearance
 @return The newly-initialized PUCardVisualStyle instance
*/
+ (instancetype) preferredCardVisualStyleDisabled;

@end

NS_ASSUME_NONNULL_END
