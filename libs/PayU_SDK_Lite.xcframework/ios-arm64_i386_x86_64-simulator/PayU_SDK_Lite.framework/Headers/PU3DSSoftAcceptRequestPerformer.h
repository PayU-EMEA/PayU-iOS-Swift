//
// Copyright © 2021 PayU SA. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PU3DSSoftAcceptRequest.h"
#import "PU3DSSoftAcceptRequestStatus.h"

NS_ASSUME_NONNULL_BEGIN

@class PU3DSSoftAcceptRequestPerformer;

@protocol PU3DSSoftAcceptRequestPerformerDelegate
- (void)performerDidStart:(PU3DSSoftAcceptRequestPerformer*)performer;
- (void)performer:(PU3DSSoftAcceptRequestPerformer*)performer didCompleteWithStatus:(PU3DSSoftAcceptRequestStatusType) status;;
@end

@interface PU3DSSoftAcceptRequestPerformer : NSObject
@property (weak, nonatomic) id <PU3DSSoftAcceptRequestPerformerDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithRequest:(PU3DSSoftAcceptRequest *)request NS_DESIGNATED_INITIALIZER;

- (void)perform;
@end

NS_ASSUME_NONNULL_END
