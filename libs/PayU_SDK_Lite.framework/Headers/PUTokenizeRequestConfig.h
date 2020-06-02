//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUEnvironment.h"

NS_ASSUME_NONNULL_BEGIN

@interface PUTokenizeRequestConfig: NSObject

@property (nonatomic, assign) PUEnvironment environment;
@property (strong, nonatomic) NSString *sender; // merchantID
@property (nonatomic, assign) BOOL agragreement;

@end

NS_ASSUME_NONNULL_END
