//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PUFooterView : UIView
@property (weak, nonatomic) UIViewController *UIParent;

+ (instancetype)footerViewWithUIParent:(UIViewController *)UIParent;
@end

NS_ASSUME_NONNULL_END
