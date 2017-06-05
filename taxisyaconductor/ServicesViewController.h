//
//  ServicesViewController.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/4/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"
#import "MapViewController.h"

@import AVFoundation;

@interface ServicesViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,MapViewControllerDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *disableButton;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer *timerSpeak;
@property (nonatomic) CLLocation *location;
@property (nonatomic) int serviceCancelled;
@property (nonatomic) BOOL waitSpeak;
@property (nonatomic) BOOL firstTime;
@property (nonatomic, strong) NSMutableArray *servicesArray;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;


@end
