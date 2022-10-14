//
// Copyright © 2018 PayU SA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUVisualStyle.h"

#import "PUCardToken.h"
#import "PUAddCardError.h"
#import "PUEnvironment.h"

#import "PUAddCardViewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PUAddCardSuccesAction)(PUCardToken *card);
typedef void(^PUAddCardFailureAction)(NSError *error);

typedef void(^PUScanCardSuccesAction)(void);
typedef void(^PUScanCardFailureAction)(NSError *error);

@class PUAddCardService;

@protocol PUAddCardServiceDelegate
@optional
- (void)addCardServiceDidTriggerCVVAction:(PUAddCardService *)addCardService NS_SWIFT_NAME(addCardServiceDidTriggerCVVAction(addCardService:));
@end

/**
 *  Use this service to manage add card process (card tokenization process).
 */
@interface PUAddCardService: NSObject
@property (weak, nonatomic) id <PUAddCardServiceDelegate> delegate;

/**
 *
 *  Use this method to trigger card scanning process AddCard widget.
 *
 *  @param visualStyle Visual style for the controller.
 *  @param presentingViewController ViewController which will present card scanning flow
 *  @param onSuccess Callback which will trigger in case of success card scanning process
 *  @param onFailure Callback which will trigger in case of failure card scanning process
 *  @warning merchant must handle camera permissions in Info.plist
 *
 */
- (void)scanCardWithVisualStyle:(PUVisualStyle *)visualStyle
       presentingViewController:(UIViewController *)presentingViewController
                        success:(nullable PUScanCardSuccesAction)onSuccess
                        failure:(nullable PUScanCardFailureAction)onFailure API_AVAILABLE(ios(13.0));

/**
 *
 *  Use this method to get AddCard widget.
 *
 *  @param visualStyle AddCard widget will be stylized according to provided visual style.
 *  @param presentingViewController ViewController which will present AddCard widget
 *  @warning presentingViewController will be used to present Terms & Conditions (in SFSafariViewController)
 */
- (UIView *)addCardViewWithVisualStyle:(PUVisualStyle *)visualStyle
                     viewConfiguration:(PUAddCardViewConfiguration *)viewConfiguration
              presentingViewController:(UIViewController *)presentingViewController;

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
