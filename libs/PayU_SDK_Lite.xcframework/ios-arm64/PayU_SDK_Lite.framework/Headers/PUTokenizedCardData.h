//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUTokenizedCardData: NSObject
@property (readonly, nonatomic) NSString *token;
@property (readonly, nonatomic) NSString *mask;
@property (readonly, nonatomic) NSString *type;

- (instancetype)initWithToken:(NSString *)token
                         mask:(NSString *)mask
                         type:(NSString *)type;
@end
