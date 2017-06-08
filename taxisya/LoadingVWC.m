//
//  LoadingVWC.m
//  taxisya
//
//  Created by NTTak3 on 28/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "LoadingVWC.h"
#import <QuartzCore/QuartzCore.h>
#import "ServiceVWC.h"
#import "HTTPSyncRequest.h"
#import "AppDelegate.h"

@interface LoadingVWC ()

@property (nonatomic, strong) GMSMapView                    *mapView;

@end

@implementation LoadingVWC

@synthesize delegate                    = _delegate;
@synthesize imgvwLoading                = _imgvwLoading;
@synthesize imgvwLoadingBack            = _imgvwLoadingBack;
@synthesize enableAnimation             = _enableAnimation;
@synthesize serviceAreFounded           = _serviceAreFounded;
@synthesize currentImageNumber          = _currentImageNumber;
@synthesize imgvwRow                    = _imgvwRow;

@synthesize currentView                 = _currentView;

@synthesize vwTaxista                   = _vwTaxista;
@synthesize imgvwPerfil                 = _imgvwPerfil;
@synthesize lbTaxistaName               = _lbTaxistaName;
@synthesize lbTaxistDescription         = _lbTaxistDescription;
@synthesize lbTaxistaPlaca              = _lbTaxistaPlaca;
@synthesize lbTaxistaMarca              = _lbTaxistaMarca;
@synthesize lbMisDatosSon               = _lbMisDatosSon;
@synthesize btnTaxistaPhone             = _btnTaxistaPhone;
@synthesize imgvwTaxistaBuzon           = _imgvwTaxistaBuzon;
@synthesize loadingTaxistaImage         = _loadingTaxistaImage;

@synthesize currentTaxiProfile          = _currentTaxiProfile;
@synthesize alertCancelService          = _alertCancelService;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {



    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [self.view setFrame:[[NTUDeviceInfo sharedInstance] getRootFrameForDeviceWithOrientation:UIInterfaceOrientationPortrait]];

    if([NTUDeviceInfo NTUDIGetDevice] != DeviceIphone5) {
        [_imgvwRow setFrame:CGRectMake(_imgvwRow.frame.origin.x , _imgvwRow.frame.origin.y  + 7, _imgvwRow.frame.size.width, _imgvwRow.frame.size.height)];
    }

    _locationManager = [LocationManager sharedInstance];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];

    self.totUnits.hidden = YES;
    self.totCharge.hidden = YES;
    self.totAmount.hidden = YES;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiArrived:) name:@"push_taxi_arrived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceFinished:) name:@"push_taxi_finish_service" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxicancelservice:) name:@"push_driver_cancel_service" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiPosition:) name:@"push_taxi_position" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usercancelservice:) name:@"push_user_cancel_service" object:nil];
    
    
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


//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiarrived:) name:@"push_arrived" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiReset:) name:@"push_arrived_alert" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiTanks:) name:@"push_arrived_alert_tanks" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiarrived_2:) name:@"push_arrived_2" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiarrivedFinalization:) name:@"push_arrived_finalization" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiarrived_push:) name:@"push_arrived_push" object:nil];

    _currentView = CurrentViewLoading;

    [self setup];

    [self show:YES];

    [self setupTaxistaView];
    
    
    // make view lblAuthorizationCode
    // lbTaxistaName
    CGRect r = self.lbTaxistaName.frame;
    int h1 = r.origin.y + r.size.height;
    int w1 = self.view.bounds.size.width;

    NSString *cellphone = [TYUsserProfile UsserInfoForKey:USSER_CELLPHONE];
    NSString *code = [cellphone substringFromIndex: [cellphone length] - 2];
    
    NSLog(@"AUTHO %@", code);
    
    self.lbAuthorizationCode = [[UILabel alloc] initWithFrame:CGRectMake(40,h1+50,w1-10,24)];
    self.lbAuthorizationCode.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"ticket_code",nil),code];
    
    [self.view addSubview:self.lbAuthorizationCode];
    

    
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCloseAutomatic:) name:@"push_close_session" object:nil];

    //[self.view setBackgroundColor:[UIColor cyanColor]];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] validateSolicitudService];

    if (self.statusId == 4) {
        self.qualService.hidden = YES;
        
        self.cancelBtn.hidden = YES;
        self.viewMapBtn.hidden = NO;

        [self.viewMapBtn setFrame:CGRectMake(self.qualService.frame.origin.x,
                                             self.qualService.frame.origin.y,
                                             self.qualService.frame.size.width,
                                             self.qualService.frame.size.height)];
    }
    else if (self.statusId == 5) {
        self.qualService.hidden = NO;
        self.cancelBtn.hidden = YES;
        self.viewMapBtn.hidden = YES;
        
        // TODO:
        [self showAmountService];
        
        [self.lbTaxistDescription setText:NSLocalizedString(@"service_message_tanks",nil)];
    }
    else {
         [self confirmTaxiAccepted];
    }
    [self taxistaInfo:self.driver];

    self.isWithoutNetwordk = NO;
}

-(void)showAmountService {
    NSLog(@"showAmountService +");

    NSLog(@"");
    
    self.totUnits.text = NSLocalizedString(@"ticket_tot_units",nil);  // @"Total unidades: ";
    self.totCharge.text = NSLocalizedString(@"ticket_tot_charge",nil); // @"Total recargo:";
    self.totAmount.text = NSLocalizedString(@"ticket_tot_val",nil); // @"Total COP ";

    self.totUnits.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"ticket_tot_units",nil),self.mUnits];
    
    NSInteger total = [self.mCharge1 intValue] + [self.mCharge2 intValue] + [self.mCharge3 intValue] + [self.mCharge4 intValue];
    self.totCharge.text = [NSString stringWithFormat:@"%@ %ld",NSLocalizedString(@"ticket_tot_charge",nil),total];
    self.totAmount.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"ticket_tot_val",nil),self.mValue];

    
    self.totUnits.hidden = NO;
    self.totCharge.hidden = NO;
    self.totAmount.hidden = NO;
    
    
    
    NSLog(@"showAmountService -");
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear LoadingVWC");
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear LoadingVWC");

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"push_driver_cancel_service" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"push_user_cancel_service" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];

}


-(void)dealloc {
    NSLog(@"dealloc LoadinVWC ");
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
    
    self.networkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageNetworkStatus.frame.origin.y + 110, screenWidth, 24)];
    [self.networkLabel setTextColor:[UIColor whiteColor]];
    [self.networkLabel setText:NSLocalizedString(@"connection_bad",nil)];
    [self.networkLabel setFont:[self.networkLabel.font fontWithSize:18]];
    self.networkLabel.textAlignment = NSTextAlignmentCenter;
    
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


- (void) taxiarrivedFinalization: (NSNotification*)aNorification {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"push_show_view_qual" object:nil userInfo:nil];

    self.qualService.hidden = NO;
    self.cancelBtn.hidden = YES;
    self.viewMapBtn.hidden = YES;

    // 10

    //[self taxiTanks];
}

- (void) taxiReset:(NSNotification*)aNorification {

    // NSDictionary *driver = [[[[aNorification userInfo]
    //                objectForKey:@"aps"]
    //               objectForKey:@"extra"]
    //              objectForKey:@"driver"];
    NSLog(@"TaixsyaUsuarios -    LoadingVWC taxiReset A %@", [aNorification userInfo]);

    NSDictionary *driver =[[aNorification userInfo] objectForKey:@"driver"];

    NSLog(@"TaixsyaUsuarios -    LoadingVWC taxiReset B %@",driver[@"id"]);

    if (driver != nil)
       [self taxistaInfo:driver];

    //[self.lbTaxistDescription setText:@"Hola dentro de pocos minutos estaré a tu disposición para llevarte seguro a tu destino."];
    [self.lbTaxistDescription setText:NSLocalizedString(@"service_message_reset",nil)];
}

-(void) taxistaInfo:(NSDictionary *)driver {

    // set profile
    self.lbTaxistaName.text = [NSString stringWithFormat:@"%@ %@",
                               [driver objectForKey:@"name"],
                               [driver objectForKey:@"lastname"]];
    self.lbTaxistaPlaca.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"service_license_plate",nil), [[driver objectForKey:@"car"] objectForKey:@"placa"] ];
    [self.btnTaxistaPhone setTitle:[driver objectForKey:@"cellphone"] forState:UIControlStateNormal];
    [self.btnTaxistaPhone setTitle:[driver objectForKey:@"cellphone"] forState:UIControlStateHighlighted];

    self.lbTaxistaMarca.text = [NSString stringWithFormat:@"%@:%@ %@",NSLocalizedString(@"service_brand",nil), [[driver objectForKey:@"car"] objectForKey:@"car_brand"], [[driver objectForKey:@"car"] objectForKey:@"model"]];


    if([driver objectForKey:@"picture"] && [driver objectForKey:@"picture"] != (NSString *)[NSNull null])
    {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{

            NSData *data = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:
                             [NSString stringWithFormat:@"%@%@", SERVICES, [driver objectForKey:@"picture"] ]]];

            if(data)
            {

                dispatch_async(dispatch_get_main_queue(), ^{

                    [_loadingTaxistaImage stopAnimating];

                    [_imgvwPerfil setImage:[UIImage imageWithData:data]];

                });

            }

        });

    }
}


- (void) taxiTanks:(NSNotification*)aNorification  {
    NSLog(@"Muestra el mensaje-----------------------------------");
    NSLog(@"TaixsyaUsuarios -    LoadingVWC taxiTanks");

    NSDictionary *driver =[[aNorification userInfo] objectForKey:@"driver"];

    NSLog(@"TaixsyaUsuarios -    LoadingVWC taxiarrived_push %@",driver[@"id"]);

    if (driver != nil)
       [self taxistaInfo:driver];

    //[self.lbTaxistDescription setText:@"Gracias por utilizar TaxisYa, te invitamos a calificar nuestro servicio."];
    [self.lbTaxistDescription setText:NSLocalizedString(@"service_message_tanks",nil)];
}

- (void) taxiarrived: (NSNotification*)aNorification {
    NSLog(@"TaixsyaUsuarios -    LoadingVWC taxiarrived");


    [[NSNotificationCenter defaultCenter] postNotificationName:@"push_show_view_qual" object:nil userInfo:nil];

    self.qualService.hidden = NO;
    self.cancelBtn.hidden = YES;
    self.viewMapBtn.hidden = YES;

//    [self.viewMapBtn setFrame:CGRectMake(160, self.viewMapBtn.frame.origin.y, self.viewMapBtn.frame.size.width, self.viewMapBtn.frame.size.height)];
    [self.viewMapBtn setFrame:CGRectMake(self.qualService.frame.origin.x,
                                         self.qualService.frame.origin.y,
                                         self.qualService.frame.size.width,
                                         self.qualService.frame.size.height)];

//    [self.lbTaxistDescription setText:@"Hola dentro de pocos minutos estaré a tu disposición para llevarte seguro a tu destino."];
//    [self taxiTanks];
}



- (void) taxiarrived_push: (NSNotification*)aNorification {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"push_show_view_qual_push" object:nil userInfo:nil];

//    [self.viewMapBtn setFrame:CGRectMake(160, self.viewMapBtn.frame.origin.y, self.viewMapBtn.frame.size.width, self.viewMapBtn.frame.size.height)];
    [self.viewMapBtn setFrame:CGRectMake(self.qualService.frame.origin.x,
                                         self.qualService.frame.origin.y,
                                         self.qualService.frame.size.width,
                                         self.qualService.frame.size.height)];


    self.qualService.hidden = NO;
    self.cancelBtn.hidden = YES;
    self.viewMapBtn.hidden = YES;

    //[self taxiTanks];

//  [self.lbTaxistDescription setText:@"Hola dentro de pocos minutos estaré a tu disposición para llevarte seguro a tu destino."];

}

- (void) taxiarrived_2: (NSNotification*)aNorification {

//    [self taxiTanks];

    [self hiddenCancel];
}



- (void)hiddenCancel {
    self.cancelBtn.hidden = YES;

    [_alertCancelService dismissWithClickedButtonIndex:0 animated:YES];
    //[self.viewMapBtn setFrame:CGRectMake(90, self.viewMapBtn.frame.origin.y, self.viewMapBtn.frame.size.width, self.viewMapBtn.frame.size.height)];
    [self.viewMapBtn setFrame:CGRectMake(self.qualService.frame.origin.x,
                                         self.qualService.frame.origin.y,
                                         self.qualService.frame.size.width,
                                         self.qualService.frame.size.height)];

    self.viewMapBtn.hidden = NO;

//    [self.lbTaxistDescription setText:@"Gracias por utilizar TaxisYa, te invitamos a calificar nuestro servicio."];
}


// nuevo push leo
-(void)taxiArrived:(NSNotification*)aNorification {
    NSDictionary *driver =[[aNorification userInfo] objectForKey:@"driver"];
    NSLog(@"taxiArrived %@",driver);
    [self hiddenCancel];
}

-(void)serviceFinished:(NSNotification*)aNorification {
    
    NSLog(@"serviceFinished A %@",[aNorification userInfo]);
    NSLog(@"serviceFinished B %@",aNorification);
    
    self.mUnits = [[aNorification userInfo] objectForKey:@"units"];
    self.mCharge1 = [[aNorification userInfo] objectForKey:@"charge1"];
    self.mCharge2 = [[aNorification userInfo] objectForKey:@"charge2"];
    self.mCharge3 = [[aNorification userInfo] objectForKey:@"charge3"];
    self.mCharge4 = [[aNorification userInfo] objectForKey:@"charge4"];
    self.mValue = [[aNorification userInfo] objectForKey:@"value"];
    
    
    
    NSDictionary *driver =[[aNorification userInfo] objectForKey:@"driver"];
    NSLog(@"serviceFinished %@",driver);
    self.qualService.hidden = NO;
    self.cancelBtn.hidden = YES;
    self.viewMapBtn.hidden = YES;
    [self.lbTaxistDescription setText:NSLocalizedString(@"service_message_tanks",nil)];
    
    [self showAmountService];
    

}

- (void) taxicancelservice: (NSNotification*)aNorification
{


    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"service_alert_timeout_title",nil)
                                                            message:NSLocalizedString(@"service_alert_driver_cancel",nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"service_alert_timeout_accept",nil)
                                                  otherButtonTitles:nil];
    //alert.tag = 101;
    alert.tag = 102;

    [alert show];

}

- (void) usercancelservice: (NSNotification*)aNorification
{
    NSLog(@"LoadingVWC  usercancelservice");

    [self confirmServiceCancelled];
    [self deleteTaxiAccepted];
    [self deleteTaxiArrived];
    [self deleteServiceQualified];
    [self deleteServiceCancelled];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void) taxiPosition: (NSNotification*)aNorification
{

    NSLog(@"taxiPosition %@", aNorification);

    float lat = [[[aNorification userInfo] objectForKey:@"crt_lat"] floatValue];
    float lng = [[[aNorification userInfo] objectForKey:@"crt_lng"] floatValue];

    NSLog(@"taxiPosition profile %@",self.currentTaxiProfile);
    NSLog(@"taxiPosition lat,lng %f,%f", lat,lng);

    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    self.taxiLocation = myLocation;
    NSLog(@"taxiPosition %f,%f  %f,%f",self.taxiLocation.coordinate.latitude, self.taxiLocation.coordinate.longitude, lat,lng);

}

#pragma mark - UIALertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    long tag = alertView.tag;
    if (tag == 102){
        // validar
        [self confirmServiceCancelled];
        [self deleteTaxiAccepted];
        [self deleteTaxiArrived];
        [self deleteServiceQualified];
        [self deleteServiceCancelled];

        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (tag == 110) {
        NSLog(@"alert 110");
    }
    else {
        if (buttonIndex != 0) {

            [_delegate LoadingVWCUsserRequestCancelService];

            [self setup];

            [[[HTTPSyncRequest alloc] init] cancelService:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [TYUsserProfile UsserInfoForKey:USSER_ID], @"user_id",
                                                           nil] delegate:self];
        }

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)show:(BOOL)show {
    [self show:show animated:YES];
}


- (void)show:(BOOL)show animated:(BOOL)animated {
    NSLog(@"TaixsyaUsuarios -    LoadingVWC show");


    if(show){
        //_currentView = CurrentViewTaxista;

       // prueba sin animación +
       self.view.alpha = 1;

     //   // prueba sin animación -
     // self.qualService.hidden = YES;
     // self.cancelBtn.hidden   = NO;
     // self.viewMapBtn.hidden  = NO;

        NSLog(@"TaixsyaUsuarios -    LoadingVWC show:YES");

        NSLog(@"ENTRA AL SHOW PERO DEL LOADING--------------------------");
        _enableAnimation = YES;
    }else{
        NSLog(@"TaixsyaUsuarios -    LoadingVWC show:NO");
        NSLog(@"SALE DEL SHOW PERO DEL LOADING----%d----------------------", _serviceAreFounded);
        // prueba sin animación +
        self.view.alpha     = 0;
        [_delegate LoadingVWHaveService:_serviceAreFounded];
        // prueba sin animación -
        _enableAnimation = NO;
    }

}


- (void)setup {
    NSLog(@"LoadingVWC setup");
    _currentView = CurrentViewLoading;
    self.serviceAreFounded = NO;
    self.currentImageNumber = 1;
    self.enableAnimation = NO;
    [_imgvwLoadingBack setImage:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%i.png", _currentImageNumber]]];
    [_imgvwLoading setImage:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%i.png", _currentImageNumber]]];
    [_imgvwRow setTransform:CGAffineTransformMakeRotation(M_PI + (M_PI / 4) + ((M_PI / 4) / 2) + 0.08)];
    [_loadingTaxistaImage startAnimating];
    
    
    
}

- (void)setupTaxistaView{
    NSLog(@"LoadingVWC setupTaxistaView=");
    [self setRoundedView:_imgvwPerfil toDiameter:90];

    [_lbTaxistDescription setFont:UI_FONT_1(20)];
    [_lbTaxistaName setFont:UI_FONT_1(20)];
    [_lbTaxistaPlaca setFont:UI_FONT_1(20)];
    [_lbMisDatosSon setFont:UI_FONT_1(21)];
    [_lbTaxistaMarca setFont:UI_FONT_1(19)];

    if([NTUDeviceInfo NTUDIGetDevice] != DeviceIphone5){

        int y = 40;

        [_lbTaxistDescription setFrame:CGRectMake(_lbTaxistDescription.frame.origin.x, _lbTaxistDescription.frame.origin.y - (y - 27), _lbTaxistDescription.frame.size.width, _lbTaxistDescription.frame.size.height)];

        y -= 35;

        [_lbTaxistaName setFrame:CGRectMake(_lbTaxistaName.frame.origin.x, _lbTaxistaName.frame.origin.y - (y + 22), _lbTaxistaName.frame.size.width, _lbTaxistaName.frame.size.height)];
        [_lbTaxistaPlaca setFrame:CGRectMake(_lbTaxistaPlaca.frame.origin.x, _lbTaxistaPlaca.frame.origin.y - (y + 22), _lbTaxistaPlaca.frame.size.width, _lbTaxistaPlaca.frame.size.height)];
        [_imgvwTaxistaBuzon setFrame:CGRectMake(_imgvwTaxistaBuzon.frame.origin.x, _imgvwTaxistaBuzon.frame.origin.y - (y + 22), _imgvwTaxistaBuzon.frame.size.width, _imgvwTaxistaBuzon.frame.size.height)];


        [_lbMisDatosSon setFrame:CGRectMake(_lbMisDatosSon.frame.origin.x, _lbTaxistDescription.frame.origin.y + _lbTaxistDescription.frame.size.height + 5, _lbMisDatosSon.frame.size.width, _lbMisDatosSon.frame.size.height)];

        [_btnTaxistaPhone setFrame:CGRectMake(_btnTaxistaPhone.frame.origin.x, _lbTaxistaPlaca.frame.origin.y + _lbTaxistaPlaca.frame.size.height + 3, _btnTaxistaPhone.frame.size.width, _btnTaxistaPhone.frame.size.height)];

        [_lbTaxistaMarca setFrame:CGRectMake(_lbTaxistaMarca.frame.origin.x, _btnTaxistaPhone.frame.origin.y + _btnTaxistaPhone.frame.size.height + 3, _lbTaxistaMarca.frame.size.width, _lbTaxistaMarca.frame.size.height)];

    }

    //    [_btnTaxistaPhone TYServiceProgressUpdateTaxiInfo]
    [_btnTaxistaPhone setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    //[_btnTaxistaPhone setTitleColor:UI_COLOR_ORAGNE forState:UIControlStateNormal];
    //[_btnTaxistaPhone setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_btnTaxistaPhone.titleLabel setFont:UI_FONT_1(18)];
    [_lbTaxistaMarca setFont:UI_FONT_1(18)];
    [_lbTaxistaMarca setTextColor:UI_COLOR_ORAGNE];

    //    [_btnTaxistaPhone ]

    // set text
    [self.lbMisDatosSon setText:NSLocalizedString(@"service_message_my_information",nil)];
    [self.cancelBtn setTitle:NSLocalizedString(@"service_button_cancel",nil) forState:UIControlStateNormal];
    [self.cancelBtn setTitle:NSLocalizedString(@"service_button_cancel",nil) forState:UIControlStateHighlighted];

    [self.viewMapBtn setTitle:NSLocalizedString(@"service_button_map",nil) forState:UIControlStateNormal];
    [self.viewMapBtn setTitle:NSLocalizedString(@"service_button_map",nil) forState:UIControlStateHighlighted];

    [self.qualService setTitle:NSLocalizedString(@"service_button_rate",nil) forState:UIControlStateNormal];
    [self.qualService setTitle:NSLocalizedString(@"service_button_rate",nil) forState:UIControlStateHighlighted];

}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)animateClock{

    if(_enableAnimation)
    {

        [_imgvwLoadingBack setImage:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%i.png", _currentImageNumber]]];

        _currentImageNumber ++;

        if(_currentImageNumber > 7 && !_serviceAreFounded)
        {

            _enableAnimation = NO;

            return;

        }else if (_currentImageNumber > 8)
        {

            _enableAnimation = NO;

            if(_serviceAreFounded)
            {
                [self showTaxistaInfo:YES];

            }else
            {

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Algo salio mal porfavor intenta mas tarde"
                                                               delegate:Nil
                                                      cancelButtonTitle:@"Aceptar"
                                                      otherButtonTitles:nil];

                [alert show];

            }

            return;

        }

        [_imgvwLoading setAlpha: 0];
        [_imgvwLoading setImage:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%i.png", _currentImageNumber]]];

        [UIView animateWithDuration:0.4
                         animations:^(void){

                             [_imgvwLoading setAlpha:1];

                             if(_currentImageNumber == 2){

                                 [_imgvwRow setTransform:CGAffineTransformMakeRotation(M_PI + (M_PI / 4) + (M_PI / 4) + 0.09)];

                             }else if (_currentImageNumber == 3){

                                 [_imgvwRow setTransform:CGAffineTransformMakeRotation(M_PI + (M_PI / 4) + (M_PI / 2))];

                             }else if (_currentImageNumber == 4){

                                 CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);

                                 [_imgvwRow setTransform:CGAffineTransformRotate(transform, M_PI + (M_PI / 4) + (M_PI / 2) + (M_PI / 4))];

                             }else if (_currentImageNumber == 5){

                                 CGAffineTransform transform = CGAffineTransformMakeTranslation(-2.6, -5);

                                 [_imgvwRow setTransform:CGAffineTransformRotate(transform, (M_PI / 4) + 0.04)];


                             }else if (_currentImageNumber == 6){

                                 CGAffineTransform transform = CGAffineTransformMakeTranslation(-2.6, -5);

                                 [_imgvwRow setTransform:CGAffineTransformRotate(transform, (M_PI / 2) - 0.05)];

                             }else if (_currentImageNumber == 7){

                                 CGAffineTransform transform = CGAffineTransformMakeTranslation(-2.6, -5);

                                 [_imgvwRow setTransform:CGAffineTransformRotate(transform, (M_PI / 2) + ((M_PI / 4) / 2))];


                             }else if (_currentImageNumber == 8){

                                 CGAffineTransform transform = CGAffineTransformMakeTranslation(-2.6, -5);

                                 [_imgvwRow setTransform:CGAffineTransformRotate(transform, (M_PI / 2) + (M_PI / 4) + 0.01)];

                             }

                         }
                         completion:^(BOOL f){

                             float delay = 0;

                             if(_serviceAreFounded){

                                 delay = 0.5f;

                             }else{

                                 delay = (arc4random() % 6) + 5;

                             }
                             [self performSelector:@selector(animateClock) withObject:nil afterDelay:delay];

                         }];

    }

}

- (IBAction)onCloseAutomatic:(id)sender{
    [self cancelServiceAutomatic];
}

- (IBAction)onClose:(id)sender{

    if(_currentView == CurrentViewLoading){
        [self cancelService];
    }else{
        [self show:NO];
    }
}


- (IBAction)taxistaCancelService:(id)sender{

    [self cancelService];

}

- (IBAction)taxistaSeeMap:(id)sender{

//    [self show:NO];

//    [_delegate LoadingVWCFocusTaxi];


    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;


    // armar vista
    // 0,46
//    self.viewTest = [[UIView alloc] initWithFrame:CGRectMake(0,45,screenWidth,screenHeight - 45)];
//    [self.viewTest setBackgroundColor:[UIColor cyanColor]];
//    [self.view addSubview:self.viewTest];



    self.mapView.frame = CGRectMake(0, 45, screenWidth, screenHeight -45);
    self.mapView.userInteractionEnabled = YES;



    // map
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
//                                                            longitude:lng
//                                                                 zoom:16];

//    double lat = [NSLocalizedString(@"geo_lat",nil) floatValue];
//    double lng = [NSLocalizedString(@"geo_lng",nil) floatValue];
    double lat = _locationManager.currentLocation.coordinate.latitude;
    double lng = _locationManager.currentLocation.coordinate.longitude;

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lng zoom:12];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 45, screenWidth, screenHeight - 45) camera:camera];
    self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;
    [self.view addSubview:self.mapView];

    //[self showMapView];
    //self.currentTaxiProfile.latitude

    NSLog(@"taxistaSeeMap taxista %f,%f", self.currentTaxiProfile.latitude, self.currentTaxiProfile.longitude);
    NSLog(@"taxistaSeeMap taxista %f,%f", self.taxiLocation.coordinate.latitude, self.taxiLocation.coordinate.longitude);

    NSLog(@"taxistaSeeMap user %f,%f", lat, lng);



    CLLocationCoordinate2D current = CLLocationCoordinate2DMake(
                                                                self.taxiLocation.coordinate.latitude,
                                                                self.taxiLocation.coordinate.longitude);


//    CLLocationCoordinate2D current = CLLocationCoordinate2DMake(
//                                                                self.currentTaxiProfile.latitude,
//                                                                self.currentTaxiProfile.longitude);



    GMSCameraUpdate *currentCam = [GMSCameraUpdate setTarget:current];
    [_mapView animateWithCameraUpdate:currentCam];



    GMSMarker *melbourneMarker = [[GMSMarker alloc] init];
    melbourneMarker.title = @"Taxi!";
    melbourneMarker.icon = [UIImage imageNamed:@"taxi"];
    melbourneMarker.position = CLLocationCoordinate2DMake(self.taxiLocation.coordinate.latitude, self.taxiLocation.coordinate.longitude);
    //melbourneMarker.position = CLLocationCoordinate2DMake(self.currentTaxiProfile.latitude, self.currentTaxiProfile.longitude);

    melbourneMarker.map = _mapView;


    self.buttonHideMap = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2) - ((screenWidth - 20.0f) / 2.0f), screenHeight - 58, screenWidth - 20, 48)];
    [self.buttonHideMap setTitle:NSLocalizedString(@"loading_button_driver",nil) forState:UIControlStateNormal];
    [self.buttonHideMap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonHideMap setBackgroundColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]];
    [self.buttonHideMap addTarget:self action:@selector(hideMapAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.buttonHideMap setHidden:YES];
    [self.view addSubview:self.buttonHideMap];
}



-(void)hideMapAction:(id)sender {
    NSLog(@"hideMapAction ");

    [self.buttonHideMap removeFromSuperview];
    [self.mapView removeFromSuperview];
    [self.viewTest removeFromSuperview];

    self.buttonHideMap = nil;
    self.mapView = nil;
    self.viewTest = nil;

}

-(void)showMapView {

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[NSLocalizedString(@"geo_lat",nil) floatValue]
                                                            longitude:[NSLocalizedString(@"geo_lng",nil) floatValue]
                                                                 zoom:12];

    self.mapView = [GMSMapView mapWithFrame:self.viewTest.bounds camera:camera];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];

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
    //    [btn setFrame:CGRectMake(0, 0, 43, 46)];
    [btn setFrame:CGRectMake(0, 0, 43, 46)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setImage:[UIImage imageNamed:@"localization-arrow2.png"] forState:UIControlStateNormal];
    //    [btn setCenter:CGPointMake(30, _mapVWContainer.frame.size.height  - 27)];
    [btn setCenter:CGPointMake(self.mapView.frame.size.width - 30, self.mapView.frame.origin.y + 40)];

    [btn addTarget:self action:@selector(didTapMyLocation) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:btn];

}

- (void)didTapMyLocation {
    NSLog(@"didTapMyLocation ...");

    /*
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;

//    if(IS_IOS8){
//        [self.locationManager requestWhenInUseAuthorization];
//        [self.locationManager requestAlwaysAuthorization];
//    }

    [self.locationManager startUpdatingLocation];

    CLLocation *location = self.locationManager.location;


    if (!location || !CLLocationCoordinate2DIsValid(location.coordinate)) {
        return;
    }

    NSLog(@"ANTES DEL ANIMATE MAP 1");
    [self animateMapToCoordenate:location];
    */
}


-(void)hideMapView {

}

- (void)taxistaCall:(id)sender{

    UIButton *btn = (UIButton *)sender;

    NSString *title = btn.titleLabel.text;

    NSString *phoneNumber = [@"tel://" stringByAppendingString:title];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

}




- (void)showTaxistaInfo:(BOOL)show{

    if(show){
        NSLog(@"TaixsyaUsuarios -    showTaxistaInfo: show");

        if(!self.serviceAreFounded){
            _currentView = CurrentViewTaxista;

            // prueba sin animación +
             [_vwTaxista setTransform:CGAffineTransformMakeTranslation(0, 0)];
             [_vwTaxista setAlpha:1];
             [_vwLoading setTransform:CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0)];
             [_vwLoading setAlpha:0];

            // prueba sin animación -
/*
            [_vwTaxista setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)];
            [_vwTaxista setAlpha:0];

            [UIView animateWithDuration:0.3
                             animations:^(void){

                                 [_vwTaxista setTransform:CGAffineTransformMakeTranslation(0, 0)];
                                 [_vwTaxista setAlpha:1];
                                 [_vwLoading setTransform:CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0)];
                                 [_vwLoading setAlpha:0];

                             }
                             completion:^(BOOL f){


                             }];
*/

        }
    }else{
        NSLog(@"TaixsyaUsuarios -    showTaxistaInfo: hide");

        _currentView = CurrentViewLoading;

// prueba sin animación +
     [_vwLoading setTransform:CGAffineTransformMakeTranslation(0, 0)];
     [_vwLoading setAlpha:1];
     [_vwTaxista setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)];
     [_vwTaxista setAlpha:0];

// prueba sin animación -

/*
        [UIView animateWithDuration:0.3
                         animations:^(void){

                             [_vwLoading setTransform:CGAffineTransformMakeTranslation(0, 0)];
                             [_vwLoading setAlpha:1];
                             [_vwTaxista setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)];
                             [_vwTaxista setAlpha:0];

                         }
                         completion:^(BOOL f){


                         }];
*/

    }

}


- (void)setTaxiPofile:(TYTaxiProfile *)profile
{
    NSLog(@"TaixsyaUsuarios -    setTaxiPofile: %@ ", profile);

    NSLog(@"profile %@", profile);
    self.currentTaxiProfile = profile;


    if(_currentView == CurrentViewTaxista){


    }else{
        _enableAnimation = YES;
        [self showTaxistaInfo:YES];

    }

    if(![profile.placa isEqualToString:_currentTaxiProfile.placa])
    {

        self.currentTaxiProfile = profile;

        [self updateDriverInfo];

    }else{

        self.currentTaxiProfile = profile;

        [self updateDriverInfo]; // ver

    }

    if(!_serviceAreFounded)
    {
        self.serviceAreFounded = YES;

        if(!_enableAnimation)
        {
            _enableAnimation = YES;
            [self animateClock];

        }

    }

}

- (void)operatorCancelService
{

    [self setup];

    [self show:NO];

}

- (void)updateDriverInfo{
    NSLog(@"LoadingVWC updateDriberInfo %@",_currentTaxiProfile );

    self.lbTaxistaName.text = [NSString stringWithFormat:@"%@ %@", _currentTaxiProfile.name, _currentTaxiProfile.lastName];
    //self.lbTaxistaPlaca.text = [NSString stringWithFormat:@"Placa: %@", _currentTaxiProfile.placa];
    self.lbTaxistaPlaca.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"service_license_plate",nil), _currentTaxiProfile.placa];

    [self.btnTaxistaPhone setTitle:_currentTaxiProfile.phone forState:UIControlStateNormal];
    [self.btnTaxistaPhone setTitle:_currentTaxiProfile.phone forState:UIControlStateHighlighted];

    //[_btnTaxistaPhone setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

    //self.lbTaxistaMarca.text = [NSString stringWithFormat:@"Marca:%@ %@", _currentTaxiProfile.brand, _currentTaxiProfile.model];
    self.lbTaxistaMarca.text = [NSString stringWithFormat:@"%@:%@ %@",NSLocalizedString(@"service_brand",nil), _currentTaxiProfile.brand, _currentTaxiProfile.model];


    if(self.currentTaxiProfile.urlImage && self.currentTaxiProfile.urlImage  != (NSString *)[NSNull null])
    {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{

            NSData *data = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:
                             [NSString stringWithFormat:@"%@%@", SERVICES, self.currentTaxiProfile.urlImage]]];

            if(data)
            {

                dispatch_async(dispatch_get_main_queue(), ^{

                    [_loadingTaxistaImage stopAnimating];

                    [_imgvwPerfil setImage:[UIImage imageWithData:data]];

                });

            }

        });

    }

}

#pragma mark -
#pragma mark - AlertViewDelegate

/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex != 0)
    {

        [_delegate LoadingVWCUsserRequestCancelService];

        [self setup];

        //[self show:NO];
        //[_tyServiceProgress requestCancerService];

        [[[HTTPSyncRequest alloc] init] cancelService:[NSDictionary dictionaryWithObjectsAndKeys:

        [TYUsserProfile UsserInfoForKey:USSER_ID], @"user_id",
                                                                    nil] delegate:self];

        //[self.navigationController popToRootViewControllerAnimated:YES];

    }

}
 */

- (void)cancelServiceAutomatic {
    [_delegate LoadingVWCUsserRequestCancelServiceAutomatic];
    [self setup];
    [self show:NO];
}

- (void)cancelService {

    NSString *stringCancel;

    if(self.serviceAreFounded){
        stringCancel = NSLocalizedString(@"service_alert_cancel_message",nil);
    }else{
        stringCancel = @"¿Estas seguro de cancelar la solicitud del servicio?";
    }

    _alertCancelService = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"service_alert_cancel_title",nil)
                                                    message:stringCancel
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"service_alert_button_no",nil)
                                          otherButtonTitles:NSLocalizedString(@"service_alert_button_yes",nil), nil];
    _alertCancelService.tag = 2000;
    [_alertCancelService show];

}

- (IBAction)clickQualService:(id)sender {

    NSLog(@"clickQualService ----- ");


    [self performSelector:@selector(showClickeButtonForQualification) withObject:nil afterDelay:0.98];

/*

    [[NSNotificationCenter defaultCenter] postNotificationName:@"showViweQual" object:nil userInfo:nil];

    self.qualService.hidden = YES;
    self.cancelBtn.hidden   = NO;
    self.viewMapBtn.hidden  = NO;

    // tamaño de los botomes
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    // 10 + btn1 + 10 + btn2 + 10
    [self.cancelBtn setFrame:CGRectMake(10,
                                         self.cancelBtn.frame.origin.y,
                                         (screenWidth / 2) - 15,
                                         self.cancelBtn.frame.size.height)];

    [self.viewMapBtn setFrame:CGRectMake( (screenWidth / 2) + 5,
                                         self.viewMapBtn.frame.origin.y,
                                         (screenWidth / 2) - 15,
                                         self.viewMapBtn.frame.size.height)];
*/
//    [self.lbTaxistDescription setText:@"Hola dentro de pocos minutos estaré a tu disposición para llevarte seguro a tu destino."];

}

-(void)showClickeButtonForQualification {

    QualityService *qualityServiceVWC = [[QualityService alloc] initWithNibName:@"QualityService" bundle:nil];
    [self.navigationController pushViewController:qualityServiceVWC animated:YES];

}

-(void)removeCancelAlert {
    NSLog(@"reomveCancelAlert");

}


-(void) confirmTaxiAccepted {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"yes" forKey:@"taxi_accepted"];
}


- (IBAction)pepe:(id)sender {

}

- (void)initTaxiServicesIfNeeded{

    if(!_tyServiceProgress)
    {

        self.tyServiceProgress = [[TYServiceProgress alloc] initWithDelegate:self];

    }

}


#pragma mark - HTTPRequest Delegate

- (void)didCompleteWithError:(NSError *)error {

}

- (void)didCompleteReceiveData:(NSDictionary *)data {

}

-(void)didCompleteRequest:(int)request receiveData:(NSDictionary *)data {
    NSLog(@"LoadingVWC REPONDIENDO %i %@", request, data);

    if (request == 6) {
        long error = [[data objectForKey:@"error"] integerValue];
        if (error == 0) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"call_request_service" object:self userInfo:@{@"data": @"call_request_service"}];

            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if (error == 404) {


            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"service_alert_timeout_title",nil)
                                                            message:@"El servicio no puede ser cancelado"
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"service_alert_timeout_accept",nil)
                                                  otherButtonTitles:nil];
            //alert.tag = 101;
            alert.tag = 110;

            [alert show];

            // mostrar alerta si no se pudo cancelar el servicio

            //NSLog(@"didCompleteRequest arrived? %ld", self.statusId);
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"push_user_cancel_service" object:self userInfo:@{@"data": @"push_user_cancel_service"}];

        }
    }

}

-(void)didCompleteRequest:(int)request withError:(NSError *)error {

}

#pragma <LocationUpdateProtocol>
-(void)locationDidUpdateToLocation:(CLLocation *)location {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:(-5 * 3600)];
    [dateFormatter setTimeZone:timeZone];

    NSLog(@"LoadingVWC locationDidUpdateToLocation %f %f %@",location.coordinate.latitude,location.coordinate.longitude,
          [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]]);

    _locationManager.currentLocation = location;

    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    [self.mapView setCamera:[GMSCameraPosition cameraWithTarget:coord1 zoom:16]];
    //[_locationManager stopUpdatingLocation];
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
