//
//  NewAddressVC.m
//  taxisya
//
//  Created by Leonardo Rodriguez on 10/25/15.
//  Copyright © 2015 imaginamos. All rights reserved.
//

#import "NewAddressVC.h"
#import "UIView+FormScroll.h"
#import "JSON.h"

@interface NewAddressVC ()

@end

@implementation NewAddressVC {
    GMSGeocoder *geocoder_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    self.view.backgroundColor = [UIColor whiteColor];
    // create view
    _locationManager = [LocationManager sharedInstance];
    _locationManager.delegate = self;
     [_locationManager startUpdatingLocation];

    // address
    self.addressField = [[UITextField alloc] initWithFrame:CGRectMake(15, screenHeight - 180, screenWidth -30, 38)];
    self.addressField.borderStyle = UITextBorderStyleRoundedRect;
    self.addressField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.addressField setPlaceholder:NSLocalizedString(@"new_address_address",nil)];
    self.addressField.delegate = self;
    self.addressField.clearButtonMode = UITextFieldViewModeWhileEditing;

    [self.addressField setBackgroundColor:[UIColor whiteColor]];
    self.addressField.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_gps_n"]];
    [self.addressField setLeftViewMode: UITextFieldViewModeAlways];
    [self.view addSubview:self.addressField];


    // name
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(15, screenHeight - 138, screenWidth - 30, 38)];
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.nameField setPlaceholder:NSLocalizedString(@"new_address_name",nil)];
    self.nameField.delegate = self;
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_name_n"]];
    [self.nameField setLeftViewMode: UITextFieldViewModeAlways];
    [self.view addSubview:self.nameField];


    // comment
    self.commentField = [[UITextField alloc] initWithFrame:CGRectMake(15, screenHeight - 96, screenWidth -30, 38)];
    self.commentField.borderStyle = UITextBorderStyleRoundedRect;
    self.commentField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.commentField setPlaceholder:NSLocalizedString(@"new_address_comment",nil)];
    self.commentField.delegate = self;
    self.commentField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.commentField.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_detail_n"]];
    [self.commentField setLeftViewMode: UITextFieldViewModeAlways];
    [self.view addSubview:self.commentField];

    // button
    // button login
    self.buttonAdd = [[UIButton alloc] initWithFrame:CGRectMake(15, screenHeight - 54, screenWidth - 30, 50)];
    [self.buttonAdd setTitle:NSLocalizedString(@"new_address_button_add",nil) forState:UIControlStateNormal];
    [self.buttonAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonAdd setBackgroundColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]];
    [self.buttonAdd addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonAdd];


    // map
    double lat = 4.75;
    double lng = -74.057;


    float heightPointer = screenHeight - 180 - 47 - 4;
    float partial = heightPointer / 2;
    float pointerY = partial - 41;
    // map
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lng
                                                                 zoom:16];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 47, screenWidth, heightPointer) camera:camera];
    //self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;

    self.mapView.delegate = self;

    [self.view addSubview:self.mapView];

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
    [btn setCenter:CGPointMake(_mapView.frame.size.width - 30, _mapView.frame.origin.y - 16)];

    [btn addTarget:self action:@selector(didTapMyLocation) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:btn];

    // agrega puntero para el mapa
    self.pointerMap = [[UIImageView alloc] initWithFrame:
                       CGRectMake(self.view.bounds.size.width/2 - 41,47 + pointerY,81, 81)];
    [self.pointerMap setImage:[UIImage imageNamed:@"pointer"]];
    [self.view addSubview:self.pointerMap];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard) name:@"push_hide_keyboard" object:nil];

}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_locationManager stopUpdatingLocation];
}

-(void)viewDidUnload {
    _locationManager.delegate = nil;
    _locationManager = nil;
}

-(void)didTapMyLocation {
    NSLog(@"didTapMyLocation ");

    CLLocation *location = self.mapView.myLocation;
    if (location) {
        [self.mapView animateToLocation:location.coordinate];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)show {

    [self show:YES];

}

-(void)show:(BOOL)show {
    NSLog(@"NewAddressVC show");
    if (show) {
        [UIView animateWithDuration:0.3
                         animations:^(void){

                             self.view.alpha = 1;

                         }
                         completion:^(BOOL f){


                         }];
        [self startObservingKeyboard];
    }
    else {
        NSLog(@"SALE DEL SHOW MY ADRESSES ---------------------");

        [UIView animateWithDuration:0.3 animations:^(void){

            self.view.alpha     = 0;
            //             self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);

        }completion:^(BOOL f){

            //[_delegate LoadingVWHaveService:_serviceAreFounded];

        }];
        [self stopObservingKeyboard];
    }
}

- (IBAction)goBack:(id)sender {
    NSLog(@"NewAddressVC goBack");
    //[self show:NO];
    [self.navigationController popViewControllerAnimated:YES];
    //    [_delegate addressSelected];
}

-(void)hideKeyboard {
    [self.view endEditing:YES];
}

-(void)addAction:(id)sender {
    NSLog(@"addAction === ");

    // obtener datos de los UITextField


    // obtener lat y lng


    // enviar direccion

    /*
    [self initServiceIfNeeded];

    [_tysTaxi requestTaxiType2:TYSTaxiTypeRequestService
                        object:address
                        barrio:_barrioAddress
                       latitud:_latitudeAddress
                      longitud:_longitudeAddress];

    */

//    if(!_tysUsser){
//
//        self.tysUsser = [[TYSUsser alloc] initwithDelegate:self];
//
//    }
   // [_tysUsser requestUsserType:TYSUsserTypeOldAddress object:nil];

    if(!_tysTaxi)
    {

        self.tysTaxi = [[TYSTaxi alloc] initwithDelegate:self];

    }

    NSString *strBarrio = self.barrioAddress;
    NSString *strAddress = self.addressField.text;
    NSString *strName = self.nameField.text;
    NSString *strComment = self.commentField.text;
    NSString *strLat = _latitudeAddress;
    NSString *strLng = _longitudeAddress;

    [_tysTaxi createAddress:strAddress barrio:strBarrio
                          obs:strComment order:@"1"
                         name:strName lat:strLat lng:strLng];


}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma marks - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");

    [self.view scrollToView:textField];

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");

    [self.view scrollToY:0];
    [textField resignFirstResponder];

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
    NSLog(@"notifyThatKeyboardWillAppear");

    self.mapView.userInteractionEnabled = NO;

}

-(void)notifyThatKeyboardWillDissappear:(NSNotification *) notification {
    NSLog(@"notifyThatKeyboardWillDissappear");
    self.mapView.userInteractionEnabled = YES;

}


//#pragma mark - CLLocationManager Delegate
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"Error en la Location %@", error.userInfo);
//    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TaxisYa necesita su ubicación actual" message:@"Con el fin de ofrecer un mejor servicio, TaxisYA requiere la información de ubicación actual." delegate:nil cancelButtonTitle:@"Entendido" otherButtonTitles:nil];
//    //    [alertView show];
//}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    //    NSLog(@"ANTES DEL ANIMATE MAP 2");
//    //    [self animateMapToCoordenate:manager.location];
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
//    NSLog(@"Error Deferred en la Location %@", error.userInfo);
//}


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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
-(void)updateFullAddress:(CLLocation *)location {
    GMSReverseGeocodeCallback handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        NSLog(@"updateFullAddress handle 1 %@",response);
        if (response && response.firstResult) {
            if(response.results && response.results.count > 2){
                GMSReverseGeocodeResult *item = [response.results objectAtIndex:1];

                NSString *neighborhood = @"";

                if (item) neighborhood = [NSString stringWithFormat:@"%@", item.addressLine1];
                NSLog(@"barrio %@", neighborhood);
                _barrioAddress = neighborhood;

                _latitudeAddress = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
                _longitudeAddress = [NSString stringWithFormat:@"%f",location.coordinate.longitude];



                NSLog(@"%@",response.firstResult.addressLine1);
                NSLog(@"-- %@",response.firstResult.administrativeArea );

                NSString *shortString = response.firstResult.addressLine1;
                if ([shortString containsString:@" a "]) {
                    shortString = [shortString substringToIndex:[shortString rangeOfString:@" a "].location];
                }

                if ([shortString containsString:@"-"]) {
                    shortString = [shortString substringToIndex:[shortString rangeOfString:@"-"].location];
                    [self.addressField setText:[NSString stringWithFormat:@"%@-",shortString]];

                }
                else {
                    [self.addressField setText:shortString];
                }

            }else{
                [self.addressField setText:[NSString stringWithFormat:@"%@ %@",response.firstResult.addressLine1, response.firstResult.addressLine2] ];
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


- (void)TYSUsserType:(TYSUsserType)type response:(NSString *)response status:(ServiceStatus)status{

    if(type == TYSUsserTypeOldAddress){

        if(status == ServiceStatusOk){

            NSMutableDictionary *dic = [response JSONValue];

            if(dic && dic.count){

                NSString *error = [dic objectForKey:@"error"];

                if(error && [error isEqualToString:@"1"]){

                }else{

                }

            }
        }

    }

}

- (void)TYSTaxiType:(TYSTaxiType)type response:(NSString *)response status:(ServiceStatus)status{
    NSLog(@" RESPUESTA :: %@", response);
    if (type == TYSCreateAddress) {
        if (status == CreateAddressStatusOk) {
            NSMutableDictionary *values = [response JSONValue];
            if (values) {
                //[self makeLogicRequestService:values];
                //[self show:NO];
                [self.navigationController popViewControllerAnimated:YES];
                [_delegate newAddressSaved];
            }
        }
    }
}

#pragma <LocationUpdateProtocol>
-(void)locationDidUpdateToLocation:(CLLocation *)location {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:(-5 * 3600)];
    [dateFormatter setTimeZone:timeZone];

    NSLog(@"NewAddress locationDidUpdateToLocation %f %f %@",location.coordinate.latitude,location.coordinate.longitude,
          [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]]);

    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    [self.mapView setCamera:[GMSCameraPosition cameraWithTarget:coord1 zoom:16]];
    [_locationManager stopUpdatingLocation];
}

@end
