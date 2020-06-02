//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PUVisualStyleElement : NSObject

@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *font;
@property (assign, nonatomic) UIEdgeInsets contentInsets;
@property (assign, nonatomic) CGFloat height;

/// designated initializer for elements without height
+ (instancetype)elementWithBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor font:(UIFont *)font contentInsets:(UIEdgeInsets)contentInsets;
/// designated initializer for elements with height
+ (instancetype)elementWithBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor font:(UIFont *)font contentInsets:(UIEdgeInsets)contentInsets height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
