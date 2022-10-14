//
// Copyright © 2020 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface PUButtonVisualStyle : NSObject

/**
 button's borderColor.
 */
@property (strong, nonatomic) UIColor* buttonBorderColor;

/**
 button's borderWidth.
*/
@property (assign, nonatomic) CGFloat buttonBorderWidth;

/**
 button's cornerRadius.
*/
@property (assign, nonatomic) CGFloat buttonCornerRadius;

/**
 button's backgroundColor.
*/
@property (strong, nonatomic) UIColor* buttonBackgroundColor;

/**
 button's contentInsets.
*/
@property (assign, nonatomic) UIEdgeInsets buttonContentInsets;

/**
 button's textFont.
*/
@property (strong, nonatomic) UIFont* buttonTextFont;

/**
 button's textColor.
*/
@property (strong, nonatomic) UIColor* buttonTextColor;

/**
 button's height. Should automaticaly add 'heightAnchor'
*/
@property (assign, nonatomic) CGFloat buttonHeight;

/**
 Initializes an `PUButtonVisualStyle` object with default parameters for `primary` style.
 Instance is adopted for Dark Appearance
 @return The newly-initialized PUButtonVisualStyle instance
*/
+ (instancetype) preferredPrimaryButtonVisualStyle;

/**
 Initializes an `PUButtonVisualStyle` object with default parameters for `basic` style.
 Instance is adopted for Dark Appearance
 @return The newly-initialized PUButtonVisualStyle instance
*/
+ (instancetype) preferredBasicButtonVisualStyle;

/**
 Initializes an `PUButtonVisualStyle` object with default parameters for `inactive` style.
 Instance is adopted for Dark Appearance
 @return The newly-initialized PUButtonVisualStyle instance
*/
+ (instancetype) preferredInactiveButtonVisualStyle;

@end

NS_ASSUME_NONNULL_END
