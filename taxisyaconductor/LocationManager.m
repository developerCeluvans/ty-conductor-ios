//
//  LocationManager.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/9/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager 

static BOOL _started = NO;
static LocationManager *_sharedInstance = nil;
static CLLocationManager *_locationManager = nil;
static CLLocation *_location = nil;

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
    }
    return _locationManager;
}

+ (void)start
{
    @synchronized(self) {
        if (self.isStarted) {
            return;
        }
        _location = nil;
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = _sharedInstance = [[LocationManager alloc] init];
        }
        [_locationManager performSelectorOnMainThread:@selector(startUpdatingLocation) withObject:nil waitUntilDone:YES];
        _started = YES;
    }
}

+ (void)stop
{
    @synchronized(self) {
        if (!self.isStarted) {
            return;
        }
        [_locationManager performSelectorOnMainThread:@selector(stopUpdatingLocation) withObject:nil waitUntilDone:YES];
        _location = nil;
        _started = NO;
    }
}

+ (BOOL)isAuthorizationDecided
{
    return ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined);
}

+ (BOOL)isAuthorized
{
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
}

+ (BOOL)isStarted
{
    @synchronized(self) {
        return _started;
    }
}

+ (CLLocation *)currentLocationByWaitingUpToMilliseconds:(NSUInteger)milliseconds
{
    // wait for an authorization decision first
    while (!self.isAuthorizationDecided) {
        [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow:0.001]];
    }
    
    if (!self.isAuthorized) {
        NSLog(@"LocationManager: ERROR not authorized to read location");
        return nil;
    }
    [self start]; // make sure we're started
    
    NSDate *end = (milliseconds) ? [NSDate dateWithTimeIntervalSinceNow:milliseconds / 1000.0] : nil;
    
    while (!milliseconds || [(NSDate *)NSDate.date compare:end] != NSOrderedDescending) {
        if (_location) {
            return _location;
        }
        // sleep 1 ms, doesnt allow runloop [NSThread sleepForTimeInterval:0.001];
        [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow:0.001]];
    }
    NSLog(@"LocationManager: ERROR timeout after %ld ms", (unsigned long)milliseconds);
    return nil;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations.lastObject;
    
    NSTimeInterval age = [NSDate.date timeIntervalSinceDate:location.timestamp];
    // if the time interval returned from core location is more than two minutes we ignore it because it might be from an old session
    if (age >= 120.0) {
        return;
    }
    // negative horizontal accuracy means no location fix
    if (location.horizontalAccuracy < 0.0) {
        return;
    }
    
    // location should be good
    _location = location;
}

-       (void)locationManager:(CLLocationManager *)manager
 didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // if not authorized, clear the location
    if (status != kCLAuthorizationStatusAuthorized) {
        _location = nil;
    }
}

// deprecated, present for backward compatibility
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self locationManager:manager didUpdateLocations:@[oldLocation, newLocation]];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"LocationManager: DELEGATE FAIL didFailWithError error:%@", error);
    _location = nil;
}

@end
