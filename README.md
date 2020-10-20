# Instamojo SDK Integration Documentation 

Table of Contents
=================

   * [Overview](#section-overview)
   * [Payment flow Via SDK](#section-payment-flow-via-sdk)
   * [Sample Application](#section-sample-application)
   * [Generating Access Token](#section-generating-access-token)
   * [What is Transaction ID](#section-what-is-transaction-id)
   * [Installation](#section-installation)
     * [Using Cocapods Recommended](#section-using-cocapods-of code.)
     * [Manually](#section-manually)
     * [Prerequisites](#section-Prerequisites)
   * [Simple Integration](#section-simple-integration)
     * [Initializing SDK](#section-initializing-sdk)
     * [Fetching an Order](#section-fetching-an-order)
         * [Creating the Payment Request](#section-creating-the-payment-request)
         * [Creating the Order](#section-creating-the-order)
         * [Using OrderID in the SDK](#section-using-orderid-in-the-sdk)
     * [Initiating Order](#section-initiating-order)
     * [Displaying Payment Forms](#section-displaying-payment-forms)
     * [Receiving Payment result in the root view controller](#section-receiving-payment-result-in-the-root-view-controller)
   * [Integration with Test Environment](#section-integration-with-test-environment)
   * [Verbose logging](#section-verbose-logging)

## Overview
This SDK allows you to integrate payments via Instamojo into your iOS app. It currently supports following modes of payments:

1. Credit / Debit Cards
2. EMI 
3. Netbanking
4. Wallets
5. UPI

This SDK also comes pre-integrated with Juspay Safe Browser, which makes payments on mobile easier, resulting in faster transaction time and improvement in conversions.

1. Network optimizations: Smart 2G connection handling to reduce page load times.
2. Input & Keyboard Enhancements: Displays right keyboard with password viewing option.
3. Smooth User Experience: Aids the natural flow of users with features like Automatic Focus, Scroll/Zoom, Navigation buttons.

Simple Integration:
1. With Simple Integration, you can use the pre-created SDK's UI to collect payment information from the user.

2. Custom UI Integration:
    The SDK has necessary APIs available to create a custom UI to collect payment information from the user. More on this [here](https://docs.instamojo.com/v1.1/page/ios-sdk-custom-ui).
    #### **Note: Please contact a qualified security assessor to determine your PCI-DSS incidence and liability if you’re implementing a custom interface that collects cardholder information.**

## Payment flow Via SDK
The section describes how the payment flow probably looks like when you integrate with this SDK. Note that, this is just for reference and you are free to make changes to this flow that works well for you.

- When the buyer clicks on the Buy button, your app makes a call to your backend to initiate a transaction in your system.
- Your backend systems create a transaction (uniquely identified by transaction_id). If required, it also obtains an access token from Instamojo servers. It passes back order details (like buyer details, amount, transaction id etc.) and a valid Instamojo’s access token.
- Your iOS app creates a new Order (from the SDK), by passing it order details and access token.
- If the order is valid, the user is shown the payment modes, which will take him via the payment process as per mode selected.
- Once a payment is completed, a callback is called in your iOS app.
- Your iOS app makes a request to your backend servers with the transaction_id.
- Your backend server checks the status of the transaction by making a request to Instamojo’ server. - Your backend server updates the status in the database and passes back the result (successful / failure) to your app.
- Your app shows the success/failure screen based on the result if received from your backend.

## Generating Access Token
A valid access token should be generated on your server using your `Client ID` and `Client Secret`.

Generate CLIENT_ID and CLIENT_SECRET for specific environments from the following links.
 - [Test Environment](https://test.instamojo.com/integrations)
 - [Production Environment](https://www.instamojo.com/integrations)

Related support article: [How Do I Get My Client ID And Client Secret?](https://support.instamojo.com/hc/en-us/articles/212214265-How-do-I-get-my-Client-ID-and-Client-Secret-)

Access token should be generated using CLIENT_ID and CLIENT_SECRET and will be valid for 10 hours after generation. Please check this [documentation (https://docs.instamojo.com/v2/docs/application-based-authentication) on how to generate Access Token using the credentials.

## What is the Transaction ID
Well, the transaction ID is a unique ID for an Order. Using this transaction ID, you can fetch Order status, get order details, and even initiate a refund for the Order attached to that transaction ID.

The transaction ID should be unique for every Order.

## Sample Application 
Yes, we have a Sample app that is integrated with SDK. You can either use it as a base for your project or have a look at the integration in action.
Check out the documentation of the Sample App [here](https://github.com/Instamojo/sample-ios-app).

## Installation
The SDK currently supports iOS Version >= 8.0. 
### Using Cocapods Recommended 
CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects [Link](https://guides.cocoapods.org/using/using-cocoapods.html)

*Step 1* :   Uncomment `use_frameworks!` in your podfile as Instamojo was built using Swift.

*Step 2* : Add "Instamojo" to your podfile. 

For Apps built on `Xcode 10 (Swift 4.2)`
```
pod 'Instamojo', :git => 'https://github.com/Instamojo/ios-sdk.git', :tag => '1.0.16'
```
For Apps built on `Xcode 9.1 (Swift 3.2.2 && Swift 4.0.2)`
```
pod 'Instamojo', :git => 'https://github.com/Instamojo/ios-sdk.git', :tag => '1.0.12'
```
For Apps built on `Xcode 9.0 (Swift 3.2 && Swift 4.0)` 
```
pod 'Instamojo', :git => 'https://github.com/Instamojo/ios-sdk.git', :tag => '1.0.10'
```
For Apps built on `Xcode 8.2 (Swift 3.0.x)`
```
pod 'Instamojo', :git => 'https://github.com/Instamojo/ios-sdk.git',  :tag => '1.0.2'
```
For Apps built on `Xcode 8.3 (Swift 3.1)`
```
pod 'Instamojo', :git => 'https://github.com/Instamojo/ios-sdk.git', :tag => '1.0.3'
```
Run pod install. 

*Step 3* :  Remove `Pods_AppName.framework` (Swift) or  `libPods.AppName.a` (Objective-C)   from Linked Frameworks and Libraries section in Build Phases. 

That's it. [Next](#section-simple-integration)

### Manually 
*Step 1* : Download the latest version of `Instamojo SDK` and `JuspaySafeBrowser.bundle` available [here](https://github.com/Instamojo/ios-sdk)

*Step 2* :  In the project editor, select the target (the application which gets deployed to App store) to which you want to add Instamojo

Instamojo.framework
```
Click Build Phases at the top of the project editor.
Open the Embed Frameworks section
Click the Add button  (+) to add Instamojo.framework.
```
JuspaySafeBrowser Dependency : 
```
Click Build Phases at the top of the project editor.
Open the Copy Bundle Resources section.
Click the Add button (+) to add the JuspaySafeBrowser.bundle.
```

## Prerequisites
### Stripping Unwanted Architectures From Instamojo
Instamojo packs all needed architectures so you can run on all your devices and the iOS Simulator without changing a thing. In practice, however, iTunes Connect doesn’t like us adding unused binary slices. 

Add a Run Script step to your build steps, put it after your step to embed frameworks, set it to use /bin/sh and enter the following script:
```
APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

# This script loops through the frameworks embedded in the application and
# removes unused architectures.
find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
    FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
    FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
    echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"

    EXTRACTED_ARCHS=()

    for ARCH in $ARCHS
    do
        echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
        lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
        EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
    done

    echo "Merging extracted architectures: ${ARCHS}"
    lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
    rm "${EXTRACTED_ARCHS[@]}"

    echo "Replacing original executable with thinned version"
    rm "$FRAMEWORK_EXECUTABLE_PATH"
    mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

done
```
### Build Active Architecture 
```
Build Active Architecture Only = NO
```

### Runpath Search Paths
Make sure Runpath Search Paths in Linking of Build Settings has
```
Runpath Search Paths =  $(inherited) @executable_path/Frameworks
```

### Objective C - Always Embed Swift Standard Libraries 
Instamojo was developed using Swift. If you are building an app that does not use Swift but embeds content such as a framework that does, Xcode will not include these libraries in your app. As a result, your app will crash upon launching.

To workaround this issue, in Build Options set
```
Always Embed Swift Standard Libraries = YES
```
This build setting, which specifies whether a target's product has embedded content with Swift code, tells Xcode to embed Swift standard libraries in your app when set to YES.


## Simple Integration
### Initializing SDK
In AppDelegate import and initialise Instamojo
Swift     
```
@import Instamojo
Instamojo.setup()
```
Objective C
```
@import Instamojo;
[Instamojo setup];
```

### Fetching an Order
This step is for those who are looking for MarketPlace integration. If not, please move on to next [step](#section-initiating-order).

### Creating the Payment Request
Please create a payment request using the [Payment Request API](https://docs.instamojo.com/v2/docs/create-a-payment-request) on your backend.

***Note: Ensure that you send the following redirect URL in the Payment Request payload for SDK to function properly.***
Test - https://test.instamojo.com/integrations/android/redirect/
Production - https://www.instamojo.com/integrations/android/redirect/

Once the payment request is created, collect payment request id from the field `id` from the response.

### Creating the Order
Once the `id` from Payment Request API response is collected, you should create the order for this request using [Create Order API](https://docs.instamojo.com/v2/docs/create-an-order-using-payment-request-id) on your backend.

Once the Order is created, collect the Order ID from the field `order_id` from the response.

### Using OrderID in the SDK
Once the `order_id` is collected, send it back to the app.

On the app, you can fetch the Order by passing the `access_token` and `order_id` to the SDK.
Swift
```
@import Instamjo 

class ViewController: UIViewController, OrderRequestCallBack {
  func fetchOrder(orderID: String, accessToken: String){
       //show spinner
        let request = Request.init(orderID: orderID, accessToken: accessToken,  orderRequestCallBack: self)
        request.execute()
  }

  //protocol function
  func onFinish(order: Order, error: String) {
        if !error.isEmpty {
            DispatchQueue.main.async {
                //hide spinner
                //show the error message
            }
        } else {
            DispatchQueue.main.async {
              //hide spinner
                Instamojo.invokePaymentOptionsView(order : order)
            }
        }
    }
}
```
Objective C
```
ViewContoller.h 
@import Instamojo;
@interface ViewController : UIViewController <OrderRequestCallBack>

ViewController.m
-(void)fetchOrder:(NSString *) orderID accessToken:(NSString *)accessToken{
    //show spinner
    Request *request = [[Request alloc] initWithOrderID:orderID accessToken:accessToken orderRequestCallBack:self];
    [request execute];
}

//protocol function
-(void)onFinishWithOrder:(Order *)order error:(NSString *)error{
    if (error.length != 0){
        dispatch_async(dispatch_get_main_queue(), ^(void){
           //spinner hide
           //show the error message
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //spinner hide
            [Instamojo invokePaymentOptionsViewWithOrder:order];
        });
    }
}
```
Once the order is fetched, please proceed to next [step](#section-displaying-payment-forms).

### Initiating Order
To initiate an Order, the following fields are mandatory.

1. Name of the buyer (Max 100 characters)&nbsp;
2. Email of the buyer (Max 75 characters)&nbsp;
3. Purpose of the transaction (Max 255 characters)&nbsp;
4. Phone number of the buyer &nbsp;
5. Transaction amount (Min of Rs. 9 and limited to 2 decimal points)&nbsp;
6. Access Token &nbsp;
7. Transaction ID (Max 64 characters)&nbsp;

With all the mandatory fields mentioned above, an `Order` object can be created.
Swift
```
let order: Order =  Order.init(authToken : self.accessToken, transactionID : self.transactionID, buyerName : self.buyerName, buyerEmail : self.buyerEmail, self.buyerPhone : self.buyerPhone, amount : self.amount, description : self.orderDescription, webhook : self.webhook)
```
Objective C
```
Order *order = [[Order alloc]initWithAuthToken:self.accessToken transactionID:self.transactionID buyerName:self.name buyerEmail:self.email buyerPhone:self.buyerPhone amount:self.amount description:self.orderDescription webhook:self.webhook];
```


`Order` object must be validated locally before creating Order with Instamojo.
Add the following code snippet to validate the `Order` object.

Swift
```
//Validate the Order
    if !order.isValid().validity {

         // to view all the validations messages
          let errorMessage = order.isValid().error 

           if !order.isValidName().validity {
                let error = order.isValidName().error
           }
          if !order.isValidEmail().validity {
                let error = order.isValidEmail().error
           }
           if !order.isValidAmount().validity {
                let error = order.isValidAmount().error
           }
           if !order.isValidPhone().validity {
                let error = order.isValidPhone().error
           }
           if !order.isValidDescription().validity {
                let error = order.isValidDescription().error
           }
           if !order.isValidTransactionID().validity {
                let error = order.isValidTransactionID().error
           }
           if !order.isValidWebhook().validity {
                let error = order.isValidWebhook().error
           }
     }else {
            //Validation is successful. Proceed
     }
```
Objective c
```
//Validate the Order
if (![order isValid]){
     NSDictionary *nameValidity = [order isValidName];
     NSDictionary *emailValidity = [order isValidEmail];
     NSDictionary *phoneValidity = [order isValidPhone];
     NSDictionary *amountValidity = [order isValidAmount];
     NSDictionary *descriptionValidity = [order isValidDescription];
     NSDictionary *transactionValidity = [order isValidTransactionID];
     NSDictionary *webHookValidity = [order isValidWebhook];

     if (![[nameValidity objectForKey:@"validity"] boolValue]){
         NSString *error = [nameValidity objectForKey:@"error"];
     }
     if (![[emailValidity objectForKey:@"validity"] boolValue]){
         NSString *error = [emailValidity objectForKey:@"error"];
     }
     if (![[phoneValidity objectForKey:@"validity"] boolValue]){
         NSString *error = [phoneValidity objectForKey:@"error"];
     }
    if (![[amountValidity objectForKey:@"validity"] boolValue]){
         NSString *error = [amountValidity objectForKey:@"error"];
     }
     if (![[descriptionValidity objectForKey:@"validity"] boolValue]){
         NSString *error = [descriptionValidity objectForKey:@"error"];
     }
     if (![[transactionValidity objectForKey:@"validity"] boolValue]){
         NSString *error = [transactionValidity objectForKey:@"error"];
     }
     if (![[webHookValidity objectForKey:@"validity"] boolValue]){
         NSString *error = [webHookValidity objectForKey:@"error"];
     }
} else {
     //Validation is successful. Proceed
}
```


Once `Order` is validated. Add the following code snippet to create an order with Instamojo.
Swift
``` 
{
    //Validation is successful. Proceed
    // Good time to show spinner to user
    let request = Request.init(order: order, orderRequestCallBack: self)
    request.execute()
}

//protocol function
 func onFinish(order: Order, error: String) {
        if !error.isEmpty {
            DispatchQueue.main.async {
              //hide spinner
              // show the error message
            }
        } else {
            DispatchQueue.main.async {
                //hide spinner
                Instamojo.invokePaymentOptionsView(order: order)
            }
        }
 }
```
Objective C
``` 
{
    //Validation is successful. Proceed
    // Good time to show spinner to user
   Request *request = [[Request alloc]initWithOrder:order orderRequestCallBack:self];
   [request execute];
}

//protocol function
-(void)onFinishWithOrder:(Order *)order error:(NSString *)error{
    if (error.length != 0){
        dispatch_async(dispatch_get_main_queue(), ^(void){
           //hide spinner
           // show the error message
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //hide spinner
            [Instamojo invokePaymentOptionsViewWithOrder:order];
        });
    }
}
```

### Displaying Payment Forms
This SDK comes by default with payment forms (Cards and Netbanking) that can be used to collect payment details from the buyer.

Add the following code snippet to your application's view controller to use Pre-created UI.
You can call this once the order is created and validated, as per the above step:
Swift 
```
 Instamojo.invokePaymentOptionsView(order: order)
```
Objective C
```
 [Instamojo invokePaymentOptionsViewWithOrder:order];
```

### Receiving Payment result in the root view controller
Add the following code snippet in root view controller.
Swift 
``` 
override func viewDidLoad() {
     addNotificationToRecievePaymentCompletion()
}

func addNotificationToRecievePaymentCompletion(){
     NotificationCenter.default.addObserver(self, selector: #selector(self.paymentCompletionCallBack), name: NSNotification.Name("INSTAMOJO"), object: nil)
}
    
func paymentCompletionCallBack() {
     if UserDefaults.standard.value(forKey: "USER-CANCELLED") != nil {
         //Transaction cancelled by user, back button was pressed
     }
     if UserDefaults.standard.value(forKey: "ON-REDIRECT-URL") != nil {
          // Check the payment status with the transaction_id
     }
     if UserDefaults.standard.value(forKey: "USER-CANCELLED-ON-VERIFY") != nil {
          //Transaction cancelled by user when trying to verify UPI payment
     }
}
```
Objective C
``` 
- (void)viewDidLoad {
     [self addNotificationToRecievePaymentCompletion];
}

- (void)addNotificationToRecievePaymentCompletion {
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentCompletionCallBack:) name:@"INSTAMOJO" object:nil];
}

- (void) paymentCompletionCallBack:(NSNotification *) notification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSObject *userCancelled = [defaults objectForKey:@"USER-CANCELLED"];
    if (userCancelled != nil) {
        //Transaction cancelled by user, back button was pressed
    }
    NSObject *onRedirectURL = [defaults objectForKey:@"ON-REDIRECT-URL"];
    if (onRedirectURL != nil){
      //Check the payment status with the transaction_id
    }
    NSObject *cancelledOnVerify = [defaults objectForKey:@"USER-CANCELLED-ON-VERIFY"];
    if (cancelledOnVerify != nil){
      //Transaction cancelled by user when trying to verify UPI payment
    }
}
```

## Integration with Test Environment
To do the integration in a test environment, add the following code snippet at any point in the code.
Swift
```
Instamojo.setBaseUrl(url: "https://test.instamojo.com/")
```
Objective C
```
[Instamojo setBaseUrlWithUrl:@"https://test.instamojo.com/"];
```
You can remove this line to use production environment, before releasing the app.

## Verbose logging
Detailed logs can very useful during SDK Integration, especially while debugging any issues in integration. To enable verbose logging, add the following code snippet at any point in the code:
Swift
```
Instamojo.enableLog(option: true)
```
Objective C
```
[Instamojo enableLogWithOption:true];
```

Once the application is ready to be pushed to the App Store, simply remove the line of code.

