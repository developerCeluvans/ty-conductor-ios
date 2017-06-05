//
//  MapViewController.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/6/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "MapViewController.h"
#import "ApiTaxisya.h"
#import "UIView+Toast.h"
#import "DirectionService.h"
#import "ServicesViewController.h"

@interface MapViewController ()
{
    UIControl   *backCover;
    BOOL        inhibitBackButtonBOOL;
    //GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1){
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }

    [self.locationManager startUpdatingLocation];

    NSLog(@"map viewDidLoad");
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                target:self
                selector:@selector(checkStatusService)
                userInfo:nil
                repeats:YES];

    // test +
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];

}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"MapViewController viewDidLayoutSubviews w: %f h: %f",self.view.frame.size.width, self.view.frame.size.height);
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    // Cover the back button (cannot do this in viewWillAppear -- too soon)
    if ( backCover == nil ) {
        backCover = [[UIControl alloc] initWithFrame:CGRectMake( 0, 0, 80, 44)];
#if TARGET_IPHONE_SIMULATOR
        // show the cover for testing
        backCover.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.15];
#endif
        [backCover addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
        UINavigationBar *navBar = self.navigationController.navigationBar;
        [navBar addSubview:backCover];
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [backCover removeFromSuperview];
    backCover = nil;
    [self.timerPosition invalidate];
    self.timerPosition = nil;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    // address
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 64, screenWidth - 4, 30)];
    self.addressLabel.textColor = [UIColor colorWithRed:0.447 green:0.447 blue:0.447 alpha:1];
    self.addressLabel.font = [self.addressLabel.font fontWithSize:24.0f];
    [self.view addSubview:self.addressLabel];

    // neighborhood
    self.neighborhoodLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 94, screenWidth, 20)];
    self.neighborhoodLabel.textColor = [UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f];
    self.neighborhoodLabel.font = [self.neighborhoodLabel.font fontWithSize:20.0f];
    [self.view addSubview:self.neighborhoodLabel];

    // observation
    self.observationLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 114, screenWidth, 20)];
    self.observationLabel.textColor = [UIColor colorWithRed:0.408 green:0.408 blue:0.408 alpha:1];
    self.observationLabel.font = [self.observationLabel.font fontWithSize:16.0f];
    [self.view addSubview:self.observationLabel];

    // destination
    self.destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 134, screenWidth, 20)];
    self.destinationLabel.textColor = [UIColor colorWithRed:0.408 green:0.408 blue:0.408 alpha:1];
    self.destinationLabel.font = [self.destinationLabel.font fontWithSize:16.0f];
    [self.view addSubview:self.destinationLabel];

    // user
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 154, screenWidth, 20)];
    self.userNameLabel.textColor = [UIColor colorWithRed:0.408 green:0.408 blue:0.408 alpha:1];
    self.userNameLabel.font = [self.userNameLabel.font fontWithSize:16.0f];
    [self.view addSubview:self.userNameLabel];

    // imageView
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 60, 94, 50, 50)];
    if (self.service.kindId == 3) {
        // operadora
        self.imageView.image = [UIImage imageNamed:NSLocalizedString(@"icon_operator",nil)];
        [self.view addSubview:self.imageView];
    }
    else if (self.service.scheduleType > 0) {
        if (self.service.scheduleType == 1) {
            self.imageView.image = [UIImage imageNamed:NSLocalizedString(@"icon_aero",nil)];
        }
        else if (self.service.scheduleType == 2) {
            self.imageView.image = [UIImage imageNamed:NSLocalizedString(@"icon_outside",nil)];
        }
        else if (self.service.scheduleType == 3) {
            self.imageView.image = [UIImage imageNamed:NSLocalizedString(@"icon_courier",nil)];
        }
        else if (self.service.scheduleType == 4) {
            self.imageView.image = [UIImage imageNamed:NSLocalizedString(@"icon_hours",nil)];
        }
        [self.view addSubview:self.imageView];
    }
    self.addressLabel.text = self.service.addressService;
    self.neighborhoodLabel.text = self.service.neighborhood;

    if (self.service.observation != nil) {
        self.observationLabel.text = self.service.observation;
    }
    else {
        self.observationLabel.text = @"";
    }

    self.destinationLabel.text = (self.service.destination != nil) ? self.service.destination : @"";
    self.userNameLabel.text = self.service.userName;

    NSLog(@"map viewWillAppear");
    self.location = [self.locationManager location];

    double lat = self.service.latitude;
    double lng = self.service.longitude;

    // map
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lng
                                                                 zoom:16];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 174, screenWidth, screenHeight - 174) camera:camera];
    self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.rotateGestures = YES;

    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = @"Hello World";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = [UIImage imageNamed:@"taxista"];
    marker.map = self.mapView;
    [self.view addSubview:self.mapView];

    // button
    self.finishButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2) - ((screenWidth - 20) / 2), screenHeight - 60, screenWidth - 20, 50)];
    [self.finishButton setTitle:NSLocalizedString(@"finish_button",nil) forState:UIControlStateNormal];
    [self.finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.finishButton setBackgroundColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha: 1.0f]];
    [self.finishButton addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.finishButton setHidden:YES];
    [self.view addSubview:self.finishButton];

    // arrive
    self.arriveButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2) - ((screenWidth - 30) / 2) - 5, screenHeight - 60, (screenWidth - 30) / 2 , 50)];
    [self.arriveButton setTitle:NSLocalizedString(@"arrive_button",nil) forState:UIControlStateNormal];
    [self.arriveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.arriveButton setBackgroundColor:[UIColor colorWithRed:0.251 green:0.702 blue:0.314 alpha:1]]; //#40b350
    [self.arriveButton addTarget:self action:@selector(arriveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.arriveButton];

    // cancel
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2)+5, screenHeight - 60, (screenWidth - 30) / 2, 50)];
    [self.cancelButton setTitle:NSLocalizedString(@"cancel_button",nil) forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    [self.cancelButton setHidden:YES];
    [self.arriveButton setHidden:YES];

    NSLog(@"MapViewController viewWillAppear service: %@",self.service);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSString *serviceId = [NSString stringWithFormat:@"%ld",self.service.serviceId];
    NSDictionary *params = @{@"driver_id":driverId, @"service_id":serviceId};
    NSLog(@"serviceConfirm params %@", params);

    NSLog(@"call confirmService + %@",[NSDate date]);
    int min = 410;
    int max = 1500;
    int randomNumber = min + rand() % (max-min);
    float d = (float)randomNumber / 1000.0f;
    self.isRecover = YES;
    NSLog(@"confirmService delay %f %li",d , self.service.statusId);
    if (self.service.statusId == 2) {
        [self.cancelButton setHidden:NO];
        [self.arriveButton setHidden:NO];
    }
    else if (self.service.statusId == 4) {
        [self.cancelButton setHidden:YES];
        [self.arriveButton setHidden:YES];
        [self.finishButton setHidden:NO];
    }
    else {
        self.isRecover = NO;
        [self performSelector:@selector(confirmService:) withObject:params afterDelay:d];
    }

    // start timer send position +
    [self.timerPosition invalidate];
    self.timerPosition = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(updatePosition) userInfo:nil repeats:YES];

    // start timer send position -

}

-(void)updatePosition {
    NSLog(@"updatePosition");
    ApiTaxisya *api = [ApiTaxisya sharedInstance];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    
    NSString *lat = [NSString stringWithFormat:@"%f", self.location.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f",   self.location.coordinate.longitude];

    // send position de driver
    NSDictionary *params = @{@"driver_id":driverId,
                             @"lat": lat,
                             @"lng": lng};
    NSLog(@"updatePosition %@", params);

    [api driverSendPosition:params success:^(BOOL success, id response) {
        if (success) {
            NSLog(@"updatePosition ok %@",response);

        }
        else {
            NSLog(@"updatePosition error %@",response);
        }

    }];

}

-(void)confirmService:(NSDictionary *) params {
    NSLog(@"call confirmService - %@",[NSDate date]);
    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api serviceConfirm:params success:^(BOOL success, id response) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)response;
            NSLog(@"sendConfirmation response: %@",dictionary);
            NSLog(@"      status %@",[dictionary objectForKey:@"success"]);
            NSLog(@"      error %@",[dictionary objectForKey:@"error"]);
            NSLog(@"       status %@",dictionary[@"success"]);
            NSLog(@"       error %@",dictionary[@"error"]);
            NSString *stringSuccess = dictionary[@"success"];
            NSString *stringError = dictionary[@"error"];

            long s = [stringSuccess integerValue];
            long e = [stringError integerValue];

            NSLog(@"success = %ld", s);
            NSLog(@"error = %ld", e);

            if ((s == 0) && (e == 404)) {
                NSLog(@"error = 404  servicio tomado por otro auto");
                [self showAnotherDriverAlert];
            }
            if (e == 1) {
                // servicios cancelado por sistema o usuario
                NSLog(@"hay un servicio tomado con anterioridad");
                [self.timer invalidate];
                [self.navigationController popViewControllerAnimated:YES];//
            }

            if (e == 0) {
                NSLog(@"sendConfirmation error: 0 %@",response);
                [self.cancelButton setHidden:NO];
                [self.arriveButton setHidden:NO];
            }
//            if (s == 0) {
//                // show buttons
//                NSLog(@"sendConfirmation error: 1 %@",response);
//                [self.cancelButton setHidden:NO];
//                [self.arriveButton setHidden:NO];
//            }
        }
        else {
            NSLog(@"sendConfirmation error: %@",response);
            [self showAnotherDriverAlert];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks - Actions
-(void)arriveAction:(id)sender {
    NSLog(@"arriveAction -");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSString *serviceId = [NSString stringWithFormat:@"%ld",self.service.serviceId];
    //NSDictionary *params = @{@"driver_id":driverId};
    NSDictionary *params = @{@"driver_id":driverId, @"service_id":serviceId };

    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api driverArrived:params success:^(BOOL success, id response) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)response;
            NSLog(@"driverArrived response: %@",dictionary);

            long error = [[dictionary objectForKey:@"error"] integerValue];

            if (!error) {
                [self.cancelButton setHidden:YES];
                [self.arriveButton setHidden:YES];
                [self.finishButton setHidden:NO];
            }
            else {
                NSLog(@"El servicio no se pudo confirmar");
                if (error >=6) {
                    NSLog(@"El servicio estaba cancelado");

                    [self.timer invalidate];

                    if (_delegate && [_delegate respondsToSelector:@selector(showToastWhenServiceCancelled:)]) {
                        [_delegate showToastWhenServiceCancelled:error];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
        else {
            [self.view makeToast:NSLocalizedString(@"error_arrived",nil)];
            NSLog(@"driverArrived error: %@",response);
        }
    }];
}

-(void)cancelAction:(id)sender {
    NSLog(@"cancelAction -");
    [self showCancelAlert];
}

-(void)sendUnits:(id)sender{

    UIAlertController *alert= [UIAlertController
    alertControllerWithTitle:@"Importante"
    message:@"Digita las unidades superiores a 28"
    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Enviar" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action){
    UITextField *textField = alert.textFields[0];
    NSLog(@"text was %@", textField.text);
    }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)unitsValidator:(id)sender{
    NSLog(@"unitsValidator -");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSString *serviceId = [NSString stringWithFormat:@"%ld",self.service.serviceId];
    NSString *lat = [NSString stringWithFormat:@"%f", self.location.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f",   self.location.coordinate.longitude];
    
#if TARGET_IPHONE_SIMULATOR
    lat = @"4.7434892";
    lng = @"-74.0572775";
#endif
    //[self readServices];
    NSDictionary *params = @{@"driver_id":driverId,
                             @"service_id": serviceId,
                             @"to_lat":lat,
                             @"to_lng":lng};
    NSLog(@"params %@",params);
    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api serviceFinish:params success:^(BOOL success, id response) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)response;
            NSLog(@"serviceFinish response: %@",dictionary);
            
            [self.timer invalidate];
            
            // marcar estado servicio
            long index = [self.servicesArray indexOfObject:self.service];
            
            self.service.statusId = 5;
            [self.servicesArray replaceObjectAtIndex:index withObject:self.service];
            
            [self saveServices];
        }
        else {
            [self.view makeToast:NSLocalizedString(@"error_finish",nil)];
            
            NSLog(@"serviceFinish error: %@",response);
        }
        [self.timer invalidate];
        
        // check si servicio es
        if (self.isRecover) {
            [self.locationManager stopUpdatingLocation];
            self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            
            ServicesViewController *servicesVC = [[ServicesViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:servicesVC animated:NO];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
}

-(void)finishAction:(id)sender {
    
    NSLog(@"finishAction -");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSString *serviceId = [NSString stringWithFormat:@"%ld",self.service.serviceId];
    NSString *lat = [NSString stringWithFormat:@"%f", self.location.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f",   self.location.coordinate.longitude];

#if TARGET_IPHONE_SIMULATOR
    lat = @"4.7434892";
    lng = @"-74.0572775";
#endif
    //[self readServices];
    NSDictionary *params = @{@"driver_id":driverId,
                             @"service_id": serviceId,
                             @"to_lat":lat,
                             @"to_lng":lng};
    NSLog(@"params %@",params);
    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api serviceFinish:params success:^(BOOL success, id response) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)response;
            NSLog(@"serviceFinish response: %@",dictionary);

            [self.timer invalidate];

            // marcar estado servicio
            long index = [self.servicesArray indexOfObject:self.service];

            self.service.statusId = 5;
            [self.servicesArray replaceObjectAtIndex:index withObject:self.service];

            [self saveServices];
        }
        else {
            [self.view makeToast:NSLocalizedString(@"error_finish",nil)];

            NSLog(@"serviceFinish error: %@",response);
        }
        [self.timer invalidate];

        // check si servicio es
        if (self.isRecover) {
                [self.locationManager stopUpdatingLocation];
                self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

                ServicesViewController *servicesVC = [[ServicesViewController alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:servicesVC animated:NO];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }

    }];

}

- (void)goBack:(UIBarButtonItem *)sender
{
    [self showCancelAlert];
}

-(void)showCancelAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_title",nil)
        message:NSLocalizedString(@"alert_message",nil)
        delegate:self
        cancelButtonTitle:NSLocalizedString(@"alert_no",nil)
        otherButtonTitles:NSLocalizedString(@"alert_yes",nil), nil];
    [alert show];
}

-(void)showAnotherDriverAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_title",nil)
        message:NSLocalizedString(@"alert_message_another_driver",nil)
        delegate:self
        cancelButtonTitle:NSLocalizedString(@"alert_accept",nil)
        otherButtonTitles:nil, nil];
    alert.tag = 2000;
    [alert show];
}

-(void)cancelService {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSDictionary *params = @{@"driver_id":driverId};

    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api driverCancelService:params success:^(BOOL success, id response) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)response;
            NSLog(@"driverCancelService response: %@",dictionary);
        }
        else {
            NSLog(@"driverCancelService error: %@",response);
        }

        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     long tag = alertView.tag;
     if (tag == 2000) {

         long index = [self.servicesArray indexOfObject:self.service];

         self.service.statusId = 10;
         [self.servicesArray replaceObjectAtIndex:index withObject:self.service];

         [self saveServices];


         [self.navigationController popViewControllerAnimated:YES];
     }

    switch(buttonIndex) {
        case 0: //"No" pressed
            break;
        case 1: //"Yes" pressed
            [self cancelService];
            break;
    }
}

#pragma mark - statusService
-(void) checkStatusService {

    NSLog(@"checkStatusService");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSString *serviceId = [NSString stringWithFormat:@"%ld",self.service.serviceId];
    NSDictionary *params = @{@"driver_id":driverId, @"service_id":serviceId};
    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    
    NSLog(@"checkStatusService - %@ %@",driverId, serviceId);
    [api serviceStatus:params success:^(BOOL success, id response) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)response;
            NSLog(@"serviceStatus response: service_id: %@ status_id %@",
                  dictionary[@"id"],
                  dictionary[@"status_id"]);

            long statusId = [dictionary[@"status_id"] integerValue];

            if (statusId >=6) {
                NSLog(@"service cancelado");
                [self.timer invalidate];

                // show toast
                if (statusId != 8) {
                    if (_delegate && [_delegate respondsToSelector:@selector(showToastWhenServiceCancelled:)]) {
                        [_delegate showToastWhenServiceCancelled:statusId];
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            NSLog(@"serviceStatus error: %@",response);
        }
    }];
}

#pragma mark - CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{

    self.location = [locations lastObject];
    [self makePointsInMap:self.location.coordinate];
}

#pragma mark - Utils
-(void)readServices {
    self.servicesArray = [[NSMutableArray alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.servicesArray = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"services"]] ;
    NSLog(@"  readServices %ld",(unsigned long)[self.servicesArray count]);
}

-(void)saveServices {
    // save array
    NSLog(@"    saveServices");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.servicesArray];
    [defaults setObject:data forKey:@"services"];
    [defaults synchronize];
}

#pragma marks - Maps
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:
(CLLocationCoordinate2D)coordinate {
    NSLog(@"======================================================");
    [self makePointsInMap:coordinate];
}

-(void)makePointsInMap:(CLLocationCoordinate2D)coordinate {
    NSLog(@"======================================================");
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                 coordinate.latitude,
                                                                 coordinate.longitude);

    CLLocationCoordinate2D position2 = CLLocationCoordinate2DMake(self.service.latitude, self.service.longitude);

    NSLog(@"makePointsInMap - origen %f %f",coordinate.latitude, coordinate.longitude);
    NSLog(@"makePointsInMap - destino %f %f",self.service.latitude, self.service.longitude);
    //NSLog(@" position %@",position);
    NSLog(@" position %f %f",position.latitude, position.longitude);

    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    GMSMarker *marker2 = [GMSMarker markerWithPosition:position2];

    marker.map = self.mapView;
    [waypoints_ addObject:marker];
    [waypoints_ addObject:marker2];

    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                coordinate.latitude,coordinate.longitude];

    NSString *positionString2 = [[NSString alloc] initWithFormat:@"%f,%f",
                                self.service.latitude,self.service.longitude];

    [waypointStrings_ addObject:positionString];
    [waypointStrings_ addObject:positionString2];

    NSLog(@"positionString %i %@ %@", [waypoints_ count], positionString, positionString2);

    if([waypoints_ count]>1){
        NSLog(@"waypoints_ 1");

        NSString *sensor = @"false";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters forKeys:keys];
        DirectionService *mds=[[DirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query withSelector:selector withDelegate:self];
    }
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    // agregar two points

    bounds = [bounds includingCoordinate:marker.position];

    bounds = [bounds includingCoordinate:marker2.position];

    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
}

- (void)addDirections:(NSDictionary *)json {

    NSDictionary *routes = [json objectForKey:@"routes"][0];

    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];

    polyline.spans = @[[GMSStyleSpan spanWithColor:[UIColor redColor]]];

    polyline.strokeWidth = 6;
    polyline.strokeColor = [UIColor greenColor];
    polyline.map = self.mapView;
}

@end
