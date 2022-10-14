//
// Copyright © 2018 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUPaymentMethod.h"

NS_ASSUME_NONNULL_BEGIN

@interface PUBlikToken : NSObject <PUPaymentMethod>

@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) NSString *value;
@property (copy, readonly, nonatomic) PUBrandImageProvider* brandImageProvider;
@property (copy, readonly, nonatomic) NSString *type;
@property (copy, readonly, nonatomic) NSString *tokenHash;

@property (readonly, nonatomic) BOOL isEnabled;

- (instancetype)initWithValue:(NSString *)value
                brandImageUrl:(NSURL *)brandImageUrl
                         type:(NSString *)type
                    isEnabled:(BOOL)isEnabled DEPRECATED_MSG_ATTRIBUTE("use init with 'brandImageProvider' instead.");

- (instancetype)initWithValue:(NSString *)value
           brandImageProvider:(PUBrandImageProvider *)brandImageProvider
                         type:(NSString *)type
                    isEnabled:(BOOL)isEnabled;

@end

NS_ASSUME_NONNULL_END

