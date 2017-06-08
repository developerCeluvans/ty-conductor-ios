//
//  ServiceVWC.h
//  taxisya
//
//  Created by NTTak3 on 21/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressVWC.h"
#import "AddressOldVWC.h"
#import "NewAddressVWC.h"
#import "Register.h"
#import "LoadingVWC.h"
#import "QualityService.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TYUsserProfile.h"
#import "TYTaxiProfile.h"
#import "RequestServiceVWC.h"
#import "TYSTaxi.h"
#import "AddressesVC.h"
#import "LocationManager.h"
#import "HTTPRequest.h"
#import "Reachability.h"

#define STATUS_PENDING                  @"1"
#define STATUS_ASSIGNED                 @"2"
#define STATUS_DRIVER_WAITING           @"3"
#define STATUS_RUNNING                  @"4"
#define STATUS_ENDED                    @"5"
#define STATUS_CANCELED                 @"6"
#define STATUS_CANCELED_FOR_DRIVER      @"7"
#define STATUS_CANCELED_FOR_DRIVER1     @"8"
#define STATUS_CANCELED_FOR_DRIVER2     @"9"

//@class LoadingVWC;

@protocol ServiceVWCDelegate;

@interface ServiceVWC : UIViewController <UIAlertViewDelegate, TYSTaxiDelegate, AddressVWCDelegate, RegisterDelegate, QualityServiceDelegate, GMSMapViewDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, TYSUsserDelegate,LocationManagerDelegate,HTTPRequestDelegate>

@property (nonatomic, assign) id <ServiceVWCDelegate>       delegate;

@property (nonatomic, strong) IBOutlet UIView               *vwHeader;
@property (nonatomic, strong) IBOutlet UIView               *vwAddressContainer;
@property (weak, nonatomic) IBOutlet UIButton               *myAddresses;
@property (nonatomic, strong) AddressVWC                    *addressVWC;
@property (nonatomic, strong) AddressOldVWC                 *addressOldVWC;
@property (nonatomic, strong) AddressesVC                   *addressesVC;

@property (nonatomic, strong) NewAddressVWC                 *addresNewVWC;

@property (nonatomic, strong) IBOutlet UIView               *vwFooter;
@property (nonatomic, strong) IBOutlet UILabel              *lbFooter1;
@property (nonatomic, strong) IBOutlet UILabel              *lbFooter2;
@property (nonatomic, strong) IBOutlet UIView               *mapVWContainer;
@property (nonatomic, strong) IBOutlet UIView               *vwCloseAddress;
@property (nonatomic, strong) IBOutlet UIButton             *btnService;
@property (nonatomic, strong) IBOutlet UIButton             *btnGetService;
@property (nonatomic, strong) Register                      *registerVWC;
@property (nonatomic, strong) LoadingVWC                    *loadingVWC;
@property (nonatomic, strong) QualityService                *qualityServiceVWC;
@property (nonatomic, strong) RequestServiceVWC             *requestServiceVWC;

- (IBAction)btnAddresses:(id)sender;
@property (nonatomic, strong) IBOutlet UIPickerView         *pickerView;
@property (nonatomic, strong) TYSTaxi                       *tysTaxi;
@property (nonatomic, strong) NSString                      *idTaxista;
@property (nonatomic, strong) NSTimer                       *timerPositionTaxi;
@property (nonatomic, assign) BOOL                          areFoundingTaxiPosition;
@property (nonatomic, assign) BOOL                          serviceAreFounded;

@property (nonatomic, strong) CAShapeLayer                  *circleLayer;


//@property (nonatomic, strong) IBOutlet UITextField *fullAddress;
@property (nonatomic, strong) UIView                        *paymentView;
@property (nonatomic, strong) UILabel                       *paymentLabel;
@property (nonatomic, strong) UISegmentedControl            *paymentSelection;
@property (nonatomic, strong) UITextField                   *searchAddress;
@property (nonatomic, strong) UIView                        *ticketView;
@property (nonatomic, strong) UILabel                       *ticketLabel;
@property (nonatomic, strong) UITextField                   *ticketValue;


@property (nonatomic, strong) UIButton                      *buttonRequestService;
@property (nonatomic, strong) UILabel                       *labelButtonRequestService;
@property (nonatomic, strong) UIButton                      *buttonCancelRequestService;
@property (nonatomic, strong) UILabel                       *labelButtonCancelRequestService;
@property (nonatomic, strong) UIButton                      *backMapView;
@property (nonatomic, strong) UIView                        *headerRequestService;

@property (nonatomic, strong) NSString                      *fullAddress;
@property (nonatomic, strong) NSString                      *barrioAddress;
@property (nonatomic, strong) NSString                      *latitudeAddress;
@property (nonatomic, strong) NSString                      *longitudeAddress;



@property (nonatomic, strong) UIImageView                   *pointerMap;
@property (nonatomic, strong) UIView                        *viewMask;

@property (nonatomic, strong) NSMutableArray                *maPicker;
@property (nonatomic, strong) ASIFormDataRequest            *requestTaxiInfo;
@property (nonatomic, strong) NSTimer                       *timerAssignmentTaxi;
//@property (nonatomic, strong) CLLocationManager             *locationManager;
@property (nonatomic, strong) UIAlertView                   *alert;
@property (nonatomic, strong) UIAlertView                   *alertCancelService;
@property (nonatomic) BOOL isAddressFromList;

@property (nonatomic, strong) LocationManager *locationManager;

@property(nonatomic,strong) AReachability* internetReachable;
@property(nonatomic,strong) AReachability* hostReachable;

@property(nonatomic, strong) UIView *viewNetwork;
@property(nonatomic,strong) UIImageView *imageNetworkStatus;
@property(nonatomic,strong) UIImageView *imageRingStatus;
@property(nonatomic,strong) UILabel *networkLabel;
@property(nonatomic) BOOL isWithoutNetwordk;
@property(nonatomic) BOOL isSchedule;
@property(nonatomic) int paymentType;
@property(nonatomic,strong) NSString *cardReference;
@property(nonatomic,strong) NSString *ticket;


- (void)showAnimated;
- (IBAction)hideAddressVWC:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)onAskForService:(id)sender;
-(IBAction) goUserAddress:(id)sender;
- (void)setTaxiProfile:(TYTaxiProfile *)profile;
- (void)operatorCancelServiceWithAlert:(BOOL)alrt;
- (void)operatorCancelForDriverServiceWithAlert:(BOOL)alrt;
- (void)taxiAreWaitinForUsser;
- (void)showLoadingService:(BOOL)show;
-(void) checkNetworkStatus:(NSNotification *)notice;
-(void)createViews;
-(void)confirmServiceCancelled;
-(void)deleteTaxiAccepted;
-(void)deleteTaxiArrived;
-(void)deleteServiceQualified;
-(void)deleteServiceCancelled;
-(void) removeViewsRequestService;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
-(void)changePositionPaymentType:(float) distance;

@end

@protocol ServiceVWCDelegate <NSObject>

- (void)ServiceVWCRequestService:(TYAddress *)address;
- (void)ServiceVWCCancelService;
- (void)ServiceVWCCancelServiceAutomatic;
- (void)ServiceVWQualityOptionPressed:(NSString *)option;
- (void)ServiceVWCUpdateStatusServiceIfHave;
-(void)ServiceAddressSchedule:(NSString *) address lat:(NSString *)lat lng:(NSString *) lng;


@end
