//
//  JuspaySafeBrowerViewController.h
//  JuspaySafeBrowser
//
//  Created by Sachin Sharma on 21/10/16.
//  Copyright © 2016 Juspay Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuspaySafeBrowser.h"
#import "UIViewController+BackButtonHandler.h"

typedef enum{
    Push,
    Present
}PresentationStyle;

@interface JuspaySafeBrowserViewController : UIViewController

@property (nonatomic,strong) BrowserParams * _Nonnull browserParams;
@property (nonatomic,copy) JPBlock _Nonnull callback;
@property (nonatomic,copy) JPWBBlock _Nonnull webCallback;
@property (nonatomic) PresentationStyle presentationStyle;

- (nullable instancetype)initWithPresentationStyle:(PresentationStyle)style params:(BrowserParams* _Nonnull)params callback:(JPBlock _Nonnull)callback;

- (IBAction)closeee:(id _Nonnull)sender;

@end
