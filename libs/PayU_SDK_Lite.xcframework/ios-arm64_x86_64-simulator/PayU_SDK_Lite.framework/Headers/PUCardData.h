//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUCardData : NSObject
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *cvv;
@property (strong, nonatomic) NSString *expirationMonthString;
@property (strong, nonatomic) NSString *expirationYearString;
@end
