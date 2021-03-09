//
// Copyright © 2021 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUBrandImageProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface PUCardBrandImageProvider : NSObject

+ (PUBrandImageProvider *)maestro;
+ (PUBrandImageProvider *)mastercard;
+ (PUBrandImageProvider *)visa;

@end

NS_ASSUME_NONNULL_END
