//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>

/**
 Each network request can be send either to production or sandbox environment.
 */

typedef NS_ENUM(NSUInteger, PUEnvironment) {
    PUEnvironmentProduction,
    PUEnvironmentSandbox,
};
