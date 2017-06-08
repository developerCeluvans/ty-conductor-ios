//
//  LoadingVWC.h
//  taxisya
//
//  Created by NTTak3 on 28/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTaxiProfile.h"
#import "HTTPRequest.h"
#import "QualityService.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TYServiceProgress.h"
#import "LocationManager.h"
#import "Reachability.h"

//#import "ServiceVWC.h"

typedef enum{

    CurrentViewLoading,
    CurrentViewTaxista,
    CurrentViewCalificar

} CurrentView;

@protocol LoadingVWCDelegate;

@interface LoadingVWC : UIViewController <UIAlertViewDelegate, HTTPRequestDelegate,GMSMapViewDelegate,TYServiceProgressDelegate,LocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totUnits;
@property (weak, nonatomic) IBOutlet UILabel *totCharge;
@property (weak, nonatomic) IBOutlet UILabel *totAmount;
@property (nonatomic, assign) id <LoadingVWCDelegate>    delegate;

@property (nonatomic, strong) IBOutlet UIView            *vwLoading;
@property (nonatomic, strong) IBOutlet UIImageView       *imgvwLoading;
@property (nonatomic, strong) IBOutlet UIImageView       *imgvwLoadingBack;
@property (nonatomic, assign) BOOL                       serviceAreFounded;
@property (nonatomic, assign) BOOL                       enableAnimation;
@property (nonatomic, assign) int                        currentImageNumber;
@property (nonatomic, strong) IBOutlet UIImageView       *imgvwRow;

@property (nonatomic, assign) CurrentView                currentView;


@property (nonatomic, strong) IBOutlet UIView            *vwTaxista;
@property (nonatomic, strong) IBOutlet UIImageView       *imgvwPerfil;
@property (nonatomic, strong) IBOutlet UILabel           *lbTaxistaName;
@property (nonatomic, strong) IBOutlet UILabel           *lbAuthorizationCode;


@property (nonatomic, strong) IBOutlet UILabel           *lbTaxistaPlaca;
@property (nonatomic, strong) IBOutlet UILabel           *lbTaxistDescription;
@property (nonatomic, strong) IBOutlet UILabel           *lbTaxistaMarca;
@property (nonatomic, strong) IBOutlet UIButton          *btnTaxistaPhone;
@property (nonatomic, strong) IBOutlet UILabel           *lbMisDatosSon;
@property (nonatomic, strong) IBOutlet UIImageView       *imgvwTaxistaBuzon;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView          *loadingTaxistaImage;
@property (weak, nonatomic) IBOutlet UIButton *qualService;
- (IBAction)clickQualService:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *viewMapBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic, strong) TYTaxiProfile               *currentTaxiProfile;
//@property (nonatomic, strong) QualityService              *qualityServiceVWC;
//@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) UIButton *buttonHideMap;
@property (strong, nonatomic) UIView *viewTest;
@property (strong, nonatomic) UIAlertView *alertCancelService;
@property (strong, nonatomic) NSDictionary *driver;
@property (nonatomic) long statusId;
@property (nonatomic, strong) TYServiceProgress        *tyServiceProgress;
@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic,strong) CLLocation *taxiLocation;
@property (nonatomic) CLLocationCoordinate2D taxiCoordinate;


@property(nonatomic,strong) AReachability* internetReachable;
@property(nonatomic,strong) AReachability* hostReachable;

@property(nonatomic, strong) UIView *viewNetwork;
@property(nonatomic,strong) UIImageView *imageNetworkStatus;
@property(nonatomic,strong) UIImageView *imageRingStatus;
@property(nonatomic,strong) UILabel *networkLabel;
@property(nonatomic) BOOL isWithoutNetwordk;

@property(nonatomic,strong) NSString *mUnits;
@property(nonatomic,strong) NSString *mCharge1;
@property(nonatomic,strong) NSString *mCharge2;
@property(nonatomic,strong) NSString *mCharge3;
@property(nonatomic,strong) NSString *mCharge4;
@property(nonatomic,strong) NSString *mValue;


- (void) taxiarrived: (NSNotification*)aNotification;

- (void)show:(BOOL)show;
- (void)show:(BOOL)show animated:(BOOL)animated;

- (IBAction)onClose:(id)sender;

- (IBAction)taxistaCancelService:(id)sender;
- (IBAction)taxistaSeeMap:(id)sender;
- (IBAction)taxistaCall:(id)sender;

- (void)showTaxistaInfo:(BOOL)show;

- (void)setTaxiPofile:(TYTaxiProfile *)profile;
- (void)operatorCancelService;
-(void) checkNetworkStatus:(NSNotification *)notice;


@end

@protocol LoadingVWCDelegate <NSObject>

- (void)LoadingVWCUsserRequestCancelService;
- (void)LoadingVWCUsserRequestCancelServiceAutomatic;
- (void)LoadingVWCFocusTaxi;
- (void)LoadingVWHaveService:(BOOL)have;
- (void)LoadingVWCRemoveCancelAlert;


@end
