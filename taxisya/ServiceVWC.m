//
//  ServiceVWC.m
//  taxisya
//
//  Created by NTTak3 on 21/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "ServiceVWC.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "JSON.h"
#import "AlertView.h"
#import "AppDelegate.h"
#import "AddressesVC.h"
#import "HTTPSyncRequest.h"
#import "NetworkStatusViewController.h"
#import "PaymentVC.h"

#define WS_IS_IPHONE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define WS_IS_IPHONE_5 (WS_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)

@interface ServiceVWC () {
    NSTimer *mRequestServiceTimer;
    int currMinute;
    int currSeconds;
}

@property (nonatomic, strong) GMSMapView                    *mapView;
@property (nonatomic, strong) UIView                        *vwTuto;
@end

@implementation ServiceVWC{

    GMSGeocoder *geocoder_;
    NSString *idTaxis;
    
    BOOL isTicketInput;
    BOOL isTicketValid;

}

@synthesize delegate                    = _delegate;

@synthesize vwHeader                    = _vwHeader;
@synthesize vwAddressContainer          = _vwAddressContainer;
@synthesize addressVWC                   = _addressVWC;
@synthesize addressOldVWC               =_addressOldVWC;
@synthesize addresNewVWC                = _addresNewVWC;
@synthesize addressesVC                = _addressesVC;

@synthesize vwFooter                    = _vwFooter;
@synthesize lbFooter1                   = _lbFooter1;
@synthesize lbFooter2                   = _lbFooter2;
@synthesize mapVWContainer              = _mapVWContainer;
@synthesize mapView                     = _mapView;
@synthesize vwCloseAddress              = _vwCloseAddress;
@synthesize btnService                  = _btnService;
@synthesize btnGetService               = _btnGetService;
@synthesize registerVWC                 = _registerVWC;
@synthesize loadingVWC                  = _loadingVWC;
@synthesize qualityServiceVWC           = _qualityServiceVWC;
@synthesize pickerView                  = _pickerView;
@synthesize maPicker                    = _maPicker;
@synthesize timerAssignmentTaxi         = _timerAssignmentTaxi;
@synthesize circleLayer                 = _circleLayer;

@synthesize tysTaxi                     = _tysTaxi;
@synthesize idTaxista                   = _idTaxista;
@synthesize areFoundingTaxiPosition     = _areFoundingTaxiPosition;
@synthesize serviceAreFounded           = _serviceAreFounded;
@synthesize alertCancelService          = _alertCancelService;
@synthesize isAddressFromList           = _isAddressFromList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    
    _locationManager = [LocationManager sharedInstance];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];

    [self.view setFrame:[[NTUDeviceInfo sharedInstance] getRootFrameForDeviceWithOrientation:UIInterfaceOrientationPortrait]];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showViweQual:) name:@"showViweQual" object:nil];
    
    [self createViews];

    [_btnService setTag:1];
    [_btnGetService setTag:10];

    // create view
    isTicketInput = NO;
    isTicketValid = NO;


    self.navigationController.navigationBar.translucent = NO;

    _pickerView.backgroundColor =  [UIColor whiteColor];

    [self.myAddresses setTitle:NSLocalizedString(@"service_my_addresses",nil) forState:UIControlStateNormal];

    /*
     * Update the address info
     */
    self.searchAddress = [[UITextField alloc] initWithFrame:CGRectMake(4, 47, self.view.bounds.size.width - 8, 48)];
    [self.searchAddress setBackgroundColor:[UIColor whiteColor]];
    self.searchAddress.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gps_n.png"]];
    [self.searchAddress setLeftViewMode: UITextFieldViewModeAlways];
    self.searchAddress.rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_add_n"]];
    [self.searchAddress setRightViewMode: UITextFieldViewModeAlways];
    self.searchAddress.delegate = self;
    self.searchAddress.tag = 1101;
    [self.view addSubview:self.searchAddress];


//    if(!_loadingVWC){
//
//        [_qualityServiceVWC.view removeFromSuperview];
//        _qualityServiceVWC = nil;
//
//        _loadingVWC = [[LoadingVWC alloc] initWithNibName:@"LoadingVWC" bundle:nil];
//
//        _loadingVWC.delegate = self;
//
//        [self.view addSubview:_loadingVWC.view];
//    }
//    [_loadingVWC show:NO];


    // test +

//   self.requestServiceVWC = [[RequestServiceVWC alloc] initWithNibName:@"RequestServiceVWC" bundle:nil];
//   [self.view addSubview:_requestServiceVWC.view];


    // test -

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack:) name:@"push_close_session" object:nil];

    [self.view setBackgroundColor:[UIColor yellowColor]];
    
    self.isWithoutNetwordk = NO;
    
    self.paymentType = 1;
    
    [self readCardReference];
    
    UIBackgroundTaskIdentifier bgTask = 0;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    
}

-(void)readCardReference {
    NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
    if ([idUsu length] >= 1) {
       NSString *cardReference = [[NSUserDefaults standardUserDefaults] objectForKey:USSER_CARD_REFERENCE];
        
        if (cardReference != nil) {
            self.cardReference = cardReference;
            //self.paymentType = 2;
        }
        else {
            self.cardReference = nil;
            //self.paymentType = 1;
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];

    NSLog(@"viewWillAppear  ServiceVWC");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceConfirmed:) name:@"push_taxi_confirm_service" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiArrived:) name:@"push_taxi_arrived" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxicancelservice:) name:@"push_driver_cancel_service" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usercancelservice:) name:@"push_user_cancel_service" object:nil];

    // [self startObservingKeyboard];

    // [self setupInputAccessoryView];
    [self confirmServiceCancelled];
    [self deleteTaxiAccepted];
    [self deleteTaxiArrived];
    [self deleteServiceQualified];
    [self deleteServiceCancelled];

}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    NSLog(@"checkNetworkStatus");
    // called after network status changes
    NetworkStatus internetStatus = [_internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"checkNetworkStatus: The internet is down.");
            //self.internetActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"checkNetworkStatus: The internet is working via WIFI.");
            //self.internetActive = YES;
            [self hideWithoutConnection];

            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"checkNetworkStatus: The internet is working via WWAN.");
            //self.internetActive = YES;
            [self hideWithoutConnection];

            
            break;
        }
    }
    
    NetworkStatus hostStatus = [_hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"checkNetworkStatus: A gateway to the host server is down.");
            //self.hostActive = NO;
            if (!self.isWithoutNetwordk)
               [self showViewWithoutConnection];
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"checkNetworkStatus: A gateway to the host server is working via WIFI.");
            //self.hostActive = YES;
            [self hideWithoutConnection];
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"checkNetworkStatus: A gateway to the host server is working via WWAN.");
            //self.hostActive = YES;
            [self hideWithoutConnection];

            break;
        }
    }
}


-(void)showViewWithoutConnection {

    self.isWithoutNetwordk = YES;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.viewNetwork = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    self.viewNetwork.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:67.0/255 blue:63.0/255 alpha:0.9f];
    //self.viewNetwork.alpha = 0.65;
    
    self.imageNetworkStatus = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2-50, screenHeight/2-50,100, 100)];
    self.imageNetworkStatus.image = [UIImage imageNamed:@"without_network"];
    

    self.imageRingStatus = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2-50, screenHeight/2-50,100, 100)];
    self.imageRingStatus.image = [UIImage imageNamed:@"without_network_status"];

    
    //
    self.networkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageNetworkStatus.frame.origin.y + 110, screenWidth, 24)];
    [self.networkLabel setTextColor:[UIColor whiteColor]];
    [self.networkLabel setText:NSLocalizedString(@"connection_bad",nil)];
    [self.networkLabel setFont:[self.networkLabel.font fontWithSize:18]];
    self.networkLabel.textAlignment = NSTextAlignmentCenter;
    
    NSLog(@"M_PI %f",M_PI);
    
    
    [self animateRing];
    
    
    [self.view addSubview:self.viewNetwork];
    [self.view addSubview:self.imageNetworkStatus];
    [self.view addSubview:self.imageRingStatus];
    [self.view addSubview:self.networkLabel];
    
}

-(void) animateRing {
   
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.imageRingStatus.transform = CGAffineTransformRotate(self.imageRingStatus.transform,M_PI_2);
    } completion:^(BOOL finished) {
        [self animateRing];
    }];
}

- (void)rotateImageView
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.imageRingStatus setTransform:CGAffineTransformRotate(self.imageRingStatus.transform, M_PI_2)];
    }completion:^(BOOL finished){
        if (finished) {
            [self rotateImageView];
        }
    }];
}

-(void)hideWithoutConnection {
    
    self.isWithoutNetwordk = NO;
    
    [self.networkLabel removeFromSuperview];
    [self.imageRingStatus removeFromSuperview];
    [self.imageNetworkStatus removeFromSuperview];
    [self.viewNetwork removeFromSuperview];
    
    self.networkLabel = nil;
    self.imageRingStatus = nil;
    self.imageNetworkStatus = nil;
    self.viewNetwork = nil;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    NSLog(@"viewWillDissappear  ServiceVWC");

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"push_driver_cancel_service" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"push_taxi_arrived" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"push_taxi_confirm_service" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"push_user_cancel_service" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];

    [mRequestServiceTimer invalidate];

    self.serviceAreFounded = NO;

    [self removeViewsRequestService];


    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[UIAlertView class]]) {
            [(UIAlertView *)view dismissWithClickedButtonIndex:[(UIAlertView *)view cancelButtonIndex] animated:YES];
        }
    }

//    [self stopObservingKeyboard];
}

- (void)viewDidAppear:(BOOL)animated {

//    CGRect frameRect = self.fullAddress.frame;
//    frameRect.size.height = 48; // <-- Specify the height you want here.
//    self.fullAddress.frame = frameRect;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    float height = 0.0f;

//    if (WS_IS_IPHONE_5){
//        NSLog(@"======= dimensiones ====== height");
//        height = self.view.bounds.size.height;
//        NSLog(@"= 5 === height %f", height);
//    }
//    else {
//        height = self.view.bounds.size.height - 88.0f;
//        NSLog(@"======= height %f", height);
//    }


    height = self.view.bounds.size.height;
    float heightPointer = 44 + (height / 2) - 41 - 17;

    // agrega puntero para el mapa
    self.pointerMap = [[UIImageView alloc] initWithFrame:
    CGRectMake(self.view.bounds.size.width/2 - 41,heightPointer,81, 81)];
    [self.pointerMap setImage:[UIImage imageNamed:@"pointer"]];
    [self.view addSubview:self.pointerMap];

    

    // boton para pedir el taxi
    self.buttonRequestService = [[UIButton alloc] initWithFrame:CGRectMake(2,height - 65,self.view.bounds.size.width - 6, 65)];
    //[button setImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];
    [self.buttonRequestService setBackgroundImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];
    
    if (self.isSchedule) {
        [self.buttonRequestService setTitle:NSLocalizedString(@"service_button_request_schedule",nil) forState:UIControlStateNormal];
    }
    else {
    [self.buttonRequestService setTitle:NSLocalizedString(@"service_button_request",nil) forState:UIControlStateNormal];
    }

    [self.buttonRequestService addTarget:self action:@selector(actionRequestService) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonRequestService];


    
    // boton para seleccionar el tipo de pago
    int h1 = self.buttonRequestService.frame.origin.y;
    int w1 = self.buttonRequestService.frame.size.width;
    

    self.paymentView = [[UIView alloc] initWithFrame:CGRectMake(12,h1-36,self.view.bounds.size.width - 24,34)];
    self.paymentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.paymentView];
    
    self.paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(14,h1-36,(w1/3)-6,34)];
    self.paymentLabel.text = NSLocalizedString(@"payment_type_label",nil);
    
    [self.view addSubview:self.paymentLabel];
    
    
    NSArray *itemArray = [NSArray arrayWithObjects:
                          NSLocalizedString(@"payment_type_cash",nil),
                          NSLocalizedString(@"payment_type_tc",nil),
                          NSLocalizedString(@"payment_type_ticket",nil),
                          nil];
    self.paymentSelection = [[UISegmentedControl alloc] initWithItems:itemArray];
    
    
    
    // obtiene medio de pago seleccionado con anterioridad

    NSInteger B = [[NSUserDefaults standardUserDefaults] integerForKey:@"payment_default"];

    
    if (B != 0) {
        self.paymentType = B;
    }
    
    
    
    
    self.paymentSelection.frame = CGRectMake(2+(w1/3), h1-36, (w1/3 * 2) -6, 34);
    self.paymentSelection.segmentedControlStyle = UISegmentedControlStylePlain;
    [self.paymentSelection addTarget:self action:@selector(actionSelectPayment:) forControlEvents: UIControlEventValueChanged];
    if (self.paymentType == 1)
        self.paymentSelection.selectedSegmentIndex = 0;
    else if (self.paymentType == 2)
        self.paymentSelection.selectedSegmentIndex = 1;
    else
        self.paymentSelection.selectedSegmentIndex = 2;
    
    
    [self.view addSubview:self.paymentSelection];

    if (self.paymentType == 3) {
        [self changePositionPaymentType:-45.0f];
        [self showTicketView];
    }
    
    
    // button text
//    UILabel *buttonText = [[UILabel alloc] initWithFrame:CGRectMake(4, height - 40, self.view.bounds.size.width - 8, 16)];
//    [buttonText setText:@"Pedir taxi"];
//    [buttonText setTextAlignment:NSTextAlignmentCenter];
//    [buttonText setFont:[UIFont fontWithName:@"Helvetica" size:15]];
//    [buttonText setTextColor:[UIColor whiteColor]];
//    [self.view addSubview:buttonText];

    
    ////////////////////////////////////////////////////
    // check for internet connection
    NSLog(@"viewWillAppear  checkNetworkStatus register notification ");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    _internetReachable = [AReachability reachabilityForInternetConnection];
    [_internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    _hostReachable = [AReachability reachabilityWithHostName:@"www.apple.com"];
    [_hostReachable startNotifier];
    
    // now patiently wait for the notification
    
    ///////////////////////////////////////////////////

}


-(void)actionSelectPayment:(UISegmentedControl *) segment {
    NSLog(@"action %ld",segment.selectedSegmentIndex);
    if (segment.selectedSegmentIndex == 0) {
        // code for the first button
        if (isTicketInput) {
            [self resetViewFrame];
            isTicketInput = NO;
        }

        if (self.paymentType == 3) {
            [self changePositionPaymentType:45.0f];
            [self hideTickerView];
        }
        self.paymentType = 1;
        [self.buttonRequestService setBackgroundImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];            
        self.buttonRequestService.enabled = YES;
    }
    else if (segment.selectedSegmentIndex == 1) {
        if (isTicketInput) {
            [self resetViewFrame];
            isTicketInput = NO;
        }
        if (self.paymentType == 3) {
            [self changePositionPaymentType:45.0f];
            [self hideTickerView];
        }

        [self.buttonRequestService setBackgroundImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];            
        self.buttonRequestService.enabled = YES;
        
        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
        if ([idUsu length] >= 1) {
            //self.paymentType = 2;
            //if (self.cardReference != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Proximamente pagos con tarjeta de crédito",nil)
                                        message:nil
                                        delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"Aceptar",nil)
                                        otherButtonTitles:nil
                                      ];
                alert.tag = -1;
                [alert show];
            //}
            /*else {
                PaymentVC *paymentVC = [[PaymentVC alloc] initWithNibName:@"PaymentVC" bundle:nil];
                paymentVC.delegate = self;
                [self.navigationController pushViewController:paymentVC animated:YES];
            }*/
        }
        else {
            Register *registerVWC = [[Register alloc] initWithNibName:@"Register" bundle:nil];
            registerVWC.delegate = self;
            [self.navigationController pushViewController:registerVWC animated:YES];
        }
        
    }
    else {
        // TODO: Show field to input ticket
        if (self.paymentType != 3) {
           [self changePositionPaymentType:-45.0f];
            
            [self showTicketView];
        }
        self.paymentType = 3; // vale
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.paymentType forKey:@"payment_default"];
    [defaults synchronize];

}


-(void)changePositionPaymentType:(float) distance {
    CGRect r = [self.paymentView frame];
    r.origin.y = r.origin.y + distance;
    [self.paymentView setFrame:r];
    
    r = [self.paymentLabel frame];
    r.origin.y = r.origin.y + distance;
    [self.paymentLabel setFrame:r];
    
    
    r = [self.paymentSelection frame];
    r.origin.y = r.origin.y + distance;
    [self.paymentSelection setFrame:r];
    
}

-(void)showTicketView {
    
    //
    // boton para seleccionar el tipo de pago
    int h1 = self.buttonRequestService.frame.origin.y;
    int w1 = self.buttonRequestService.frame.size.width;
    
    
    self.ticketView = [[UIView alloc] initWithFrame:CGRectMake(12,h1-45,self.view.bounds.size.width - 24,42)];
    self.ticketView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ticketView];
    
    //self.ticketLabel = [[UILabel alloc] initWithFrame:CGRectMake(14,h1-45,(w1/3)-6,42)];
    //self.ticketLabel.text = NSLocalizedString(@"ticket_data",nil);
    
    self.ticketValue = [[UITextField alloc] initWithFrame:CGRectMake(14, h1-45, w1-16, 42)];
   
    [self.ticketValue setBackgroundColor:[UIColor whiteColor]];
    [self.ticketValue setPlaceholder:NSLocalizedString(@"ticket_value",nil)];
    self.ticketValue.delegate = self;
    self.ticketValue.tag = 1102;
    [self.view addSubview:self.ticketValue];
    
    
}

-(void) hideTickerView {
    [self.ticketValue removeFromSuperview];
    
    [self.ticketView removeFromSuperview];
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1102) {
        //[self checkRun:nil];
        NSLog(@"Pulse intro en el campo ticketValue");
        [self.ticketValue endEditing:YES];
        
        [self validateTicket];
        
    }
    return YES;
}

-(void)validateTicket {

    
    [[[HTTPSyncRequest alloc] init] checkTicket:[NSDictionary dictionaryWithObjectsAndKeys: self.ticketValue.text, @"ticket", nil] delegate:self];


}


-(void)cardSelected:(NSString *)card {
    NSLog(@"cardSelected %@",card);
    if (card != nil) {
        self.paymentSelection.selectedSegmentIndex = 1;
        NSLog(@"    paymented selected %@",card);
        
    }
    else {
         self.paymentType = 1;
         self.paymentSelection.selectedSegmentIndex = 0;
         self.cardReference = nil;
    }
}


-(void) actionRequestService {
    NSLog(@"--- actionRequestService ");
    // observa teclado
    // [self startObservingKeyboard];
    // [self setupInputAccessoryView];
    // set focus in UITextField
    // detect si servicio de localización esta activo
    if ([CLLocationManager locationServicesEnabled]  &&  ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) ) {
        self.searchAddress.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.searchAddress becomeFirstResponder];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"service_alert_gps_message",nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"service_alert_timeout_accept",nil)
                                              otherButtonTitles:nil];
        alert.tag = -1;
        [alert show];
    }

//    [self requestServiceWithAddress:self.searchAddress.text];
//    [self.view.layer addSublayer:[self makeCircle]];
}

#pragma marks - Keyboard
-(void)startObservingKeyboard {

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self selector:@selector(notifyThatKeyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];

    [nc addObserver:self selector:@selector(notifyThatKeyboardWillDissappear:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)stopObservingKeyboard {

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

//    [nc removeObserver:self];

    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];

    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];


}

-(void)notifyThatKeyboardWillAppear:(NSNotification *) notification {
    // extraer el UserInfo
    NSDictionary *dict = notification.userInfo;

    // Extraer la duracion de la animacion
    double duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];


    if ([self.searchAddress isFirstResponder]) {
        isTicketInput = NO;

    [UIView animateWithDuration:duration
                          delay:0
                        options:0 animations:^{
                            // subir el mapa

                            // desactivar interaccion del mapa

                            // subir el puntero tambien

                            float height = self.view.bounds.size.height;
                            //float heightPointer = 44 + (height / 2) - 41 - 17;


                            NSLog(@"tamaño del frame height %f",height);

                            NSLog(@"tamaño del map y %f",self.mapView.frame.origin.y);

                            NSLog(@"tamaño del map height %f",self.mapView.frame.size.height);

                            float upperFrame = (height / 4) - 17;



                            self.pointerMap.frame = CGRectMake(
                                                               self.pointerMap.frame.origin.x,
                                                              self.pointerMap.frame.origin.y - upperFrame,
                                                               self.pointerMap.frame.size.width,
                                                               self.pointerMap.frame.size.height);

                            self.mapView.frame = CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y - upperFrame, self.mapView.frame.size.width, self.mapView.frame.size.height);
                            self.mapView.userInteractionEnabled = NO;

                        } completion:nil];

    }
    else {
        NSLog(@"Soy el campo de vale");
        isTicketInput = YES;
        CGSize kbSize = [[dict objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        CGRect r = [self.view frame];
        
        NSLog(@"kbSize %f", kbSize.height);
        NSLog(@"view frame %f %f",r.size.width, r.size.height);
        // Assign new frame to your view
        
    //    [self.view setFrame:CGRectMake(0,-kbSize.height,320,460)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.

        /*
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible.
        // Your app might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        self.scrollView.scrollEnabled = YES;
        if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
            [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
        }
         */
        
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:0 animations:^{
                                // subir el mapa
                                
                                // desactivar interaccion del mapa
                                
                                // subir el puntero tambien
                                
                                float height = self.view.bounds.size.height;
                                //float heightPointer = 44 + (height / 2) - 41 - 17;
                                
                                
                                NSLog(@"tamaño del frame height %f",height);
                                
                                NSLog(@"tamaño del ticket y %f",self.ticketValue.frame.origin.y);
                                
                                NSLog(@"tamaño del ticket height %f",self.ticketValue.frame.size.height);
                                
                                float upperFrame = height - kbSize.height - 45;
                                
                                
                                
                                self.ticketValue.frame = CGRectMake(
                                                                   self.ticketValue.frame.origin.x,
                                                                   upperFrame,
                                                                   self.ticketValue.frame.size.width,
                                                                   self.ticketValue.frame.size.height);
                                
                                
                            } completion:nil];
        
    }


    // Cambiar las propiedades del mapa

}

-(void)notifyThatKeyboardWillDissappear:(NSNotification *) notification {
    // extraer el UserInfo
    NSDictionary *dict = notification.userInfo;

    // Extraer la duracion de la animacion
    double duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    if (isTicketInput) {
        [self resetViewFrame];
        
         int h1 = self.buttonRequestService.frame.origin.y;
        
        self.ticketValue.frame = CGRectMake(
                                            self.ticketValue.frame.origin.x,
                                            h1 - 45,
                                            self.ticketValue.frame.size.width,
                                            self.ticketValue.frame.size.height);
        
        isTicketInput = NO;
    }
    else {
    [UIView animateWithDuration:duration
                          delay:0
                        options:0 animations:^{
                            // subir el mapa

                            // desactivar interaccion del mapa
                            float height = self.view.bounds.size.height;

                            float upperFrame = (height / 4) - 17;

                            // subir el puntero tambien
                            self.pointerMap.frame = CGRectMake(
                                                               self.pointerMap.frame.origin.x,
                                                               self.pointerMap.frame.origin.y + upperFrame,
                                                               self.pointerMap.frame.size.width,
                                                               self.pointerMap.frame.size.height);

                            self.mapView.frame = CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y + upperFrame, self.mapView.frame.size.width, self.mapView.frame.size.height);

                            self.mapView.userInteractionEnabled = YES;

                        } completion:nil];
    }

}


-(void)resetViewFrame {
    CGRect r = [self.view frame];
    NSLog(@"view frame %f %f",r.size.width, r.size.height);
    
    int h = self.view.bounds.size.height;
    
//    [self.view setFrame:CGRectMake(0,0,r.size.width,r.size.height)];
     [self.view setFrame:CGRectMake(0,0,r.size.width,h)];

}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
-(void)setupInputAccessoryView {

    // creamos una barra
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];

    // Añadimos boton pedi
    //UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];

    UIBarButtonItem * taxi = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"service_button_request",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(getTaxi:)];


    [taxi setTitleTextAttributes:
          [NSDictionary dictionaryWithObjectsAndKeys:
               [UIColor redColor], UITextAttributeTextColor,nil]
                                    forState:UIControlStateNormal];
//    [bar setItems:@[done,taxi]];
    [bar setItems:@[taxi]];


    // la asignamos como acceseoryView
    self.searchAddress.inputAccessoryView = bar;

}

-(void)dismissKeyboard:(id) sender {
    [self.view endEditing:YES];
}

-(void) getTaxi:(id)sender {
    [self.view endEditing:YES];
    NSLog(@"Por pedir taxi");
    
    if (self.paymentType == 3) {
        if (!isTicketValid) return;
    }

    [self stopObservingKeyboard];

    self.serviceAreFounded = YES;

    NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
    if ([idUsu length] >= 1) {

         // check si address no finaliza con -
        if ([self correctAddress]) {

            //[_loadingVWC.view removeFromSuperview];
            //_loadingVWC = nil;

            if (self.isSchedule) {
                if (_delegate && [_delegate respondsToSelector:@selector(ServiceAddressSchedule:lat:lng:)]) {

                   NSString *strAddress = self.searchAddress.text;

                    [_delegate ServiceAddressSchedule:strAddress lat:_latitudeAddress lng:_longitudeAddress];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self makeViewServiceRequest];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:1 forKey:@"payment_default"];
                [defaults synchronize];
            }
        }
        else {
            // mostrar alerta para editar dirección
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"address_full_title",nil)
                                                                        message:NSLocalizedString(@"address_description",nil)
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"register_alert_button",nil)
                                                              otherButtonTitles:nil];
             alert.tag = 2500;
             [alert show];

        }

    }
    else {
        //[self showAlertWithMessage:NSLocalizedString(@"service_alert_use_user",nil) tag:0];

        if(!_registerVWC){
            self.registerVWC = [[Register alloc] initWithNibName:@"Register" bundle:nil];
            self.registerVWC.delegate = self;
            [self.view addSubview:_registerVWC.view];
        }
        [self.view bringSubviewToFront:_registerVWC.view];
        [_registerVWC show:YES];
    }

}

-(BOOL)correctAddress {
    // dirección correcta para pedir
    NSLog(@"dirección correcta +");
    // self.searchAddress.text
    NSString *data = self.searchAddress.text;
    if ([data length] < 2) return FALSE;
    if([data hasSuffix:@"-"]) return FALSE;
    return TRUE;
}

-(void)makeViewServiceRequest {

    // tomar screenshot

    // ocultar boton pedir taxi
    //[self performSelectorOnMainThread:@selector(showButton) withObject:nil waitUntilDone:NO];
    //[self performSelectorOnMainThread:@selector(hideButton) withObject:nil waitUntilDone:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.buttonRequestService.hidden = YES; //works
    });

    // crear vista con transparencia
    [self makeMask];

    // add button cancelar
    // boton para pedir el taxi
    float height = self.view.bounds.size.height;

    // header
    self.headerRequestService = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 47)];
    [self.headerRequestService setBackgroundColor:[UIColor whiteColor]];
    [self.viewMask addSubview:self.headerRequestService];

    // UIButton para volver/cancelar
    self.backMapView = [[UIButton alloc] initWithFrame:CGRectMake(0,1,44, 44)];
    [self.backMapView setBackgroundImage:[UIImage imageNamed:@"btn_back_n"] forState:UIControlStateNormal];
    [self.backMapView setBackgroundImage:[UIImage imageNamed:@"btn_back_p"] forState:UIControlStateSelected];
    [self.backMapView addTarget:self action:@selector(actionCancelRequestService) forControlEvents:UIControlEventTouchUpInside];
    [self.viewMask addSubview:self.backMapView];

    // UILabel indicando Buscando

    UILabel *titleHeader = [[UILabel alloc] initWithFrame:CGRectMake(45,1, self.view.frame.size.width-90, 44)];
    [titleHeader setTextColor:[UIColor grayColor]];
    [titleHeader setTextAlignment:NSTextAlignmentCenter];
    [titleHeader setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [titleHeader setText:NSLocalizedString(@"service_searching",nil)];
    [self.viewMask addSubview:titleHeader];


    // mensaje ya falta poco
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0,height - 65 - 36, self.view.frame.size.width, 30)];
    [subtitle setTextColor:[UIColor orangeColor]];
    [subtitle setTextAlignment:NSTextAlignmentCenter];
    [subtitle setFont:[UIFont fontWithName:@"WC Mano Negra Bta" size:21]];
    [subtitle setText:NSLocalizedString(@"service_wait_message",nil)];
    [self.viewMask addSubview:subtitle];

    self.buttonCancelRequestService = [[UIButton alloc] initWithFrame:CGRectMake(2,height - 65 - 6,self.view.bounds.size.width - 6, 65)];
    //[button setImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];
    [self.buttonCancelRequestService setBackgroundImage:[UIImage imageNamed:@"btn_d"] forState:UIControlStateNormal];
    [self.buttonCancelRequestService setTitle:NSLocalizedString(@"service_button_cancelar",nil) forState:UIControlStateNormal];
    [self.buttonCancelRequestService setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];


    [self.buttonCancelRequestService addTarget:self action:@selector(actionCancelRequestService) forControlEvents:UIControlEventTouchUpInside];
    [self.viewMask addSubview:self.buttonCancelRequestService];

    // add text footer
    UILabel *labelFooter = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 13, self.view.frame.size.width, 12)];
    [labelFooter setText:NSLocalizedString(@"service_footer",nil)];
    [labelFooter setTextAlignment:NSTextAlignmentCenter];
    [labelFooter setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [labelFooter setTextColor:[UIColor grayColor]];
    [self.viewMask addSubview:labelFooter];

    [self.view.layer addSublayer:[self makeCircle]];



    // colocar boton cancelar


    // crear circulo animado

    // pedir taxi
    NSLog(@"=============== pedir taxi +");
    [self requestServiceWithAddress:self.searchAddress.text];
    NSLog(@"=============== pedir taxi -");
}

-(void) removeViewsRequestService {

    // headerRequestService
    [self.headerRequestService removeFromSuperview];

    // backMapView
    [self.backMapView removeFromSuperview];

    // viewMask
    [self.viewMask removeFromSuperview];

    // circleLayer
    [self.circleLayer removeFromSuperlayer];

    // 07/12/2016 
    //[self.paymentSelection removeFromSuperview];

    // mostrar button
    dispatch_async(dispatch_get_main_queue(), ^{
        self.buttonRequestService.hidden = NO; //works
        
    });

    self.mapView.userInteractionEnabled = YES;


}


-(void) makeMask {
    // circulo con transparencia alrededor
    int radius = 100;
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(
    //                self.viewMask.bounds.origin.x,
    //                self.viewMask.bounds.origin.y,
    //                self.viewMask.bounds.size.width,
    //                self.viewMask.bounds.size.height) cornerRadius:0];

    self.viewMask = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];



    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(
                                                                            self.self.viewMask.bounds.origin.x,
                                                                            self.self.viewMask.bounds.origin.y,
                                                                            self.self.viewMask.bounds.size.width,
                                                                            self.self.viewMask.bounds.size.height) cornerRadius:0];


    int circleX = self.view.bounds.size.width/2 - 100;
//    int circleY = self.view.bounds.size.height/2 - 100; // 110;
    // verificar
    float height = self.view.bounds.size.height;
//    float heightPointer = 44 + (height / 2) - 41 - 17;
    float heightPointer = 44 + (height / 2) - 17;
    int circleY = heightPointer - 100; // 110;


    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(circleX,circleY,2.0*radius, 2.0*radius) cornerRadius:radius];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];

    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor whiteColor].CGColor;
    fillLayer.opacity = 0.7;
    [self.viewMask.layer addSublayer:fillLayer];

    [self.view addSubview:self.viewMask];

    // draw circle orange
}

-(CAShapeLayer *) makeCircle {

// revisar +
    int radius = 100;
    NSLog(@"makeCircle 1");
    self.circleLayer = [CAShapeLayer layer];
    // Make a circular shape
    self.circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    NSLog(@"makeCircle 2");
    // Center the shape in self.view
    self.circleLayer.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
                                  CGRectGetMidY(self.view.frame)-radius+44 - 17);
    NSLog(@"makeCircle 3");

    // Configure the apperence of the circle
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleLayer.strokeColor = [UIColor orangeColor].CGColor;
    self.circleLayer.lineWidth = 4;

    // Add to parent layer
    //[self.view.layer addSublayer:circle];

    NSLog(@"makeCircle 4");
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 8.0; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 34.0;  // Animate only once..

    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];

    // Experiment with timing to get the appearence to look the way you want
    //drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];


    // Add the animation to the circle
    [self.circleLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];

    return self.circleLayer;



// revisar -




}

-(void)showButton
{
    self.buttonRequestService.hidden = NO;
}

-(void)hideButton
{
    self.buttonRequestService.hidden = YES;
}

-(void) actionCancelRequestService {
    NSLog(@"actionCancelRequestService");
    [self.searchAddress endEditing:YES];

    [self cancelService];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchAddress endEditing:YES];
    [self.ticketValue endEditing:YES];
}


- (void)hiddeTuto
{
    [UIView animateWithDuration:0.4
                     animations:^(void){

                         [_vwTuto setAlpha:0];

                     }
                     completion:^(BOOL f){

                     }];

}

- (void)updateActive {
//    [self performSelector:@selector(didTapMyLocation) withObject:nil afterDelay:1];
    [self didTapMyLocation];

    [_delegate ServiceVWCUpdateStatusServiceIfHave];

}


- (void)dealloc {

    //[self.mapView removeObserver:self forKeyPath:@"myLocation" context:NULL];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)showHeaderShadow:(BOOL)show{

    if(show){

        self.vwHeader.layer.shadowColor = [UIColor grayColor].CGColor;
        self.vwHeader.layer.shadowOffset = CGSizeMake(0, 3);
        self.vwHeader.layer.shadowOpacity = 0.3f;

    }else{

        self.vwHeader.layer.shadowOpacity = 0.0f;

    }

}
- (void) showViweQual: (NSNotification*)aNorification
{
    NSLog(@"showViweQual -----");
    if(!_qualityServiceVWC)
    {

        [_loadingVWC.view removeFromSuperview];
        _loadingVWC = nil;

         _qualityServiceVWC = [[QualityService alloc] initWithNibName:@"QualityService" bundle:nil delegate:self];

        [self.view addSubview: _qualityServiceVWC.view];

    }
    else {
        [_loadingVWC.view removeFromSuperview];
        _loadingVWC = nil;
    }

    [self.view bringSubviewToFront:_qualityServiceVWC.view];

    [_qualityServiceVWC show:YES];
}

- (void)createViews{

    // self.addresVWC = [[AddressVWC alloc] initWithNibName:@"AddressVWC" bundle:nil superView:_vwAddressContainer];
    // self.addresVWC.delegate = self;

    self.addresNewVWC = [[NewAddressVWC alloc] initWithNibName:@"NewAddressVWC" bundle:nil superView:_vwAddressContainer];

    [self.vwAddressContainer addSubview:_addressVWC.view];
    //[self.vwAddressContainer addSubview:_addresNewVWC.view];


    [self.lbFooter1 setFont:UI_FONT_1(15)];
    [self.lbFooter2 setFont:UI_FONT_1(15)];
    [self.lbFooter2 setTextColor:[UIColor darkGrayColor]];

    self.maPicker = [NSMutableArray array];

    NSString  *d1 = @"Calle", *d2 = @"Carrera", *d3 = @"Transversal", *d4 = @"Avenida", *d5 = @"Diagonal";
    [_maPicker addObject:d1];
    [_maPicker addObject:d2];
    [_maPicker addObject:d3];
    [_maPicker addObject:d4];
    [_maPicker addObject:d5];

    [self performSelector:@selector(createMap) withObject:nil afterDelay:0.2];

}


- (void)createMap{

    geocoder_ = [[GMSGeocoder alloc] init];

    double lat = [NSLocalizedString(@"geo_lat",nil) floatValue];
    double lng = [NSLocalizedString(@"geo_lng",nil) floatValue];

    lat = _locationManager.currentLocation.coordinate.latitude;
    lng = _locationManager.currentLocation.coordinate.longitude;
    NSLog(@"createMap %f %f",lat,lng);

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lng zoom:16];

    self.mapView = [GMSMapView mapWithFrame:_mapVWContainer.bounds camera:camera];
//    self.mapView.settings.compassButton = YES;
//    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
//    self.mapView.hidden = YES;
//    self.mapView.selectedMarker.icon = [UIImage imageNamed:@"btn-old-address.png"];


    [self.mapVWContainer addSubview:self.mapView];

    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapView.myLocationEnabled = YES;
    });

    CLLocation *location = _mapView.myLocation;
    if (!location || !CLLocationCoordinate2DIsValid(location.coordinate)) {

    }else{
        [_mapView setCamera:[GMSCameraPosition cameraWithTarget:location.coordinate zoom:12]];
    }

    NSLog(@"createMap");
    // cambia posición del botón de localización
    for (UIView *object in _mapView.subviews) {
        NSLog(@"Por buscar el boton");
        if([[[object class] description] isEqualToString:@"GMSUISettingsView"] )
        {
            for(UIView *view in object.subviews) {
                NSLog(@"Buscando el boton");
                if([[[view class] description] isEqualToString:@"UIButton"] ) {
                    NSLog(@"Encontro el boton");
                    CGRect frame = view.frame;
                    frame.origin.y -= 120;
                    frame.origin.x += 60;
                    view.frame = frame;
                }
            }

        }
    };

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 43, 46)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setImage:[UIImage imageNamed:@"localization-arrow2.png"] forState:UIControlStateNormal];
    [btn setCenter:CGPointMake(_mapVWContainer.frame.size.width - 30, _mapVWContainer.frame.origin.y + 40)];

    [btn addTarget:self action:@selector(didTapMyLocation) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:btn];
}

- (void)activeUserLocation {

    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if(IS_IOS8){
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];

}

- (void)didTapMyLocation {

    [_addressVWC cleanTextFiedls];
    [self.locationManager startUpdatingLocation];

    CLLocation *location = self.locationManager.currentLocation;

    if (!location || !CLLocationCoordinate2DIsValid(location.coordinate)) {
        return;
    }

    NSLog(@"ANTES DEL ANIMATE MAP 1");
    [self animateMapToCoordenate:location];

    CLLocation *loc1 = self.mapView.myLocation;
    if (loc1) {
        [self.mapView animateToLocation:loc1.coordinate];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
-(void)updateFullAddress:(CLLocation *)location {
        GMSReverseGeocodeCallback handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
//        NSLog(@"updateFullAddress handle 1 %@",response);
        if (response && response.firstResult) {
            if(response.results && response.results.count > 2){
                GMSReverseGeocodeResult *item = [response.results objectAtIndex:1];
//                NSLog(@"items: %@",item);

                NSString *neighborhood = @"";

                if (item) neighborhood = [NSString stringWithFormat:@"%@", item.addressLine1];
//                NSLog(@"barrio %@", neighborhood);
                _barrioAddress = neighborhood;

                _latitudeAddress = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
                _longitudeAddress = [NSString stringWithFormat:@"%f",location.coordinate.longitude];

//                NSLog(response.firstResult.addressLine1);
//                NSLog(@"-- %@",response.firstResult.administrativeArea );

                NSString *shortString = response.firstResult.addressLine1;
                if ([shortString containsString:@" a "]) {
                     shortString = [shortString substringToIndex:[shortString rangeOfString:@" a "].location];
                }

                if (!_isAddressFromList) {
                    if ([shortString containsString:@"-"]) {
                        //NSString *addressParser = shortString;
                        // get
                        shortString = [shortString substringToIndex:[shortString rangeOfString:@"-"].location];

                        // spanish +
                        [self.searchAddress setText:[NSString stringWithFormat:@"%@-",shortString]];
                        // spanish -
                    }
                    else {
                         [self.searchAddress setText:shortString];
                    }
                }
                else {
                    _isAddressFromList = NO;
                }
            }else{
                [self.searchAddress setText:[NSString stringWithFormat:@"%@ %@",response.firstResult.addressLine1, response.firstResult.addressLine2] ];
            }
        } else {
            NSLog(@"Could not reverse geocode point (%f,%f): %@",
                  location.coordinate.latitude, location.coordinate.longitude, error);
        }
    };

    if(geocoder_){
        geocoder_ = nil;
    }

    geocoder_ = [[GMSGeocoder alloc] init];

    [geocoder_ reverseGeocodeCoordinate:location.coordinate completionHandler:handler];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)animateMapToCoordenate:(CLLocation *)location{

    GMSReverseGeocodeCallback handler = ^(GMSReverseGeocodeResponse *response,
                                          NSError *error) {
        if (response && response.firstResult) {

            if(response.results && response.results.count > 2){

                GMSReverseGeocodeResult *item = [response.results objectAtIndex:1];

                NSString *neighborhood = @"";

                if (item) neighborhood = [NSString stringWithFormat:@"%@", item.addressLine1];

                NSLog(@"%@",response.firstResult.addressLine1);
                NSLog(@"%@",response.firstResult.addressLine2);
                NSLog(@"barrio %@", neighborhood);

                _barrioAddress = neighborhood;
                _latitudeAddress = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
                _longitudeAddress = [NSString stringWithFormat:@"%f",location.coordinate.longitude];


                NSLog(@"-- %@",response.firstResult.administrativeArea );

                //NSRange range = [response.firstResult.addressLine1 rangeOfString:@","];
                NSString *shortString = response.firstResult.addressLine1;
                NSLog(@"shortString - a - %@",shortString);
                
                if ([shortString containsString:@" a "]) {
                    shortString = [shortString substringToIndex:[shortString rangeOfString:@" a "].location];
                }
                NSLog(@"shortString - b - %@",shortString);
                if ([shortString containsString:@"-"]) {
                    shortString = [shortString substringToIndex:[shortString rangeOfString:@"-"].location];
                    [self.searchAddress setText:[NSString stringWithFormat:@"%@-",shortString]];
                }
                //[self.searchAddress setText:shortString];

            }else{
                [self.searchAddress setText:[NSString stringWithFormat:@"%@ %@",response.firstResult.addressLine1, response.firstResult.addressLine2] ];

                [_addressVWC setAddressFromLocation:response.firstResult.addressLine1 address2:response.firstResult.addressLine2];
            }

        } else {
            NSLog(@"Could not reverse geocode point (%f,%f): %@",
                  location.coordinate.latitude, location.coordinate.longitude, error);
        }
    };


    if(geocoder_){
        geocoder_ = nil;
    }

    geocoder_ = [[GMSGeocoder alloc] init];

    [geocoder_ reverseGeocodeCoordinate:location.coordinate completionHandler:handler];

    if([[NTUDeviceInfo sharedInstance] getQualityMachine] == QMachineLow){

        [_mapView setCamera:[GMSCameraPosition cameraWithTarget:location.coordinate zoom:17]];

        return;
    }

    NSLog(@"CAMERAA AL TAXISTA------------------------------------");
    [_mapView setCamera:[GMSCameraPosition cameraWithTarget:location.coordinate zoom:17]];

    CLLocationCoordinate2D current = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    GMSCameraUpdate *currentCam = [GMSCameraUpdate setTarget:current];
    [_mapView animateWithCameraUpdate:currentCam];


}

- (void)animateMapToCoordenateNonUpdateAddress:(CLLocation *)location {

    if([[NTUDeviceInfo sharedInstance] getQualityMachine] == QMachineLow){

        [_mapView setCamera:[GMSCameraPosition cameraWithTarget:location.coordinate zoom:17]];

        return;

    }
    CLLocationCoordinate2D current = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    GMSCameraUpdate *currentCam = [GMSCameraUpdate setTarget:current];
    [_mapView animateWithCameraUpdate:currentCam];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAnimated{

    [self show:YES];

}

- (void)animates{

    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:2.0f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0 :0 :0 :0]];
    [animation setType:@"rippleEffect"];
    //[_addresVWC.vwFooter.layer addAnimation:animation forKey:NULL];

}

- (void)show:(BOOL)show{

    if (show) {
        self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
        self.view.alpha = 0;
        self.mapVWContainer.alpha = 0;

        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        self.view.alpha = 1;
        self.mapVWContainer.alpha = 1;

        [self didTapMyLocation];
    }else{
        self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
        self.view.alpha = 0;
    }
}

-(void)serviceConfirmed:(NSNotification*)aNorification {
    NSLog(@"serviceConfirmed %@",aNorification);
    [mRequestServiceTimer invalidate];
    NSDictionary *driver =[[aNorification userInfo] objectForKey:@"driver"];
    NSLog(@"TaixsyaUsuarios -    LoadingVWC taxiReset B %@",driver[@"id"]);

    LoadingVWC *loadingVWC = [[LoadingVWC alloc] initWithNibName:@"LoadingVWC" bundle:nil];
    loadingVWC.driver = driver;
    loadingVWC.statusId = 2;
    loadingVWC.delegate = self;
    [self.navigationController pushViewController:loadingVWC animated:YES];
}

-(void)taxiArrived:(NSNotification*)aNorification {
    NSLog(@"taxiArrived %@",aNorification);
    [mRequestServiceTimer invalidate];
    NSDictionary *driver =[[aNorification userInfo] objectForKey:@"driver"];
    NSLog(@"TaixsyaUsuarios -    LoadingVWC taxiReset B %@",driver[@"id"]);

    LoadingVWC *loadingVWC = [[LoadingVWC alloc] initWithNibName:@"LoadingVWC" bundle:nil];
    loadingVWC.driver = driver;
    loadingVWC.statusId = 4;
    loadingVWC.delegate = self;
    [self.navigationController pushViewController:loadingVWC animated:YES];
}

- (IBAction)goBack:(id)sender{

    //[self show:NO];
    if (self.isSchedule) {
        if (_delegate && [_delegate respondsToSelector:@selector(ServiceAddressSchedule:lat:lng:)]) {
             NSString *strAddress = self.searchAddress.text;
            [_delegate ServiceAddressSchedule:strAddress lat:_latitudeAddress lng:_longitudeAddress];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction) goUserAddress:(id)sender {
    NSLog(@"goUserAddress ");

    NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
    if ([idUsu length] >= 1) {
        AddressesVC *addressesVC = [[AddressesVC alloc] initWithNibName:@"AddressesVC" bundle:nil];
        addressesVC.delegate = self;
        [self.navigationController pushViewController:addressesVC animated:YES];
    }
    else {
        Register *registerVWC = [[Register alloc] initWithNibName:@"Register" bundle:nil];
        [self.navigationController pushViewController:registerVWC animated:YES];
    }

}


- (IBAction)onAskForService:(id)sender{

    if([_btnGetService tag] == 0) {
        NSLog(@"onAskForService tag == 0");
        [self showLoadingService:NO];
        [self startTimerAssigmentTaxi:NO];
        self.vwAddressContainer.hidden  = NO;

    }else{

        if([TYFormatter formatterValidateInternetConnection]) {

            if(![TYUsserProfile IsUsserRegistred]) {

                if(!_registerVWC) {

                    self.registerVWC = [[Register alloc] initWithNibName:@"Register" bundle:nil];
                    self.registerVWC.delegate = self;
                    [self.view addSubview:_registerVWC.view];

                }

                [self.view bringSubviewToFront:_registerVWC.view];
                [_registerVWC show:YES];

            }else{
                NSLog(@"=====================================================");
                CLLocation *loc = _mapView.myLocation;
                float latitude  = loc.coordinate.latitude;
                float longitude = loc.coordinate.longitude;
                NSLog(@"    lat = %@", [NSString stringWithFormat:@"%f", latitude]);
                NSLog(@"    lng = %@", [NSString stringWithFormat:@"%f", longitude] );
                NSLog(@"=====================================================");

                if ([_addressVWC currentAddressAreValid]){

                    CLLocation *location = _mapView.myLocation;

                    if (!location || !CLLocationCoordinate2DIsValid(location.coordinate)){

                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"service_alert_gps_message",nil)
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"service_alert_timeout_accept",nil)
                                                              otherButtonTitles:nil];

                        alert.tag = -1;

                        [alert show];

                        return;
                    }

                    float latitude  = location.coordinate.latitude;

                    float longitude = location.coordinate.longitude;

                    _addressVWC.tyAddress.latitude  = [NSString stringWithFormat:@"%f", latitude];

                    _addressVWC.tyAddress.longitude = [NSString stringWithFormat:@"%f", longitude];

                    [_delegate ServiceVWCRequestService:_addressVWC.tyAddress];

                    [self showLoadingService:YES];

                }else{

                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"service_alert_address",nil)
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"service_alert_timeout_accept",nil)
                                                          otherButtonTitles:nil];

                    alert.tag = 100;

                    [alert show];
                }
            }
        }else{

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"service_alert_title_connection",nil)
                                                            message:NSLocalizedString(@"service_alert_check_message",nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"service_alert_timeout_accept",nil)
                                                  otherButtonTitles:nil];

            [alert show];

        }
    }
}

- (void)getTaxiPosition {

    if (_requestTaxiInfo) {
        [_requestTaxiInfo clearDelegatesAndCancel];

        self.requestTaxiInfo = nil;
    }
    NSString *idTaxista =   idTaxis;

    NSString *url = [URL_SERVICE_DRIVER_POSTION stringByReplacingOccurrencesOfString:@"{id_user}"
                                                   withString:idTaxista];
    NSLog(@"Direccion del tax %@", url);

    self.requestTaxiInfo = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url] ];
    [_requestTaxiInfo setRequestMethod:@"POST"];
    _requestTaxiInfo.delegate = self;

    [_requestTaxiInfo setDidFinishSelector:@selector(requestTaxiInfoFinishedPosition:)];
    [_requestTaxiInfo setDidFailSelector:@selector(requestTaxiFail:)];
    [_requestTaxiInfo startAsynchronous];

}

- (void)startTimerAssigmentTaxi:(BOOL)start{

    if (start == YES) {
            if(self.timerAssignmentTaxi){

                [self.timerAssignmentTaxi invalidate];

                self.timerAssignmentTaxi = nil;

            }
            self.timerAssignmentTaxi = [NSTimer timerWithTimeInterval:10
                                                               target:self
                                                             selector:@selector(getTaxiPosition)
                                                             userInfo:nil
                                                              repeats:YES];

            self.vwAddressContainer.hidden = YES;

            [[NSRunLoop currentRunLoop] addTimer:self.timerAssignmentTaxi forMode:NSDefaultRunLoopMode];

    }else{

        @try {

            [self.timerAssignmentTaxi invalidate];

            self.timerAssignmentTaxi = nil;

        }@catch (NSException *exception){

            NSLog(@"%@",exception);

        }@finally {

        }

        self.vwAddressContainer.hidden = NO;

    }

}

- (void)requestTaxiInfoFinishedPosition:(ASIHTTPRequest *)request{

    NSString *response = request.responseString;
    if (response.length) {

        NSMutableDictionary *dic = [response JSONValue];

        NSString *lat =  [[dic objectForKey:@"driver"] objectForKey:@"lat"];

        NSString *lng =  [[dic objectForKey:@"driver"] objectForKey:@"lng"];

        _loadingVWC.currentTaxiProfile.latitude = [lat floatValue];

        _loadingVWC.currentTaxiProfile.longitude =  [lng floatValue];

        [_mapView clear];

        GMSMarker *melbourneMarker = [[GMSMarker alloc] init];
        melbourneMarker.title = @"Taxi!";
        melbourneMarker.icon = [UIImage imageNamed:@"taxi"];
        melbourneMarker.position = CLLocationCoordinate2DMake([lat floatValue], [lng floatValue]);
        melbourneMarker.map = _mapView;

        [self LoadingVWCFocusTaxi];

    }else{

        [self requestTaxiFail:nil];

    }

}

- (void)requestTaxiFail:(ASIHTTPRequest *)request{

    NSLog(@"%@",request);

}

static BOOL isShowedTaxiProfileOnce = NO;

- (void)setTaxiProfile:(TYTaxiProfile *)profile{
     NSLog(@"TaixsyaUsuarios -    ServiceVWM setTaxiProfile %@", profile);

    if(isShowedTaxiProfileOnce == NO){

        [self showLoadingService:YES animated:NO];

        isShowedTaxiProfileOnce = YES;

    }

    [_mapView clear];

    GMSMarker *melbourneMarker = [[GMSMarker alloc] init];
    melbourneMarker.title = @"Taxi!";
    melbourneMarker.icon = [UIImage imageNamed:@"taxi"];
    melbourneMarker.position = CLLocationCoordinate2DMake(profile.latitude, profile.longitude);
    melbourneMarker.map = _mapView;

    idTaxis = profile.idService;

    [_loadingVWC setTaxiPofile:profile];

    [(AppDelegate *)[[UIApplication sharedApplication] delegate] validateCancelSolicitudService];

}

- (void)operatorCancelForDriverServiceWithAlert:(BOOL)alrt
{
    if (alrt) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"service_alert_timeout_title",nil)
                                                        message:NSLocalizedString(@"service_alert_driver_cancel",nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"service_alert_timeout_accept",nil)
                                              otherButtonTitles:nil];
        alert.tag = 102;

        [alert show];
    }

    [_mapView clear];
    [_addressVWC cleanTextFiedls];
    [_loadingVWC operatorCancelService];

}

- (void)operatorCancelServiceWithAlert:(BOOL)alrt {

    if(alrt){

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"service_alert_timeout_title",nil)
                                                        message:NSLocalizedString(@"service_alert_timeout_message",nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"service_alert_timeout_accept",nil)
                                              otherButtonTitles:nil];

        //alert.tag = 101;
        alert.tag = -1;

        [alert show];

    }

    [_mapView clear];
    [_addressVWC cleanTextFiedls];
    [_loadingVWC operatorCancelService];

}

- (void)taxiAreWaitinForUsser{

    if(self.alert == nil){
        NSLog(@"taxiAreWaitinForUsser:  El taxi ha llegado");
    }
}

- (void)showLoadingService:(BOOL)show{

    [self removeViewsRequestService];

    [self showLoadingService:show animated:YES];

}

- (void)showLoadingService:(BOOL)show animated:(BOOL)animated{

     // remove show
    [self removeViewsRequestService];

    [_alertCancelService dismissWithClickedButtonIndex:0 animated:YES];

    if(show){
        NSLog(@"ENTRA AL SHOW EN SERVICEVWC----------------------");
        if(!_loadingVWC)
        {
            [_qualityServiceVWC.view removeFromSuperview];

            _loadingVWC = [[LoadingVWC alloc] initWithNibName:@"LoadingVWC" bundle:nil];

            _loadingVWC.delegate = self;

            [self.view addSubview:_loadingVWC.view];

        }

        // set profile
        [self.view bringSubviewToFront:_loadingVWC.view];

        [_loadingVWC show:YES animated:animated];

    }else{
        NSLog(@"NO ENTRA AL SHOW EN SERVICEVWC----------------------");
        [_loadingVWC show:NO animated:animated];

    }

}


static BOOL firstLocationUpdate_ = NO;

#pragma mark -
#pragma mark - MapsDelegate
#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];

    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:15];

    }
}


- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{

    return nil;

}


#pragma mark - AddressVWCDelegate

- (IBAction)hideAddressVWC:(id)sender{

    [_addressVWC showOldAddress:nil];

}

- (void)AddressVWCIsDown:(BOOL)down{

    if (down) {
        [self.vwCloseAddress setHidden:NO];

        [UIView animateWithDuration:0.2
                         animations:^(void){
                             [_vwCloseAddress setAlpha:0.2];
                         }];
    }else{

        [UIView animateWithDuration:0.2
                         animations:^(void){
                             [_vwCloseAddress setAlpha:0];
                         }
                         completion:^(BOOL f){
                             [self.vwCloseAddress setHidden:YES];
                         }];
    }

}

- (void)AddressVWCNeedPickerAddress1{

    [self showPickerView:YES];

}

- (void)showPickerView:(BOOL)show{

    if (show) {
        [self.view bringSubviewToFront:_pickerView];

        _pickerView.hidden = NO;

        [_pickerView setTransform:CGAffineTransformMakeTranslation(0, _pickerView.frame.size.height)];

        [UIView animateWithDuration:0.3
                         animations:^(void){
                             [_pickerView setTransform:CGAffineTransformMakeTranslation(0, 0)];
                         }
                         completion:^(BOOL f){

                         }];

    }else{

        [UIView animateWithDuration:0.3
                         animations:^(void){
                             [_pickerView setTransform:CGAffineTransformMakeTranslation(0, _pickerView.frame.size.height)];
                         }
                         completion:^(BOOL f){

                         }];

    }
}

- (void)AddressVWCNeedAuth{

    if(!_registerVWC){

        self.registerVWC = [[Register alloc] initWithNibName:@"Register" bundle:nil];
        self.registerVWC.delegate = self;
        [self.view addSubview:_registerVWC.view];

    }

    [self.view bringSubviewToFront:_registerVWC.view];
    [_registerVWC show:YES];

}

#pragma mark -
#pragma mark - RegisterDelegateVWC

- (void)RegisterVWCLoginsuccesfull:(BOOL)op{
    if (op) {
        [self onAskForService:nil];

        [self.registerVWC.view removeFromSuperview];
        self.registerVWC = nil;
    }else{

    }
}

#pragma mark -
#pragma mark - QualityServiceDelegate

- (void)QualityServiceNeedRemove{

    [_qualityServiceVWC.view removeFromSuperview];

    self.qualityServiceVWC = nil;

}

- (void)QualityServiceTypePressed:(NSString *)type{
    [_delegate ServiceVWQualityOptionPressed:type];

    [_mapView clear];

    [_addressVWC cleanTextFiedls];

    [_loadingVWC operatorCancelService];

}

#pragma mark -
#pragma mark - LoadingService
- (void)LoadingVWCUsserRequestCancelService{
    NSLog(@"TaixsyaUsuarios -    LoadingVWCUsserRequestCancelService");
    [_mapView clear];
    [_delegate ServiceVWCCancelService];
}

- (void)LoadingVWCUsserRequestCancelServiceAutomatic {
    NSLog(@"TaixsyaUsuarios -    LoadingVWCUsserRequestCancelServiceAutomatic");
    [_mapView clear];
    [_delegate ServiceVWCCancelServiceAutomatic];
}

- (void)LoadingVWCFocusTaxi {

    CLLocation *  location = [[CLLocation alloc] initWithLatitude:_loadingVWC.currentTaxiProfile.latitude longitude:_loadingVWC.currentTaxiProfile.longitude];
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:4.7763594 longitude:-74.1562937];

    NSLog(@"UBICA AL TAXISTAAAA-------------------------------------------");

    [self animateMapToCoordenateNonUpdateAddress:location];

}

- (void)LoadingVWHaveService:(BOOL)have{
    if (have) {
        NSLog(@"ENTRA AL HAVE EN SERVICEVW");
        [_btnGetService setImage:[UIImage imageNamed:@"btn-taxista-encontrado.png"] forState:UIControlStateNormal];
        [_btnGetService setImage:[UIImage imageNamed:@"btn-taxista-encontrado.png"] forState:UIControlStateHighlighted];
        [_btnGetService setTag:0];

        [self startTimerAssigmentTaxi:YES];
    } else {
        NSLog(@"RECHAZA AL HAVE EN SERVICEVW");
        [_btnGetService setImage:[UIImage imageNamed:@"make-service-over.png"] forState:UIControlStateNormal];
        [_btnGetService setImage:[UIImage imageNamed:@"make-service.png"] forState:UIControlStateHighlighted];
        [_btnGetService setTag:10];

        [self startTimerAssigmentTaxi:NO];
    }
}

#pragma mark -
#pragma mark - UIALertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    long tag = alertView.tag;

    if (tag == 100) {//Ingresa todos los campos de tu direccion
        [self hideAddressVWC:nil];
    } else if (tag == 101) { // EL Operador cancelo el servicio reintentar
        if (buttonIndex == 1) {
            [self onAskForService:nil];
        }
    } else if (tag == 102) {
        self.alert = nil;

//        [[[HTTPSyncRequest alloc] init] cancelService:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [TYUsserProfile UsserInfoForKey:USSER_ID], @"user_id",
//                                                           nil] delegate:self];
        // validar
        [self removeViewsRequestService];
    }
    else if (tag == 105) {
        self.alert = nil;
        // validar
        [self removeViewsRequestService];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        for (UIView *view in window.subviews) {
            if ([view isKindOfClass:[UIAlertView class]]) {
                [(UIAlertView *)view dismissWithClickedButtonIndex:[(UIAlertView *)view cancelButtonIndex] animated:YES];
            }
        }
    }
    else if (tag == 1000) {
        if (buttonIndex != 0){
            //[_delegate LoadingVWCUsserRequestCancelService];
            NSLog(@"TaixsyaUsuarios -    alertView cancelService");

            [mRequestServiceTimer invalidate];

//            [_delegate ServiceVWCCancelService];

            self.serviceAreFounded = NO;

//            [self removeViewsRequestService];


            [[[HTTPSyncRequest alloc] init] cancelService:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [TYUsserProfile UsserInfoForKey:USSER_ID], @"user_id",
                                                           nil] delegate:self];

        }
    }
    else if (tag == -1) {
        [self removeViewsRequestService];
    }

}

- (void) showViewQual
{
    if(!self.qualityServiceVWC)
    {

        self.qualityServiceVWC = [[QualityService alloc] initWithNibName:@"QualityService" bundle:nil delegate:self];
        [self.view addSubview: _qualityServiceVWC.view];

    }

    [self.view bringSubviewToFront:_qualityServiceVWC.view];

    [_qualityServiceVWC show:YES];

}


#pragma mark -
#pragma mark - UIPickerViewDelegate-source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _maPicker.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return  [_maPicker objectAtIndex:row];
}

// Set the width of the component inside the picker
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300;
}

// Item picked
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    [self showPickerView:NO];

    [_addressVWC setAddressFromPicker:[_maPicker objectAtIndex:row]];

}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error en la Location %@", error.userInfo);
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TaxisYa necesita su ubicación actual" message:@"Con el fin de ofrecer un mejor servicio, TaxisYA requiere la información de ubicación actual." delegate:nil cancelButtonTitle:@"Entendido" otherButtonTitles:nil];
//    [alertView show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    NSLog(@"ANTES DEL ANIMATE MAP 2");
//    [self animateMapToCoordenate:manager.location];
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    NSLog(@"Error Deferred en la Location %@", error.userInfo);
}

#pragma mark - Maps
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
//    [self clearAllTapMarker];
//    [self.fullAddress setText:@""];
}


- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    NSLog(@"Latitude %f %f ", position.target.latitude, position.target.longitude);

    CLLocation *location = [[CLLocation alloc] initWithLatitude:position.target.latitude longitude:position.target.longitude];

    [self updateFullAddress:location];
}

- (void)clearAllTapMarker {
    [self.mapView clear];
}

#pragma mark - Address
- (NSString *)getCurrentAddress:(NSString *)googleAddress {
    NSMutableString *newString = [[NSMutableString alloc] init];
    for (int i = 1; i <= googleAddress.length; i++) {

        if(!([[googleAddress substringWithRange:NSMakeRange(i - 1, 1)] isEqualToString:@"-"] || [[googleAddress substringWithRange:NSMakeRange(i - 1, 1)] isEqualToString:@","])){
            [newString appendString:[googleAddress substringWithRange:NSMakeRange(i - 1, 1)]];
        }else{
            break;
        }
    }
    return newString;
}

#pragma mark - Request service
- (void)requestServiceWithAddress:(NSString *)address{

    if(address){

        [self startRequestServiceTimer];

        [self initServiceIfNeeded];

        
        /*
        [_tysTaxi requestTaxiType2:TYSTaxiTypeRequestService
                            object:address
                            barrio:_barrioAddress
                           latitud:_latitudeAddress
                          longitud:_longitudeAddress];
*/
         NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:USSER_EMAIL];
        NSLog(@"user_email = %@",email);
        
        NSString *card = [NSString stringWithFormat:@"%@", (self.paymentType >1) ? self.cardReference : @"0"];
        NSString *ticket = [NSString stringWithFormat:@"%@", (self.paymentType == 3) ? self.ticket : @"0"];

        
        [_tysTaxi requestTaxiType3:TYSTaxiTypeRequestService
                            object:address
                            barrio:_barrioAddress
                           latitud:_latitudeAddress
                          longitud:_longitudeAddress
                           payType:self.paymentType
                      payReference:@"0"
                             email:email
                     cardReference:card
                            ticket:ticket];
        
    }

}

-(void)startRequestServiceTimer {
    NSLog(@"startRequestServiceTimer +");
    currMinute=1;
    currSeconds=30;

     mRequestServiceTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1) {
            NSLog(@"    mRequestServiceTimer %02i:%02i",currMinute,currSeconds);
        }
    }
    else
    {
        [mRequestServiceTimer invalidate];

        [self operatorCancelServiceWithAlert:YES];

        [_delegate ServiceVWCCancelService];

        self.serviceAreFounded = NO;

        [self removeViewsRequestService];

        NSLog(@"detect si app is in background +");

        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if (state == UIApplicationStateBackground) {
           NSLog(@"detect si app is in background -");
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:7];
            notification.alertBody = NSLocalizedString(@"service_alert_timeout_message",nil);
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.soundName = UILocalNotificationDefaultSoundName;
            notification.applicationIconBadgeNumber = 10;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }

    }
}


- (void)initServiceIfNeeded
{

    if(!_tysTaxi)
    {

        self.tysTaxi = [[TYSTaxi alloc] initwithDelegate:self];

    }

}

#pragma mark -
#pragma mark - ServicesDelegate

- (void)TYSTaxiType:(TYSTaxiType)type response:(NSString *)response status:(ServiceStatus)status{

    //NSLog(@" RESPUESTA :: %i %@", type, response);
    NSLog(@"TaixsyaUsuarios -    TYSTaxiType:response:status %u ", type);


    if(type == TYSTaxiTypeRequestService)
    {

        if(status == ServiceStatusOk)
        {

            NSMutableDictionary *values = [response JSONValue];

            if(values)
            {

                [self makeLogicRequestService:values];

            }else{

                [self clearservicepending];

//                [self sendDelegateFailWithRequestType:type];
                if(type == TYSTaxiTypeRequestService) {

                    [self operatorCancelServiceWithAlert:NO];

                }else{

                }
                // verificar si no esta logueado
                NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
                if ([idUsu length] >= 1) {
                   [self showAlertWithMessage:NSLocalizedString(@"service_alert_use_user",nil) tag:0];
                }
                else {
                    [self showAlertWithMessage:NSLocalizedString(@"service_alert_check_message",nil) tag:0];
                }
                [self removeViewsRequestService];
            }
        } else{

            //[self sendDelegateFailWithRequestType:type];
            if(type == TYSTaxiTypeRequestService)
            {

                [self operatorCancelServiceWithAlert:NO];

            }else{

            }
            [self showAlertWithMessage:@"Verifica tu conexión a internet" tag:0];
        }
    }else if (type == TYSTaxiTypeServiceStatus){
        if (status == ServiceStatusOk) {
            NSMutableDictionary *dictionary = [response JSONValue];
            if(dictionary){
                [self makeLogicServiceStatusWithDictionary:dictionary];
            }
        } else {


        }

    }else if (type == TYSTaxiTypeTaxiInfo) {
        NSLog(@"TysTaxiType = TYSTaxiTypeTaxiInfo status = %u", status);
        NSLog(@"TaixsyaUsuarios -    TYSTaxiTypeTaxiInfo status");

        if (status == ServiceStatusOk) {

            NSMutableDictionary *dic = [response JSONValue];
            NSLog(@"TaixsyaUsuarios -    TYSTaxiTypeTaxiInfo %@ ", dic);
            if (dic) {

                [self makeLogigTaxiInfoWithDictionary:dic];
            }
        }
    }
    else if(type ==  TYSTaxiTypeCancelService) {
        if(status == ServiceStatusOk) {

            NSMutableDictionary *dic = [response JSONValue];
            if (dic) {
                [self makelogicCancelService:dic];
            }
        }else{

            UIAlertView *alert =

            [[UIAlertView alloc] initWithTitle:@"Importante"
                                       message:@"El servicio no pudo ser cancelado."
                                      delegate:self
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [alert show];
        }
    }

}

-(void)TYSUsserType:(TYSUsserType)type response:(NSString *)response status:(ServiceStatus)status {

}


- (void)makelogicCancelService:(NSMutableDictionary *) dictionary
{
    NSLog(@"%s \n %@", __PRETTY_FUNCTION__, [dictionary description]);

}

- (void)makeLogigTaxiInfoWithDictionary:(NSMutableDictionary *)dictionary{

    NSLog(@"%s \n %@", __PRETTY_FUNCTION__, [dictionary description]);

    NSLog(@"TaixsyaUsuarios -    ServiceVWC makeLogigTaxiInfoWithDictionary %@ ", dictionary );


    NSString *name      =       [dictionary objectForKey:@"name"];
    NSString *lastName  =       [dictionary objectForKey:@"lastname"];
    NSString *placa     =       [dictionary objectForKey:@"placa"];
    NSString *latitude  =       [dictionary objectForKey:@"crt_lat"];
    NSString *longitude =       [dictionary objectForKey:@"crt_lng"];
    NSString *photo =           [dictionary objectForKey:@"picture"];
    NSString *cellphone =       [dictionary objectForKey:@"cellphone"];

    _idTaxista          =       [dictionary objectForKey:@"id"];

    float f_latitude = 0.0f;
    float f_longitude = 0.0f;

    @try {
        f_latitude = [latitude floatValue];
        f_longitude = [longitude floatValue];
    }
    @catch (NSException *exception) {
        f_latitude = 0;
        f_longitude = 0;
    }
    NSLog(@"%f, %f", f_latitude, f_longitude);
    NSMutableDictionary *carDic = [dictionary objectForKey:@"car"];

    NSString *brand         = @"";
    NSString *model         = @"";

    if (carDic) {

        brand = [carDic objectForKey:@"car_brand"];
        model = [carDic objectForKey:@"model"];

    }

    TYTaxiProfile *profile = [[TYTaxiProfile alloc] init];
    profile.name = name;
    profile.lastName = lastName;
    profile.placa = placa;
    profile.latitude = f_latitude;
    profile.longitude = f_longitude;
    profile.urlImage = photo;
    profile.idService = _idTaxista;
    profile.phone = cellphone;
    profile.brand = brand;
    profile.model = model;

    NSLog(@"IDDDDDDD %@",_idTaxista);

    if(profile) {

        //[_delegate TYServiceProgressUpdateTaxiInfo:profile];
        [self setTaxiProfile:profile];

    }

}

- (void)makeLogicServiceStatusWithDictionary:(NSMutableDictionary *)dictionary{

    NSString *status = [dictionary objectForKey:@"status_id"];

    NSLog(@" ESTADO DEL SERVICIO %@",status);

    if([status isEqualToString:STATUS_ASSIGNED])
    {

        NSString *idTaxi = [dictionary objectForKey:@"driver_id"];

        self.idTaxista = idTaxi;

        if (!_areFoundingTaxiPosition)
        {

            [self startTimerPositionTaxi:YES];

        }

    }else if ([status isEqualToString:STATUS_CANCELED])
    {

        [_tysTaxi clearDelegateAndCancel];
        _tysTaxi.delegate = nil;
        self.tysTaxi = nil;

        [self startTimerAssigmentTaxi:NO];

        [self startTimerPositionTaxi:NO];

        [self clearservicepending];

//        [_delegate TYServiceProgressOperatorCancelTheService];
        [self operatorCancelServiceWithAlert:YES];

    }else if ([status isEqualToString:STATUS_CANCELED_FOR_DRIVER1] || [status isEqualToString:STATUS_CANCELED_FOR_DRIVER2]){

        [_tysTaxi clearDelegateAndCancel];
        _tysTaxi.delegate = nil;
        self.tysTaxi = nil;

        [self startTimerAssigmentTaxi:NO];

        [self startTimerPositionTaxi:NO];

        [self clearservicepending];

//        [_delegate TYServiceProgressOperatorCancelForDriverTheService];
        [self operatorCancelForDriverServiceWithAlert:YES];

    }else if ( [status isEqualToString:STATUS_CANCELED_FOR_DRIVER]){

        [[NSNotificationCenter defaultCenter] postNotificationName:@"push_system_service" object:nil userInfo:nil];

    }
    else if ([status isEqualToString:STATUS_ENDED])
    {

        NSLog(@"\n\n hppppppp _____________ TONTO HP ");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push_arrived" object:nil userInfo:nil];

        NSLog(@"PUSH ARRIVEDD  FUCK");

    }else if ([status isEqualToString:STATUS_PENDING]){

    }else if ([status isEqualToString:STATUS_RUNNING]){

    }else{

    }
}

- (void)startTimerPositionTaxi:(BOOL)start{

    if (start) {
        _areFoundingTaxiPosition = YES;
        if (_timerPositionTaxi) {

            [_timerPositionTaxi invalidate];
            self.timerPositionTaxi = nil;

        }
        self.timerPositionTaxi = [NSTimer timerWithTimeInterval:4
                                                         target:self
                                                       selector:@selector(requestTaxiPosition)
                                                       userInfo:nil
                                                        repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timerPositionTaxi forMode:NSDefaultRunLoopMode];
    }else{
        _areFoundingTaxiPosition = NO;
        _idTaxista = @"";
        [_timerPositionTaxi invalidate];
        self.timerPositionTaxi = nil;
    }
}

- (void)clearservicepending{

    [TYUsserProfile SetUsserInfo:@"-1" ForKey:USSER_HAVE_SERVICE_PENDING];

}

- (void)showAlertWithMessage:(NSString *)msg tag:(int)tag{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:msg
                                                    delegate:nil
                                           cancelButtonTitle:@"Aceptar"
                                           otherButtonTitles:nil];

    alert.tag = tag;
    [alert show];
}

- (void)makeLogicRequestService:(NSMutableDictionary *)values
{
    NSLog(@"makeLogicRequestService +");
    NSLog(@"%s \n %@", __PRETTY_FUNCTION__, [values description]);

    bool isSuscees = (bool) [values objectForKey:@"success"];
    if (isSuscees) {

        NSString *idService = [values objectForKey:@"service_id"];
        long serviceID = -1;
        @try {
            serviceID = [idService integerValue];
        }
        @catch (NSException *exception) {
            serviceID = -1;
        }
        @finally {

            if(serviceID > 0){
                NSLog(@" INICIA TIMER CON SERVICIO %@", idService);
                [TYUsserProfile SetUsserInfo:idService ForKey:USSER_HAVE_SERVICE_PENDING];
                [TYUsserProfile SetUsserInfo:idService ForKey:USSER_LAST_SERVICE];
                [TYUsserProfile SetUsserInfo:idService ForKey:USSER_SERVICE_ID_FOR_QUALITY];

                [(AppDelegate *)[[UIApplication sharedApplication] delegate] validateSolicitudService];

            }else{

                [self clearservicepending];

            }
        }

    }else{

        [self clearservicepending];

        //[self sendDelegateFailWithRequestType:TYSTaxiTypeRequestService];
        [self operatorCancelServiceWithAlert:NO];

        [self showAlertWithMessage:@"Verifica tu conexión a internet" tag:0];

        return;
    }
}

- (void)cancelService {

    NSString *stringCancel;
    if(self.serviceAreFounded){
        stringCancel = @"¿Estas seguro de cancelar el servicio?";
    }else{
        stringCancel = @"¿Estas seguro de cancelar la solicitud del servicio?";
    }
    _alertCancelService = [[UIAlertView alloc] initWithTitle:@"¡Importante!"
                                                    message:stringCancel
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Si", nil];
    _alertCancelService.tag = 1000;
    [_alertCancelService show];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"Text field Did Beging Editing:----%ld", (long)textField.tag);

    [self startObservingKeyboard];

    [self setupInputAccessoryView];
    self.searchAddress.autocorrectionType = UITextAutocorrectionTypeNo;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"Text field Did End Editing:----%ld", (long)textField.tag);

    [self stopObservingKeyboard];

}

- (IBAction)btnAddresses:(id)sender {
    NSLog(@"");
}



- (void) taxicancelservice: (NSNotification*)aNorification
{


    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"service_alert_timeout_title",nil)
                                                    message:NSLocalizedString(@"service_alert_driver_cancel",nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"service_alert_timeout_accept",nil)
                                          otherButtonTitles:nil];
    //alert.tag = 101;
    alert.tag = 105;

    [alert show];

}

- (void) usercancelservice: (NSNotification*)aNorification {
    NSLog(@"usercancelservice :");
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma marks - AddressesVCDelegate
-(void)addressSelected:(TYAddress *) address {
    NSLog(@"addressSelected  -----nam  %@", address.addressName);
    NSLog(@"addressSelected  -----dir  %@", address.addressFull);
    NSLog(@"addressSelected  -----lat  %@", address.latitude);
    NSLog(@"addressSelected  -----lng  %@", address.longitude);

    _isAddressFromList = YES;

    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake([address.latitude floatValue], [address.longitude floatValue]);


    [_mapView setCamera:[GMSCameraPosition cameraWithTarget:coord1 zoom:17]];
    self.searchAddress.text = address.addressFull;

}

#pragma <LocationUpdateProtocol>
-(void)locationDidUpdateToLocation:(CLLocation *)location {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:(-5 * 3600)];
    [dateFormatter setTimeZone:timeZone];

    NSLog(@"ServiceVWC locationDidUpdateToLocation %f %f %@",location.coordinate.latitude,location.coordinate.longitude,
          [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]]);

    _locationManager.currentLocation = location;

    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    [self.mapView setCamera:[GMSCameraPosition cameraWithTarget:coord1 zoom:16]];
    [_locationManager stopUpdatingLocation];
}

#pragma mark - HTTPRequest Delegate

- (void)didCompleteWithError:(NSError *)error {

}

- (void)didCompleteReceiveData:(NSDictionary *)data {

}

-(void)didCompleteRequest:(int)request receiveData:(NSDictionary *)data {
    NSLog(@"REPONDIENDO %i %@", request, data);
    if (request == 6) {
        long error = [[data objectForKey:@"error"] integerValue];
        if (error == 0) {

            // remove flag de services
            [self confirmServiceCancelled];
            [self deleteTaxiAccepted];
            [self deleteTaxiArrived];
            [self deleteServiceQualified];
            [self deleteServiceCancelled];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"call_request_service" object:self userInfo:@{@"data": @"call_request_service"}];

            //[self.navigationController popToRootViewControllerAnimated:YES];
            // validar
            [self removeViewsRequestService];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"push_user_cancel_service" object:self userInfo:@{@"data": @"push_user_cancel_service"}];

        }
    }
    
    if (request == 10) {
        NSLog(@"respuesta de validación de ticket ");
        
        isTicketValid = NO;
        
        long error = [[data objectForKey:@"error"] integerValue];
        if (error == 0) {
            // valido
            [self.buttonRequestService setBackgroundImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];
            isTicketValid = YES;
            
            self.ticket = self.ticketValue.text;
            
            self.buttonRequestService.enabled = YES;
        }
        else {
            // no valido
            [self.buttonRequestService setBackgroundImage:[UIImage imageNamed:@"btn_gris_n"] forState:UIControlStateNormal];
            
            self.ticket = nil;
            self.buttonRequestService.enabled = NO;
        }

        
        
    }

}

-(void)didCompleteRequest:(int)request withError:(NSError *)error {
    if (request == 10) {
        NSLog(@"Error al llamar la verificación del ticket");
        [self.buttonRequestService setBackgroundImage:[UIImage imageNamed:@"btn_gris_n"] forState:UIControlStateNormal];
        isTicketValid = NO;
        self.buttonRequestService.enabled = NO;
    }

}

-(void) deleteTaxiAccepted {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"taxi_accepted"];
}

-(void) confirmServiceCancelled {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"yes" forKey:@"service_cancelled"];
}

-(void) deleteServiceCancelled {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"service_cancelled"];
}

-(void) confirmTaxiArrived {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"yes" forKey:@"taxi_arrived"];
}

-(void) deleteTaxiArrived {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"taxi_arrived"];
}

-(void) deleteServiceQualified {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"service_qualification"];
}




@end
