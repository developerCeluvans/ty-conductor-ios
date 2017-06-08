//
//  AppDelegate.h
//  taxisya
//
//  Created by NTTak3 on 21/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPRequest.h"

#define CONFIRM_SERVICE         4  // 2
#define TAXI_ARRIVED            5  // 4
#define TAXI_GO                 6  //
#define DRIVER_FINALIZATION     7  // 5
#define DRIVER_CANCEL_SERVICE   31 // 8
#define SISTEM_CANCEL_SERVICE   34 // 7
#define SISTEM_CLOSE_SESSION    58 //
#define SISTEM_MESSAGE          38 //

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, HTTPRequestDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, strong) NSTimer *validateStatusTimer;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, assign) BOOL isArrived;
@property (nonatomic, strong) NSMutableArray *servicesArray;

- (void)hideKeyBoard;
- (void)validateCancelSolicitudService;
- (void)validateSolicitudService;
- (void)getServiceCurrent;
- (void)cancelTimers;

@end
