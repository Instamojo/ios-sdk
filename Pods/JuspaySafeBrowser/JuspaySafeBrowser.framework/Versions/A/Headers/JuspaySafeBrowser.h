/*
 * JUSPAY CONFIDENTIAL
 * __________________
 *
 * [2012] - [2016] JusPay Technologies Pvt Ltd
 * All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of JusPay Technologies Pvt Ltd. The intellectual
 * and technical concepts contained
 * herein are proprietary to JusPay Techologies Pvt Ltd
 * and may be covered by Indian Patents Office and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from JusPay Technologies Pvt Ltd.
 */

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BrowserParams.h"
#import "JPLogger.h"
#import "JuspayCodes.h"

/**
 Callback which is triggered when the transaction has reached endURL or cancelled by user.

 @param status True if endURL reached , false if canceled by user.
 @param error Error causing the url transaction to fail.
 @param info Info contains a set of infromation passed while starting transaction like OrderId or TransactionId.
 */
typedef void(^JPBlock)(Boolean status,NSError* _Nullable error, id _Nullable info);

/**
 Callback which is triggered when the transaction has reached endURL or cancelled by user.

 @param status True if endURL reached , false if canceled by user.
 @param error Error causing the url transaction to fail.
 @param info Info contains a set of infromation passed while starting transaction like OrderId or TransactionId.
 @param webView An instance of WKWebView with last url loaded
 */
typedef void(^JPWBBlock)(Boolean status,NSError* _Nullable error, id _Nullable info, WKWebView* _Nullable webView);

typedef void(^JuspayWebviewCallback)(WKWebView * _Nullable webView);

typedef void(^JuspayResponseCallback)(NSString *response, NSString *error);

@protocol JuspaySafeBrowserDelegate <NSObject>

@optional

/**
 Delegate method to check if url should be loaded.

 @param url URL to be loaded.
 @return True if url should be loaded, else false.
 */
- (BOOL)browserShouldStartLoadingUrl:(NSURL * _Nullable)url;

/**
 Delegates indicates start of a url loading.

 @param url URL starting to load.
 */
- (void)browserDidStartLoadingUrl:(NSURL * _Nullable)url;

/**
 Delegates indicates finish of a url loading.

 @param url URL finished loading.
 */
- (void)browserDidFinishLoadUrl:(NSURL * _Nullable)url;

/**
 Delegates indicates failure of a url loading.

 @param url URL failed to load.
 @param error Error which caused url to fail.
 */
- (void)browserDidFailLoadingUrl:(NSURL* _Nullable)url withError:(NSError *_Nullable)error;

- (void)onEvent:(NSString *)event payload:(NSString *)payload responseCallback:(JuspayResponseCallback)callback;

@end

@interface JuspaySafeBrowser : UIView

@property (nonatomic, copy) JuspayWebviewCallback _Nullable webviewCallback;

/**
 JuspaySafeBrowser delegates gives url loading status.
 */
@property (nonatomic, weak) id <JuspaySafeBrowserDelegate>_Nullable jpBrowserDelegate;

/**
 Returns true if user has finished transaction and or has asked to cancel current transaction.
 */
@property (nonatomic) Boolean isControllerAllowedToPop;

/**
 Set true if endUrl needs to be presented to be loaded in JuspaySafeBrowser
 */
@property (nonatomic) Boolean shouldLoadEndURL;

/**
 Set true if payment view controller should not be popped after payment completion
 */
@property (nonatomic) Boolean shouldNotPopAfterPayment;

@property Boolean shouldNotPopOnEndURL;

/**
 Starts the payment process with given browser params as input and triggers the callback when completed.

 @param view View in which payment will start.
 @param params Object of BrowserParams for this payment request.
 @param callback Callback which is triggered when the transaction has reached endURL or cancelled by user.
 */
- (void)startpaymentWithJuspayInView:(UIView* _Nonnull)view withParameters:(BrowserParams* _Nonnull)params callback:(JPBlock _Nullable)callback;

/**
 Starts the payment process with given browser params as input and triggers the callback when completed.
 
 @param view View in which payment will start.
 @param params Object of BrowserParams for this payment request.
 @param callback Callback which is triggered when the transaction has reached endURL or cancelled by user.
 */
- (void)startpaymentWithJuspayInView:(UIView* _Nonnull)view withParameters:(BrowserParams* _Nonnull)params webViewCallback:(JPWBBlock _Nullable)callback;

/**
 Triggers the back button pressed dialogue. If you have a custom back button this needs to be called before calling any other methods.
 */
- (void)backButtonPressed;

/**
 Closes the current session and cancels the ongoing transaction without showing confirmation dialog.
 */
- (void)closeSession;

+ (void)performLogout;

@end
