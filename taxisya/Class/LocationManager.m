//
//  LocationManager.m
//  taxisya
//
//  Created by Leonardo Rodriguez on 6/19/16.
//  Copyright © 2016 imaginamos. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        [self locationManager];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static LocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocationManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)dealloc {
    locationManager.delegate = nil;
}

- (void) locationManager
{
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        
        // Configure the location manager.
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
        [locationManager startMonitoringSignificantLocationChanges];
    }
    else{
        
        NSLog(@"Location Services Disabled.You currently have all location services for this device disabled. If you proceed, you will be showing past informations. To enable, Settings->Location->location services->on");
        // TODO: make alert ouside NSObject

    }
}

- (void)requestWhenInUseAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        NSLog(@"%@",message);
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    }
}

-(void)startUpdatingLocation {
    [locationManager startUpdatingLocation];
}

-(void)stopUpdatingLocation {
    [locationManager stopUpdatingLocation];
}

-(void)startMonitoringSignificantLocationChanges {
    [locationManager startMonitoringSignificantLocationChanges];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    NSLog(@"Failed to Get Your Location");
    // TODO: make alert outside NSObject
    /*
     UIAlertView *errorAlert = [[UIAlertView alloc]
     initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     //    [errorAlert show];
     */
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:{
            [locationManager startUpdatingLocation];
        }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    CLLocation *location;
    location =  [manager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    _currentLocation = [[CLLocation alloc] init];
    _currentLocation = newLocation;
    _longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    //    globalObjects.longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    //    globalObjects.latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSLog(@"didUpdateLocations %@ %@ %@",_currentLocation, _latitude, _longitude);
    [self.delegate locationDidUpdateToLocation:_currentLocation];
    
    //    NSDate *now = [NSDate date];
    //    NSTimeInterval interval = self.lastTimestamp ? [now timeIntervalSinceDate:self.lastTimestamp] : 0;
    //    if (!self.lastTimestamp || interval >= 2 * 60) // 2 minutos
    //    {
    //        self.lastTimestamp = now;
    //        NSLog(@"Sending current location to web service.");
    //        [self.delegate locationDidUpdateToLocation:_currentLocation];
    //    }
}

@end
