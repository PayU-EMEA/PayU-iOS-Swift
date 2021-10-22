//
// Copyright © 2020 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class PUBrandImageProvider
 @brief The PUBrandImageProvider class gives ability to work with dynamic image url based on 'UITraitCollection' userInterfaceStyle value.
 */
@interface PUBrandImageProvider : NSObject <NSCopying>

/*!
 Instance method.
 @param  imageURL image URL for both light and dark modes
 */
- (instancetype)initWithBrandImageURL:(NSURL*) imageURL;

/*!
 Instance method
 @param  lightBrandImageURL image URL for application light mode
 @param  darkBrandImageURL image URL for application dark mode
 */
- (instancetype)initWithLightBrandImageURL:(NSURL*)lightBrandImageURL darkBrandImageURL:(NSURL *)darkBrandImageURL;

/*!
 This method returns preferred imageURL for image
 @param  traitCollection  Current UITraitCollection instance
 @return NSURL branding image URL. Should return 'darkBrandImageURL' for dark mode (if exist), otherwise - 'lightBrandImageURL'
 */
- (NSURL*)brandImageURLForTraitCollection:(UITraitCollection *)traitCollection;

/*!
 This method returns preferred backgroundColor for brand imageView
 @param  traitCollection  Current UITraitCollection instance
 @return UIColor - backgroundColor for brand imageView
 */
- (UIColor*)brandImageBackgroundColorForTraitCollection:(UITraitCollection*)traitCollection;

@end

NS_ASSUME_NONNULL_END
