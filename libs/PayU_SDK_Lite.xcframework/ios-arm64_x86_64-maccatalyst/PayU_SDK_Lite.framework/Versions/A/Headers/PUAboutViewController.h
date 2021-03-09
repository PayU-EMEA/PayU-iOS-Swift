//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUVisualStyle.h"

NS_ASSUME_NONNULL_BEGIN

/**
 This ViewController presents information about SDK Publisher & SDK itself.
 */
@interface PUAboutViewController : UITableViewController

@property (strong, nonatomic) PUVisualStyle *visualStyle;

/**
 builder method

 @param visualStyle [PUVisualStyle](#)
 */
+ (instancetype)aboutViewControllerWithVisualStyle:(PUVisualStyle *)visualStyle;

@end

NS_ASSUME_NONNULL_END
