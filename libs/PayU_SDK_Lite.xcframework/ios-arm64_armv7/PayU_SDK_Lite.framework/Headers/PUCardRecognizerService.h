//
// Copyright © 2021 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "PUVisualStyle.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PUCardRecognizerServiceSuccessAction)(NSString *number, NSString *date);
typedef void(^PUCardRecognizerServiceFailureAction)(NSError *error);

@class PUAddCardService;

API_AVAILABLE(ios(13.0))
@interface PUCardRecognizerService: NSObject

/**
 *
 *  Use this method to trigger card data recognizer.
 *
 *  @param viewController ViewController from which card scanner should be presented
 *  @param success Success callback.
 *  @param failure Failure callback.
 */
- (void)recognizeCardFromViewController:(UIViewController *)viewController
                            visualStyle:(PUVisualStyle *)visualStyle
                                success:(PUCardRecognizerServiceSuccessAction)success
                                failure:(PUCardRecognizerServiceFailureAction)failure;

@end

NS_ASSUME_NONNULL_END
