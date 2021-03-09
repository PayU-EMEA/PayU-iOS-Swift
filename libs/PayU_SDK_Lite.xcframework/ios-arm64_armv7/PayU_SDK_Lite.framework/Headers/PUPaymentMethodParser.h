//
// Copyright © 2020 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUPayByLink.h"
#import "PUCardToken.h"
#import "PUPexToken.h"
#import "PUBlikToken.h"

FOUNDATION_EXPORT NSString *const PUPaymentMethodParserErrorDomain;
FOUNDATION_EXPORT NSInteger const PUPaymentMethodParserMissingKeyErrorCode;
FOUNDATION_EXPORT NSInteger const PUPaymentMethodParserInvalidStatusErrorCode;

/**
 Default json parser for payment methods. Data parsed by this parser should be fetch from the paymethods API endpoint.
*/
@interface PUPaymentMethodParser : NSObject
- (PUPayByLink *)parsePayByLinkMethodFromJSONData:(NSData *)data error:(NSError **)error;
- (PUCardToken *)parseCardTokenMethodFromJSONData:(NSData *)data error:(NSError **)error;
- (PUPexToken *)parsePexTokenMethodFromJSONData:(NSData *)data error:(NSError **)error;
- (PUBlikToken *)parseBlikTokenMethodFromJSONData:(NSData *)data error:(NSError **)error;
@end
