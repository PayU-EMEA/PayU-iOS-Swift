//
// Copyright © 2020 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PUInputVisualStyle : NSObject

/**
 inputTextColor
*/
@property (strong, nonatomic) UIColor* inputTextColor;

/**
 inputTextFont
*/
@property (strong, nonatomic) UIFont* inputTextFont;

/**
 inputBackgroundColor
*/
@property (strong, nonatomic) UIColor* inputBackgroundColor;

/**
 inputBorderColor
*/
@property (strong, nonatomic) UIColor* inputBorderColor;

/**
 inputBorderWidth
*/
@property (assign, nonatomic) CGFloat inputBorderWidth;

/**
 inputCornerRadius
*/
@property (assign, nonatomic) CGFloat inputCornerRadius;

/**
 inputBottomTextColor
*/
@property (strong, nonatomic) UIColor* inputBottomTextColor;

/**
 inputBottomTextFont
*/
@property (strong, nonatomic) UIFont* inputBottomTextFont;

/**
 contentInsets
*/
@property (assign, nonatomic) UIEdgeInsets contentInsets;

/**
 intrinsic height
*/
@property (assign, nonatomic) CGFloat height;

/**
 Initializes an `PUInputVisualStyle` object with default parameters
 Instance is adopted for Dark Appearance
 @return The newly-initialized PUInputVisualStyle instance
*/
+ (instancetype) preferredInputVisualStyle;

@end

NS_ASSUME_NONNULL_END
