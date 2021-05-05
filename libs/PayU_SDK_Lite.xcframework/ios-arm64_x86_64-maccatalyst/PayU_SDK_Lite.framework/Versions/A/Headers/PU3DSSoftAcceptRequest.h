//
// Copyright © 2021 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUEnvironment.h"

NS_ASSUME_NONNULL_BEGIN

@interface PU3DSSoftAcceptRequest: NSObject

@property (readonly, assign, nonatomic) PUEnvironment environment;
@property (readonly, strong, nonatomic) NSURL *redirectUri;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithEnvironment:(PUEnvironment)environment redirectUri:(NSURL *)redirectUri NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
