//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PUCardData.h"
#import "PUTokenizedCardData.h"
#import "PUTokenizeRequestConfig.h"
#import "PUAPICallStatus.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PUTokienizerSuccesAction)(PUTokenizedCardData *tokenizedCard);
typedef void(^PUTokienizerFailureAction)(NSError *failureStatus);

@protocol PUCardTokenizer <NSObject>
@required
- (void)tokenizeCard:(PUCardData *)card config:(PUTokenizeRequestConfig *)config successAction:(PUTokienizerSuccesAction)successAction failureAction:(PUTokienizerFailureAction)failureAction;
@end

NS_ASSUME_NONNULL_END
