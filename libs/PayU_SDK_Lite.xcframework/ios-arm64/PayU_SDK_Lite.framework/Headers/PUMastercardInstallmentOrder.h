//
// Copyright © 2021 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUMastercardInstallmentOption.h"
#import "PUMastercardInstallmentOptionFormat.h"


NS_ASSUME_NONNULL_BEGIN

@interface PUMastercardInstallmentOrder : NSObject

@property (strong, nonatomic, readonly) NSString *identifier;
@property (strong, nonatomic, readonly) NSString *cardScheme;
@property (assign, nonatomic, readonly) PUMastercardInstallmentOptionFormat installmentOptionFormat;
@property (strong, nonatomic, readonly) NSString *currencyCode;
@property (strong, nonatomic, readonly) NSArray<PUMastercardInstallmentOption *> *installmentOptions;
@property (strong, nonatomic, readonly) NSLocale *locale;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithWithIdentifier:(NSString *)identifier
                            cardScheme:(NSString *)cardScheme
               installmentOptionFormat:(PUMastercardInstallmentOptionFormat)installmentOptionFormat
                          currencyCode:(NSString *)currencyCode
                    installmentOptions:(NSArray<PUMastercardInstallmentOption *> *)installmentOptions
                                locale:(NSLocale *)locale;

@end


NS_ASSUME_NONNULL_END
