//
// Copyright © 2021 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PUSDKConfiguration : NSObject

/// Primary language to be used for PayU SDK texts
/// Available codes:
///   - cs (Czech),
///   - de (German),
///   - en (English),
///   - es (Spanish),
///   - hu (Hungarian),
///   - pl (Polish),
///   - sk (Slovak)
///   - uk (Ukrainian),
/// If provided languageCode is not available - default system Locale should be used.
@property (strong, nonatomic, nullable) NSString *languageCode;

+ (PUSDKConfiguration *)instance;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
