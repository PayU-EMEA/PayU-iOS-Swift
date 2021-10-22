//
// Copyright © 2021 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PUAddCardViewConfiguration : NSObject
@property (assign, nonatomic) BOOL isHeaderVisible;
@property (assign, nonatomic) BOOL isHeaderCardProviderVisible;
@property (assign, nonatomic) BOOL isTextInputLabelsVisible;
@property (assign, nonatomic) BOOL isTextInputCardProviderVisible;
@property (assign, nonatomic) BOOL isTextInputCardScannerVisible;
@property (assign, nonatomic) BOOL isTextInputCVVActionVisible;
@property (assign, nonatomic) BOOL isFooterVisible;

@property (strong, nonatomic) NSString *cardNumberLabel;
@property (strong, nonatomic) NSString *cardNumberPlaceholder;

@property (strong, nonatomic) NSString *cardDateLabel;
@property (strong, nonatomic) NSString *cardDatePlaceholder;

@property (strong, nonatomic) NSString *cardCVVLabel;
@property (strong, nonatomic) NSString *cardCVVPlaceholder;
@property (strong, nonatomic) NSString *cardCVVAction;

@end

NS_ASSUME_NONNULL_END
