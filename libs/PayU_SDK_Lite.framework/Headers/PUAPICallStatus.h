//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PUAPICallStatus: NSObject
@property (readonly, nonatomic, assign) NSInteger code;
@property (readonly, nonatomic) NSString *status;
@property (readonly, nonatomic) NSString *codeLiteral;

- (BOOL)isSuccess;

- (instancetype)initWithCode:(NSInteger)code status:(NSString *)status codeLiteral:(NSString *)codeLiteral;
- (instancetype)initWithError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
