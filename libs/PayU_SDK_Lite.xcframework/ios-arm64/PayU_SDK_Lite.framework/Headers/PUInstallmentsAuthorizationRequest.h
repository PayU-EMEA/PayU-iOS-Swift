//
// Copyright © 2021 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUWebAuthorizationRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PUInstallmentsAuthorizationRequest : NSObject<PUWebAuthorizationRequest>

@property (copy, readonly, nonatomic) NSString *orderId;
@property (copy, readonly, nonatomic) NSString *extOrderId;
@property (copy, readonly, nonatomic) NSURL *redirectUri;
@property (copy, readonly, nonatomic) NSURL *continueUrl;


- (instancetype)initWithOrderId:(NSString *)orderId
                     extOrderId:(NSString *)extOrderId
                    redirectUri:(NSURL *)redirectUri
                    continueUrl:(NSURL *)continueUrl NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(orderId:extOrderId:redirectUri:continueUrl:));

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
