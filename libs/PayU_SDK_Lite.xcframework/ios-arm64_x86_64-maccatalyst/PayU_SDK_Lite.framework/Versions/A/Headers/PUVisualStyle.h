//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "PUVisualStyleElement.h"
#import "PUCardVisualStyle.h"
#import "PUInputVisualStyle.h"
#import "PUButtonVisualStyle.h"
#import "PUBrandImageProvider.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Each module can be configured to utilize defined by merchants colors and other properties.

 PUVisualStyle objects is used to visually style PayU-SDK UI components.
 */

@interface PUVisualStyle : NSObject

/// default value: #FCFCFC
@property (strong, nonatomic) UIColor *primaryBackgroundColor;

/// default value: #54BBAB
@property (strong, nonatomic) UIColor *accentColor;

/**
 value to set for `navigationBar.barTintColor`
*/
@property (strong, nonatomic) UIColor *navigationBarTintColor;

/**
 `cardVisualStyleEnabled` is used for `enabled` card-styled cells
 Used in:
    - `PUPaymentMethodListViewController`
    - `PUBlikAlternativesViewController`
*/
@property (strong, nonatomic) PUCardVisualStyle *cardVisualStyleEnabled;

/**
 `cardVisualStyleDisabled` is used for `disabled` card-styled cells
 Used in:
    - `PUPaymentMethodListViewController`
    - `PUBlikAlternativesViewController`
*/
@property (strong, nonatomic) PUCardVisualStyle *cardVisualStyleDisabled;

/**
 `inputVisualStyle` is used to style input view, such as: card number input, cvv input, etc.
*/
@property (strong, nonatomic) PUInputVisualStyle *inputVisualStyle;

/*!
 'primaryButtonStyle' is used for primary buttons, such as: 'Save an use' button in card create flow, etc.
 */
@property (strong, nonatomic) PUButtonVisualStyle *primaryButtonStyle;

/*!
 'basicButtonStyle' is used for basic buttons, such as: 'Use' button in card create flow, etc.
*/
@property (strong, nonatomic) PUButtonVisualStyle *basicButtonStyle;

/*!
 'inactiveButtonStyle' is used for inactive buttons
*/
@property (strong, nonatomic) PUButtonVisualStyle *inactiveButtonStyle;

@property (strong, nonatomic) PUVisualStyleElement *secondaryHeadingStyle;

@property (strong, nonatomic) PUVisualStyleElement *primaryTextStyle;
@property (strong, nonatomic) PUVisualStyleElement *secondaryTextStyle;

/**
 This property is used to set the `titleView` for `navigationBar` for viewControllers where it is available (for ex. 'PUPaymentMethodListViewController').
 To use custom logo, provide instance of `PUBrandImageProvider` class. Loaded image should be placed in UIImageView with size CGSizeMake(70, 35)
 By default, it should show `PayU` logo.
*/
@property (strong, nonatomic) PUBrandImageProvider* logoImageProvider;

/**
 default UI style created by PayU

 with:
 
 - Open Sans family fonts (normal 14px, small 12px, large 18px)
 */

+ (instancetype)defaultStyle;

@end

NS_ASSUME_NONNULL_END
