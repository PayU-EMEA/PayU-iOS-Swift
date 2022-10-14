//
// Copyright © 2019 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PUBlikAlternative : NSObject
    
@property (copy, nonatomic) NSString *appLabel;
@property (copy, nonatomic) NSString *appKey;
    
- (instancetype)initWithAppLabel:(NSString *)appLabel appKey:(NSString *)appKey;

@end

NS_ASSUME_NONNULL_END
