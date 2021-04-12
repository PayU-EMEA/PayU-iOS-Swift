//
// Copyright © 2020 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This error domain is used during the card scanning process if there is any error.
 Error with this domain and errorCode (PUCameraAuthorizationErrorCode) should be passed as
 a parameter to the `PUAddCardViewControllerDelegate` object in method `didFailToScanCardWithError`.
 */
extern NSString * const PUCameraAuthorizationErrorDomain;

typedef NS_ENUM(NSInteger, PUCameraAuthorizationErrorCode) {
    PUCameraAuthorizationErrorCodeRestricted = 0,
    PUCameraAuthorizationErrorCodeDenied = 1,
    PUCameraAuthorizationErrorCodeSourceIsUnavailable = 2,
};
NS_ASSUME_NONNULL_END
