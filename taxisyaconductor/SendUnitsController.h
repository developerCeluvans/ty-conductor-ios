//
//  SendUnitsController.h
//  taxisyaconductor
//
//  Created by developer on 26/05/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "BaseViewController.h"
#import "CustomIOSAlertView.h"
#import "RegisterViewController.h"
#import "Service.h"

@protocol SendUnitsControllerDelegate <NSObject>


@optional
-(void)showToastWhenServiceCancelled:(int)statusId;
@end

@interface SendUnitsController : BaseViewController <UIAlertViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,assign) id <SendUnitsControllerDelegate> delegate;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UITextField *units;
@property (strong, nonatomic) UIButton *sendUnitsButton;
@property (strong, nonatomic) UIButton *noUnitsButton;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer *timerPosition;
@property (nonatomic) BOOL isRecover;
@property (strong, nonatomic) Service *service;
@property (nonatomic, strong) NSMutableArray *servicesArray;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *location;


-initWithRegister:(BOOL) aRegister;

@end
