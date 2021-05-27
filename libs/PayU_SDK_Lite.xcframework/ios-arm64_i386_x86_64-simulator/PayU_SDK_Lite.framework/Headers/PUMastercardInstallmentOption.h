//
// Copyright © 2021 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PUMastercardInstallmentOption : NSObject

@property (strong, nonatomic, readonly) NSString* identifier;
@property (strong, nonatomic, readonly) NSNumber *interestRate;
@property (strong, nonatomic, readonly) NSNumber *installmentFeeAmount;
@property (strong, nonatomic, readonly) NSNumber *annualPercentageRate;
@property (strong, nonatomic, readonly) NSNumber *totalAmountDue;


/*
 Properties below are used only when `PUMastercardInstallmentOrder`
 instance is configuring for `PUMastercardInstallmentOptionFormatVaryingNumberOfOptions`
 `installmentOptionFormat`
 */

@property (strong, nonatomic, readonly, nullable) NSNumber *firstInstallmentAmount;
@property (strong, nonatomic, readonly, nullable) NSNumber *installmentAmount;
@property (strong, nonatomic, readonly, nullable) NSNumber *numberOfInstallments;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithWithIdentifier:(NSString*)identifier
                          interestRate:(NSNumber *)interestRate
                  installmentFeeAmount:(NSNumber *)installmentFeeAmount
                  annualPercentageRate:(NSNumber *)annualPercentageRate
                        totalAmountDue:(NSNumber *)totalAmountDue
                firstInstallmentAmount:(nullable NSNumber *)firstInstallmentAmount
                     installmentAmount:(nullable NSNumber *)installmentAmount
                  numberOfInstallments:(nullable NSNumber *)numberOfInstallments;

@end

NS_ASSUME_NONNULL_END
