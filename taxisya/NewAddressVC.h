//
//  NewAddressVC.h
//  taxisya
//
//  Created by Leonardo Rodriguez on 10/25/15.
//  Copyright © 2015 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "TYSUsser.h"
#import "TYSTaxi.h"
#import "TYAddress.h"
#import "LocationManager.h"

@protocol NewAddressVCDelegate;

@interface NewAddressVC : UIViewController <UITextFieldDelegate,GMSMapViewDelegate,TYSUsserDelegate,LocationManagerDelegate,TYSTaxiDelegate>

@property (nonatomic, assign) id <NewAddressVCDelegate>    delegate;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextField *addressField;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *commentField;
@property (nonatomic, strong) UIButton *buttonAdd;

@property (nonatomic, strong) UIImageView *pointerMap;
@property (strong, nonatomic) GMSMapView *mapView;

@property (nonatomic, strong) NSString *fullAddress;
@property (nonatomic, strong) NSString *barrioAddress;
@property (nonatomic, strong) NSString *latitudeAddress;
@property (nonatomic, strong) NSString *longitudeAddress;

@property (nonatomic, strong) TYSUsser    *tysUsser;
@property (nonatomic, strong) TYSTaxi     *tysTaxi;
@property (nonatomic, strong) LocationManager *locationManager;



//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)show;
- (IBAction)goBack:(id)sender;

@end

@protocol NewAddressVCDelegate <NSObject>

-(void)newAddressSaved;

@end
