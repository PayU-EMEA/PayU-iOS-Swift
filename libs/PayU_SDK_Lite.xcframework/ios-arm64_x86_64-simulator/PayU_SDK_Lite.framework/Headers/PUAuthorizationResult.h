//
// Copyright © 2020 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const PUAuthorizationResultErrorUserInfoKey;
FOUNDATION_EXPORT NSString *const PUAuthorizationResultRefReqIdUserInfoKey;

/**
Describes authorization results/status.
*/
typedef NS_ENUM(NSInteger, PUAuthorizationResult) {
    PUAuthorizationResultSuccess,
    PUAuthorizationResultFailure,
    PUAuthorizationResultContinueCvv,
    PUAuthorizationResultExternalApplication,
    PUAuthorizationResultExternalBrowser,
};
