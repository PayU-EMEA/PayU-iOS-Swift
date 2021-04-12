//
// Copyright © 2019 PayU SA. All rights reserved.
// 

#import <PayU_SDK_Lite/PayU_SDK_Lite.h>

NS_ASSUME_NONNULL_BEGIN

@class PUCustomFooterAddCardViewController;

/*! @brief WARNING: By using this class YOU take the full responsibility of presenting the TERMS OF SERVICE to the user. It is advised not to use it unless you contacted PayU before. */
@interface PUCustomFooterAddCardViewController : PUAddCardViewController

/*! @brief WARNING: By using this class YOU take the full responsibility of presenting the TERMS OF SERVICE to the user. It is advised not to use it unless you contacted PayU before. */
+ (instancetype)addCardViewControllerWithVisualStyle:(PUVisualStyle *)visualStyle
                                       configuration:(PUAddCardConfiguration *)configuration
                                          footerView:(UIView *)footerView;

@end

NS_ASSUME_NONNULL_END
