//
//  ServicesViewController.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/4/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "ServicesViewController.h"
#import "ApiTaxisya.h"
#import "ServiceTableViewCell.h"
#import "MapViewController.h"
#import "LocationManager.h"
#import "Service.h"
#import "UIView+Toast.h"

@interface ServicesViewController ()
{
    UIControl   *backCover;
    BOOL        inhibitBackButtonBOOL;
    int  secondsCounter;
}

@end

@implementation ServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ServicesViewController viewDidLoad w: %f h: %f ",self.view.frame.size.width, self.view.frame.size.height);
    self.dataSource = [[NSMutableArray alloc] init];

    self.firstTime = YES;

    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ( ((status == kCLAuthorizationStatusAuthorized) || (status == kCLAuthorizationStatusNotDetermined))
        && [CLLocationManager locationServicesEnabled]) {

        // Tenemos acceso a localización
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];

        self.location = [self.locationManager location];

    }
    else { // verificar
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];

    }

    self.synthesizer = [[AVSpeechSynthesizer alloc]init];


}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Cover the back button (cannot do this in viewWillAppear -- too soon)
    if ( backCover == nil ) {
        backCover = [[UIControl alloc] initWithFrame:CGRectMake( 0, 0, 80, 44)];
#if TARGET_IPHONE_SIMULATOR
        // show the cover for testing
        //backCover.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.15];
#endif
        [backCover addTarget:self action:@selector(disableAction:) forControlEvents:UIControlEventTouchDown];
        UINavigationBar *navBar = self.navigationController.navigationBar;
        [navBar addSubview:backCover];
    }
    NSLog(@"ServiceViewController viewDidAppear");

    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                  target:self
                                                selector:@selector(getServices)
                                                userInfo:nil
                                                 repeats:YES];

//    self.timerSpeak = [NSTimer scheduledTimerWithTimeInterval:20.0
//                                                  target:self
//                                                selector:@selector(speakAddressSecond)
//                                                userInfo:nil
//                                                 repeats:YES];
//    [self.timerSpeak invalidate];

    if (self.serviceCancelled) {
        NSString *msg = nil;

        switch (self.serviceCancelled) {
            case 6:
                msg = NSLocalizedString(@"user_cancel",nil);
                break;

            default:
                msg = NSLocalizedString(@"service_cancel",nil);
                break;
        }
        [self.view makeToast:msg];
    }

}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    [self readServices];

    // title

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 34)];
    }
    else {
        // prueba iPad +
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 54)];
        // prueba iPad -
    }
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 34)];
    NSString *stringTitle = [NSString stringWithFormat:@"%@ %@",
                             NSLocalizedString(@"title_services_first",nil),
                             NSLocalizedString(@"title_services_last",nil)];
    [self.titleLabel setTextColor:[UIColor grayColor]];
    [self.titleLabel setText:stringTitle];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.titleLabel setFont:[self.titleLabel.font fontWithSize:30]];
    }
    else {
        [self.titleLabel setFont:[self.titleLabel.font fontWithSize:48]];
    }
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
     initWithAttributedString: self.titleLabel.attributedText];

    // set color for last title
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]
                 range:NSMakeRange([NSLocalizedString(@"title_services_first",nil) length] + 1, [NSLocalizedString(@"title_services_last",nil) length])];
    [self.titleLabel setAttributedText: text];
    [self.view addSubview:self.titleLabel];

    // table view
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 98, screenWidth, screenHeight - 98)];
    }
    else {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, screenWidth, screenHeight - 120)];
    }
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[ServiceTableViewCell class] forCellReuseIdentifier:@"CellService"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // button
    self.disableButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2) - ((screenWidth - 20) / 2), screenHeight - 60, screenWidth - 20, 50)];

    [self.disableButton setTitle:NSLocalizedString(@"disable_button",nil) forState:UIControlStateNormal];
    [self.disableButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.disableButton setBackgroundColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]];
    [self.disableButton addTarget:self action:@selector(disableAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.disableButton];

    [self.tableView reloadData];

    if (self.isMovingToParentViewController == NO) {
        //
        NSLog(@"");

        self.dataSource = nil;

        [self.tableView reloadData];

        [self enable];

        [self speakAddressFirst];

    }

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    [self.timerSpeak invalidate];
    self.timer = nil;
    self.timerSpeak = nil;
    [self stopSpeech];

    [self saveServices];
}

-(void)parseServices:(NSDictionary *)dictionary {
    NSMutableArray *newServicesArray = [[NSMutableArray alloc] init];
    for (NSDictionary *d in dictionary[@"services"]) {

        NSString *strObservation = d[@"obs"];


        Service *service = [[Service alloc] initWithObject:[d[@"service_id"] integerValue]
                                              address:d[@"address"]
                                         neighborhood:d[@"barrio"]
                                          destination:(d[@"destination"] != [NSNull null]) ? d[@"destination"] : nil
                                          observation:(d[@"obs"] != [NSNull null]) ? d[@"obs"] : nil
                                             latitude:[d[@"lat"] floatValue]
                                            longitude:[d[@"lng"] floatValue]
                                               kindId:(int)[d[@"kind_id"] integerValue]
                                         scheduleType:(int)[d[@"schedule_type"] integerValue]
                                      serviceDateTime:(d[@"service_date_time"] != [NSNull null]) ? d[@"service_date_time"] : nil
                                             userName:d[@"username"]
                                                    status:0];

        float lat = [d[@"lat"] floatValue];
        float lng = [d[@"lng"] floatValue];

        NSLog(@"parseServices - %ld obs %@",[d[@"service_id"] integerValue] ,d[@"obs"]);

        if ([self getDistance:self.location.coordinate.latitude
                     lng1:self.location.coordinate.longitude
                     lat2:lat
                         lng2:lng]) {
            [newServicesArray addObject:service];
        }
    }

    // check if new in services
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    if ([self.servicesArray count] > 0) {
        for (Service *s in newServicesArray) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serviceId == %ld", s.serviceId];
            filteredArray = [NSMutableArray arrayWithArray:[self.servicesArray filteredArrayUsingPredicate:predicate]];

            if ([filteredArray count] > 0) {
                // already exist
//                NSLog(@"        esta en servicesArray %ld %ld %i %@ %i",
//                      [filteredArray count],
//                      (long)[[filteredArray objectAtIndex:0] serviceId],
//                      (int)[[filteredArray objectAtIndex:0] statusId],
//                      [[filteredArray objectAtIndex:0] addressService],
//                      [[filteredArray objectAtIndex:0] kindId]);
            }
            else {
                // not exist, add service
                [self.servicesArray addObject:s];

                // probar
                //[self speakAddress];

            }
        }

        // check services to erase
        for (Service *f in self.servicesArray) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serviceId == %ld AND statusId == 1", f.serviceId];
            filteredArray = [NSMutableArray arrayWithArray:[newServicesArray filteredArrayUsingPredicate:predicate]];

            if ([filteredArray count] > 0) {
                //
            }
            else { // if not exists, change status to cancel
                f.statusId = 7;
            }
        }
    }
    else { // no hay servicios almacenados
        self.servicesArray = [NSMutableArray arrayWithArray:newServicesArray];
    }

    // filter array con status 1
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"statusId == 1"];
    //NSMutableArray *filteredArray = [[NSMutableArray alloc] init];

    filteredArray = [NSMutableArray arrayWithArray:[self.servicesArray filteredArrayUsingPredicate:predicate]];
    if ([filteredArray count] > 0) {
        NSArray *sortedArray = [filteredArray sortedArrayUsingComparator:^NSComparisonResult(Service *s1, Service *s2){
            return (s1.serviceId < s2.serviceId);
        }];
        self.dataSource = sortedArray;
    }
    else {
        self.dataSource = nil;
    }

    [self.tableView reloadData];

}

-(BOOL)getDistance:(float)lat1 lng1:(float)lng1 lat2:(float)lat2 lng2:(float)lng2 {

    CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];

    CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];

    CLLocationDistance distance = [locA distanceFromLocation:locB];

    NSLog(@"getDistance %lf",distance);

    // validar rango horario para distancias (22:00 a 05:00)
    if ([self isNightMode]) {
        if (distance <= 5000.0) return YES;
    }
    else
         if (distance <= 2000.0) return YES;

    return NO;
}


-(BOOL)isNightMode {

    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:(-5 * 3600)];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    df.timeZone = timeZone;
    NSString *strDate3 = [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]];
    //NSString *strDate3 = @"05:01";
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *nowDate = [df dateFromString:strDate3];
    NSDate *fromDate = [df dateFromString:@"22:00"];
    NSDate *toDate = [df dateFromString:@"05:00"];

    // if time is another day
    if ([nowDate compare:toDate] == NSOrderedAscending) {
        // add one day
        nowDate = [nowDate dateByAddingTimeInterval:60*60*24*1];
    }
    // add one day
    toDate = [toDate dateByAddingTimeInterval:60*60*24*1];
    if ([self date:nowDate isBetweenDate:fromDate andDate:toDate]) {
        NSLog(@"============ modo nocturno");
        return YES;
    }
    return NO;
}

-(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;

    if ([date compare:endDate] == NSOrderedDescending)
        return NO;

    return YES;
}

-(void)disableAction:(id)sender {

    NSLog(@"disableAction");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSString *uuid = [defaults objectForKey:@"uuid"];
    NSDictionary *params = @{@"driver_id":driverId, @"uuid":uuid};

    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api driverDisable:params success:^(BOOL success, id response) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)response;
            NSLog(@"driverDisable response: %@",dictionary);
        }
        else {
            NSLog(@"driverDisable error: %@",response);
        }

        NSLog(@"disableAction finish");
        [self.navigationController popToRootViewControllerAnimated:YES];

    }];
}

-(BOOL)textToSpeech:(NSString *) message {
    self.synthesizer = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:message];
    [utterance setRate:0.5f];
    if ([self.synthesizer isSpeaking]) {
        NSLog(@"        esta speak");
        return YES;
    }
    [self.synthesizer speakUtterance:utterance];
    return NO;
}

-(BOOL)textToSpeech2:(NSString *) message {

    if (self.synthesizer.speaking == NO) {
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:message];
         [utterance setRate:0.5f];

        [self.synthesizer speakUtterance:utterance];
    }
    return YES;
}

- (void)stopSpeech
{
    NSLog(@"stopSpeak");
    //AVSpeechSynthesizer *talked = self.synthesizer;
    if([self.synthesizer isSpeaking]) {
        NSLog(@"stopSpeak isSpeaking");
        [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
        [self.synthesizer speakUtterance:utterance];
        [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        self.synthesizer = nil;
        [self.timerSpeak invalidate];
        self.timerSpeak = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return 116;
    }
    return 143;;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CellService";

    ServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    Service *s = self.dataSource[indexPath.row];
    if ([s.addressService isEqual:[NSNull null]]) {
        cell.addressLabel.text = @"sin dato";
    }
    else
        cell.addressLabel.text = s.addressService;

    // add observation
    cell.neighborhoodLabel.text = s.neighborhood;
//    if (s.observation != nil) {
//        cell.observationLabel.text = s.observation;
//    }
//    else {
//        cell.observationLabel.text = @"";
//    }

    cell.destinationLabel.text = (s.destination != nil) ? s.destination : @"";
    cell.userNameLabel.text = s.userName;

    [cell.layer setCornerRadius:7.0f];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:1.0f];
    if (s.kindId == 3) {
        // operadora
        cell.iconImageView.image = [UIImage imageNamed:NSLocalizedString(@"icon_operator",nil)];
        cell.iconImageView.hidden = NO;
    }
    else if (s.scheduleType > 0) {
        cell.iconImageView.hidden = NO;
        if (s.scheduleType == 1) {
            cell.iconImageView.image = [UIImage imageNamed:NSLocalizedString(@"icon_aero",nil)];
        }
        else if (s.scheduleType == 2) {
            cell.iconImageView.image = [UIImage imageNamed:NSLocalizedString(@"icon_outside",nil)];
        }
        else if (s.scheduleType == 3) {
            cell.iconImageView.image = [UIImage imageNamed:NSLocalizedString(@"icon_courier",nil)];
        }
        else if (s.scheduleType == 4) {
            cell.iconImageView.image = [UIImage imageNamed:NSLocalizedString(@"icon_hours",nil)];
        }
        else {
            cell.iconImageView.hidden = YES;
        }
        if (s.serviceDateTime != nil) {
            NSString *strTime = s.serviceDateTime;
            strTime = [strTime substringToIndex:16];
            if ([strTime length] > 15) {
                NSArray *strTmp = [strTime componentsSeparatedByString:@" "];
                //NSString *strDay = [strTmp objectAtIndex:0];
                NSString *strHour = [strTmp objectAtIndex:1];
                NSLog(@"= strTime %@",strHour);
                
                NSString *strTime = @"2016-06-23 16:30:00";
                NSLog(@"= strTime %@",strTime);
                strTime = [strTime substringToIndex:16];
                
                cell.observationLabel.text = [NSString stringWithFormat:@"Hora %@ %@",strHour, s.observation];
            }
            else {
                cell.observationLabel.text = s.observation;
            }
        }
        else {
            if (s.observation != nil) {
                cell.observationLabel.text = s.observation;
            }
            else {
                cell.observationLabel.text = @"";
            }
        }
        
    }
    else {

        cell.iconImageView.hidden = YES;
        if (s.observation != nil) {
            cell.observationLabel.text = s.observation;
        }
        else {
            cell.observationLabel.text = @"";
        }
    }
    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }
    cell.separatorInset = UIEdgeInsetsMake(0.0f, cell.frame.size.width, 0.0f, 0.0f);

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath %ld",(long)indexPath.row);

    // get driver_id
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];

    NSString *serviceId = [NSString stringWithFormat:@"%ld",
                               [self.dataSource[indexPath.row] serviceId]];
    // save service id
    [defaults setObject:serviceId forKey:@"service_id"];
    [defaults synchronize];

    NSDictionary *params = @{@"driver_id":driverId, @"service_id":serviceId};
    Service *s = self.dataSource[indexPath.row];
    NSLog(@"serviceConfirm params %@", params);

    [self.timer invalidate];
    [self.timerSpeak invalidate];

    long index = [self.servicesArray indexOfObject:s];

    //s.statusId = 2;
    [self.servicesArray replaceObjectAtIndex:index withObject:s];



    [self saveServices];

    // call navigation
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    MapViewController *mapVC = [[MapViewController alloc] initWithNibName:nil bundle:nil];
    mapVC.delegate = self;
    mapVC.service = s;
    self.serviceCancelled = NO;

    [self stopSpeech];

    [self.navigationController pushViewController:mapVC animated:YES];


    /*
     ApiTaxisya *api = [ApiTaxisya sharedInstance];
     [api serviceConfirm:params success:^(BOOL success, id response) {
     if (success) {
     NSDictionary *dictionary = (NSDictionary *)response;
     NSLog(@"sendConfirmation response: %@",dictionary);

     self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
     MapViewController *mapVC = [[MapViewController alloc] initWithNibName:nil bundle:nil];
     mapVC.delegate = self;
     mapVC.service = s;
     self.serviceCancelled = NO;

     [self.navigationController pushViewController:mapVC animated:YES];

     }
     else {
     NSLog(@"sendConfirmation error: %@",response);
     }
     }];
     */


}

#pragma mark - CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{

    self.location = [locations lastObject];
    //NSLog(@"services didUpdateLocations lat=%f lng=%f", self.location.coordinate.latitude, self.location.coordinate.longitude);

    if (self.firstTime) {

        [self enable];

        [self sayDriverEnabled];

        self.firstTime = NO;

        [self speakAddressFirst];

    }
}

#pragma mark - MapViewControllerDelegate
-(void)showToastWhenServiceCancelled:(int) statusId {
    self.serviceCancelled = statusId;
}

-(void)sayDriverEnabled {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"name"];

    NSString *message = NSLocalizedString(@"enable_message",nil);
    NSString *messageToSpeech = [message stringByReplacingOccurrencesOfString:@"{user_name}" withString:userName];
    [self textToSpeech:messageToSpeech];
}

-(void)enable {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSString *uuid = [defaults objectForKey:@"uuid"];
    //NSString *userName = [defaults objectForKey:@"name"];
    NSString *lat = [NSString stringWithFormat:@"%lf", self.location.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%lf", self.location.coordinate.longitude];

#if TARGET_IPHONE_SIMULATOR
    lat = @"4.7434892";
    lng = @"-74.0572775";
#endif

    NSLog(@"driverEnable uuid %@, lat %@, %@",uuid, lat,lng);

    NSDictionary *params = @{@"driver_id":driverId, @"uuid":uuid, @"lat":lat, @"lng":lng};

    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api driverEnable:params success:^(BOOL success, id response) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)response;

            self.dataSource = [[NSMutableArray alloc] init];

            // check error
            NSLog(@"     enable: %@ ", [dictionary objectForKey:@"error"]);

            int error = [[dictionary objectForKey:@"error"] integerValue];

            if (error == 1) {
                NSLog(@"        error: %d", error);

                // show alert
                NSDictionary *driver = [dictionary objectForKey:@"driver"];
                NSString *message = [NSString stringWithFormat:@"%@ %@ %@%@",NSLocalizedString(@"enable_failed_message_part1",nil),
                                    [driver objectForKey:@"name"],
                                    NSLocalizedString(@"enable_failed_message_part2",nil),
                                    [driver objectForKey:@"cellphone"]];

                [self showDriverFailedAlert:message];

            }
            else {

                [self parseServices:dictionary];

            }

        }
        else {
            NSLog(@"driverEnable error: %@",response);
        }
    }];
}

-(void)showDriverFailedAlert:(NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"enable_failed_title",nil)
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"alert_accept",nil)
                                          otherButtonTitles:nil, nil];
    alert.tag = 5000;
    [self.timer invalidate];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    int tag = alertView.tag;

    if (tag == 5000) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)enableDriverFailed {
    NSLog(@"enableDriverFailed +");

    // make alert


}

-(void)getServices {

    NSLog(@"getServices");

    [self enable];

    [self speakAddressFirst];

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

-(void)speakAddressFirst {
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];

    // search service no speaked
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"statusId == 1 AND speak = 0"];

    filteredArray = [NSMutableArray arrayWithArray:[self.servicesArray filteredArrayUsingPredicate:predicate]];

    if ([filteredArray count] > 0) {
        NSMutableArray *addressToSpeechArray = [[NSMutableArray alloc] init];

        for (Service *s in filteredArray) {
            NSLog(@" first %ld %i",s.serviceId, s.speak);
            long index = [self.servicesArray indexOfObject:s];
            NSString *address = [NSString stringWithFormat:@"%@ %@ %@",s.addressService ,NSLocalizedString(@"separator_neighborhood",nil),s.neighborhood];
            NSLog(@"   address: %@", address);

            // obtiene el primer componente
            NSMutableArray* foo = [address componentsSeparatedByString: @" "];
            NSString* first = [foo objectAtIndex: 0];

            NSString * speakAddress = nil;
            if([first integerValue]) {
               // es un número , separar los 2 ultimos caracters
                NSUInteger longitud = [first length];

                NSString *addrSecond = [first stringByReplacingCharactersInRange:NSMakeRange(2, 2) withString:@" "];
                NSString *addrThree = [first substringWithRange:NSMakeRange(longitud-2, 2)];

                NSLog(@"subSting %@ %@", addrSecond,addrThree);
                NSString *addComp1 = [NSString stringWithFormat:@"%@ %@",addrSecond, addrThree];

                [foo replaceObjectAtIndex:0 withObject:addComp1];

                speakAddress = [foo componentsJoinedByString:@" "];
                NSLog(@"speak %@",speakAddress);

            }
            else {
                // direcciones en español
                speakAddress = address;
            }
//             NSMakeRange(longitud - 2, 2);
//            [substrings addObject:[str substringWithRange:range]];
//            str = [str substringFromIndex:range.location + range.length];

//            NSString *addressToSpeech = [address   stringByReplacingOccurrencesOfString:@"-" withString:@" "];
            NSString *addressToSpeech = [speakAddress  stringByReplacingOccurrencesOfString:@"-" withString:@" "];

            // if spanish



            s.speak = 1;
            [self.servicesArray replaceObjectAtIndex:index withObject:s];

//            [addressToSpeechArray addObject:addressToSpeech];
            [addressToSpeechArray addObject:[self stringChangeLetterToSpeak:[self spaceIntoNumberAndLetter:addressToSpeech]]];


        }
        NSString *addressesJoined = [addressToSpeechArray componentsJoinedByString:@", "];
        NSLog(@"  joined %@",addressesJoined);
        [self textToSpeech:addressesJoined];

        self.timerSpeak = [NSTimer scheduledTimerWithTimeInterval:20.0
                                                           target:self
                                                         selector:@selector(speakAddressSecond)
                                                         userInfo:nil
                                                          repeats:YES];



    }
    //[self.timerSpeak fire];

    //[self.timerSpeak invalidate];

}

-(void)speakAddressSecond {
    NSLog(@"speakAddressSecond ini");
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];

    // search service no speaked
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"statusId == 1 AND speak = 1"];

    filteredArray = [NSMutableArray arrayWithArray:[self.servicesArray filteredArrayUsingPredicate:predicate]];

    if ([filteredArray count] > 0) {
        NSMutableArray *addressToSpeechArray = [[NSMutableArray alloc] init];

        for (Service *s in filteredArray) {
            NSLog(@" second %ld %i",s.serviceId, s.speak);
            long index = [self.servicesArray indexOfObject:s];
            NSString *address = [NSString stringWithFormat:@"%@ %@ %@",s.addressService ,NSLocalizedString(@"separator_neighborhood",nil),s.neighborhood];

//            NSLog(@"   address: %@", address);
            // obtiene el primer componente
            NSMutableArray* foo = [address componentsSeparatedByString: @" "];
            NSString* first = [foo objectAtIndex: 0];

            NSString * speakAddress = nil;
            if([first integerValue]) {
               // es un número , separar los 2 ultimos caracters
                NSUInteger longitud = [first length];

                NSString *addrSecond = [first stringByReplacingCharactersInRange:NSMakeRange(2, 2) withString:@" "];
                NSString *addrThree = [first substringWithRange:NSMakeRange(longitud-2, 2)];

                NSLog(@"subSting %@ %@", addrSecond,addrThree);
                NSString *addComp1 = [NSString stringWithFormat:@"%@ %@",addrSecond, addrThree];

                [foo replaceObjectAtIndex:0 withObject:addComp1];

                speakAddress = [foo componentsJoinedByString:@" "];
                NSLog(@"speak %@",speakAddress);

            }
            else {
                speakAddress = address;
            }
//             NSMakeRange(longitud - 2, 2);
//            [substrings addObject:[str substringWithRange:range]];
//            str = [str substringFromIndex:range.location + range.length];

//            NSString *addressToSpeech = [address   stringByReplacingOccurrencesOfString:@"-" withString:@" "];
            NSString *addressToSpeech = [speakAddress  stringByReplacingOccurrencesOfString:@"-" withString:@" "];

            s.speak = 2;
            [self.servicesArray replaceObjectAtIndex:index withObject:s];

            //[addressToSpeechArray addObject:addressToSpeech];
            [addressToSpeechArray addObject:[self stringChangeLetterToSpeak:[self spaceIntoNumberAndLetter:addressToSpeech]]];


        }
        NSString *addressesJoined = [addressToSpeechArray componentsJoinedByString:@", "];
        NSLog(@"  joined2 %@",addressesJoined);
        [self textToSpeech:addressesJoined];

    }

    [self.timerSpeak invalidate];
    self.timerSpeak = nil;
}

-(void)speakAddress {
    NSLog(@"   speakAddress ini");
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];

    // search service no speaked
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"statusId == 1 AND speak = 0"];

    filteredArray = [NSMutableArray arrayWithArray:[self.servicesArray filteredArrayUsingPredicate:predicate]];

    if ([filteredArray count] > 0) {
        // lee el primero
        Service *s = [filteredArray objectAtIndex:0];

        long index = [self.servicesArray indexOfObject:s];
        NSString *address = [NSString stringWithFormat:@"%@ %@ %@",s.addressService ,NSLocalizedString(@"separator_neighborhood",nil),s.neighborhood];
        NSString *addressToSpeech = [address   stringByReplacingOccurrencesOfString:@"-" withString:@" "];
        // change status of speak
        s.speak = 1;
        [self.servicesArray replaceObjectAtIndex:index withObject:s];
        NSLog(@"   speakAddress ini 1");
        [self textToSpeech:addressToSpeech];
    }
    else { // service speakde one
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"statusId == 1 AND speak = 1"];
        filteredArray = [NSMutableArray arrayWithArray:[self.servicesArray filteredArrayUsingPredicate:predicate]];

        if ([filteredArray count] > 0) {
            Service *s = [filteredArray objectAtIndex:0];
            long index = [self.servicesArray indexOfObject:s];
            NSString *address = [NSString stringWithFormat:@"%@ %@ %@",s.addressService ,NSLocalizedString(@"separator_neighborhood",nil),s.neighborhood];
            NSString *addressToSpeech = [address   stringByReplacingOccurrencesOfString:@"-" withString:@" "];
            // change status no speak anymore
            s.speak = 2;
            [self.servicesArray replaceObjectAtIndex:index withObject:s];
            NSLog(@"   speakAddress ini 2");
            [self textToSpeech:addressToSpeech];
        }
    }

}

- (NSString*) spaceIntoNumberAndLetter:(NSString*) text
{
    NSMutableString *result = [NSMutableString new];
    [result appendFormat:@"%C",[text characterAtIndex:0]];
    for (int i = 1; i < [text length]; i++) {
        unichar n = [text characterAtIndex:i-1];
        unichar c = [text characterAtIndex:i];
        if (isnumber(n) && isalpha(c)) {
            [result appendFormat:@" %c",c];
        }
        else {
            [result appendFormat:@"%c",c];
        }
    }
    return result;
}

-(NSString *)stringChangeLetterToSpeak:(NSString *) text {

    NSString *s1 = [text stringByReplacingOccurrencesOfString:@"-" withString:@" "];

    NSString *s2 = [s1 stringByReplacingOccurrencesOfString:@" b " withString:@" be"];
    NSString *s3 = [s2 stringByReplacingOccurrencesOfString:@" c " withString:@" ce"];
    NSString *s4 = [s3 stringByReplacingOccurrencesOfString:@" d " withString:@" de"];
    NSString *s5 = [s4 stringByReplacingOccurrencesOfString:@" g " withString:@" ge"];
    NSString *s6 = [s5 stringByReplacingOccurrencesOfString:@" h " withString:@" ache"];
    NSString *s7 = [s6 stringByReplacingOccurrencesOfString:@" j " withString:@" jota"];
    NSString *s8 = [s7 stringByReplacingOccurrencesOfString:@" k " withString:@" ka"];
    NSString *s9 = [s8 stringByReplacingOccurrencesOfString:@" l " withString:@" ele"];
    NSString *s9a = [s9 stringByReplacingOccurrencesOfString:@" av " withString:@" Avenida"];

    //return s9;

    NSString *s10 = [s9a stringByReplacingOccurrencesOfString:@" St" withString:@" street"];
    NSString *s11 = [s10 stringByReplacingOccurrencesOfString:@" SW " withString:@" south west"];
    NSString *s12 = [s11 stringByReplacingOccurrencesOfString:@" TER" withString:@" terrace"];
    NSString *s13 = [s12 stringByReplacingOccurrencesOfString:@" th " withString:@""];
    NSString *s14 = [s13 stringByReplacingOccurrencesOfString:@" Ave" withString:@" Avenue"];
    NSString *s15 = [s14 stringByReplacingOccurrencesOfString:@" st " withString:@" street"];

    return s15;
}


@end
