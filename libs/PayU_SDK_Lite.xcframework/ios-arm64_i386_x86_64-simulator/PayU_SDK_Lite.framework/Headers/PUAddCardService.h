//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUVisualStyle.h"

#import "PUCardToken.h"
#import "PUAddCardError.h"
#import "PUEnvironment.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PUAddCardSuccesAction)(PUCardToken *card);
typedef void(^PUAddCardFailureAction)(NSError *error);

@class PUAddCardService;

/**
 *  Use this service to manage add card process (card tokenization process).
 */
@interface PUAddCardService: NSObject

/**
*
*  Use this method to get AddCard widget.
*
*  @param style AddCard widget will be stylized according to provided visual style.
*  @param UIParent ViewController which will present AddCard widget
*  @warning UIParent will be used to present Terms & Conditions (in SFSafariViewController)
*/
- (UIView *)addCardViewWithStyle:(PUVisualStyle *)style UIParent:(UIViewController *)UIParent;

/**
 *
 *  Use this method to trigger card data tokenization.
 *
 *  @param save If YES/true tokenized card will be saved on user account.
 *  @param posID Merchant identyficator used with transaction.
 *  @param successAction Success callback.
 *  @param failureAction Failure callback.
 *  @param environment Switch type of network environment where all calls are done.
 */
- (void)addCardAndSave:(BOOL)save
                 posID:(NSString *)posID
           environment:(PUEnvironment)environment
               success:(PUAddCardSuccesAction)successAction
               failure:(PUAddCardFailureAction)failureAction;


@end

NS_ASSUME_NONNULL_END
