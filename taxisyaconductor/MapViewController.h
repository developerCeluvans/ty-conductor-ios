//
//  MapViewController.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/6/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"
#import "Service.h"

@protocol MapViewControllerDelegate <NSObject>

@optional
-(void)showToastWhenServiceCancelled:(int)statusId;

@end

@class SendUnitsController;

@interface MapViewController : BaseViewController <UIAlertViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,assign) id <MapViewControllerDelegate> delegate;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *neighborhoodLabel;
@property (strong, nonatomic) UILabel *observationLabel;
@property (strong, nonatomic) UILabel *destinationLabel;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) UIButton *arriveButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *finishButton;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer *timerPosition;

@property (nonatomic) CLLocation *location;

@property (strong, nonatomic) Service *service;
@property (nonatomic) BOOL isRecover;
@property (nonatomic, strong) NSMutableArray *servicesArray;
@property(strong,nonatomic)SendUnitsController *SendUnitsController;

@end
