//
//  OptionsViewController.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/4/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "iCarousel.h"
#import "MapViewController.h"

typedef enum{
    MenuOptionEnable,
    MenuOptionClose,
    MenuOptionHistory,
} MenuOption;

@interface OptionsViewController : UIViewController <iCarouselDataSource, iCarouselDelegate,CLLocationManagerDelegate,MapViewControllerDelegate>

@property (nonatomic, strong) UIImageView            *imageMap;
@property (nonatomic, strong) UIImageView            *imageMask;
@property (nonatomic, strong) UIImageView            *imageLogo;
@property (nonatomic, strong) iCarousel              *options;
@property (nonatomic, strong) NSMutableArray         *arrayButtons;
@property (nonatomic) BOOL repeatAnimations;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) CLLocation *location;
@property (nonatomic) BOOL isLocationEnabled;

@end
