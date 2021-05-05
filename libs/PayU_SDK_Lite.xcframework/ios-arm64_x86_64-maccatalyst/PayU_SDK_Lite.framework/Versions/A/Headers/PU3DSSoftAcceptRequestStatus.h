//
// Copyright © 2021 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PU3DSSoftAcceptRequestStatusType) {
    PU3DSSoftAcceptRequestStatusTypeDisplayFrame,
    PU3DSSoftAcceptRequestStatusTypeAuthenticationNotRequired,
    PU3DSSoftAcceptRequestStatusTypeAuthenticationSuccessful,
    PU3DSSoftAcceptRequestStatusTypeAuthenticationCancelled,
    PU3DSSoftAcceptRequestStatusTypeUnexpected
};

@interface PU3DSSoftAcceptRequestStatus : NSObject
+ (PU3DSSoftAcceptRequestStatusType)statusForName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
