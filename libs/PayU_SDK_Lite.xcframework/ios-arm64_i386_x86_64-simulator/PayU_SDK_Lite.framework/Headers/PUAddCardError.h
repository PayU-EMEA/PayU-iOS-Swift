//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  All AddCard errors instances are allocated with this domain
 */
extern NSString * const PUAddCardErrorDomain;

/**
 *
 *  If API error/failure will contain userInfo with
 *  @note status
 *  @note codeLiteral
 */

typedef NS_ENUM(NSInteger, PUAddCardErrorCode) {
    PUAddCardErrorCodeUnknown = 0,
};

NS_ASSUME_NONNULL_END
