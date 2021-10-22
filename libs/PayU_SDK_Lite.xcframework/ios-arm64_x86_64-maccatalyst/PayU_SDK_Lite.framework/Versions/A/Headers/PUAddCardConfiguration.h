//
// Copyright © 2020 PayU SA. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "PUEnvironment.h"
#import "PUAddCardViewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface PUAddCardConfiguration : NSObject

@property (strong, nonatomic, readonly) NSString *posID;
@property (assign, nonatomic, readonly) PUEnvironment environment;
@property (strong, nonatomic, readonly) PUAddCardViewConfiguration *viewConfiguration;

@property (assign, nonatomic, readonly) BOOL isGuestModeEnabled;
@property (assign, nonatomic, readonly) BOOL isCardScanningEnabled API_AVAILABLE(ios(13.0));

- (instancetype)initWithPosID:(NSString *)posID
                  environment:(PUEnvironment)environment
           isGuestModeEnabled:(BOOL)isGuestModeEnabled;

/**
 Creates an instance of configuration which should be used during the Add Card process.
 
 @param posID NSString value for posID
 @param environment Environment where all actions should be done
 @param isGuestModeEnabled For `Guest` case `Save & Use` button should be hidden (Only `Use` action should be available)
 @param isCardScanningEnabled Indicates is to show or not `Scan Card` button on the Add Card Screen
 
 */
- (instancetype)initWithPosID:(NSString *)posID
                  environment:(PUEnvironment)environment
           isGuestModeEnabled:(BOOL)isGuestModeEnabled
        isCardScanningEnabled:(BOOL)isCardScanningEnabled API_AVAILABLE(ios(13.0));



@end

NS_ASSUME_NONNULL_END
