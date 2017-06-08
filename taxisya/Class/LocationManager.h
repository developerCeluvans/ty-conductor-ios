//
//  LocationManager.h
//  taxisya
//
//  Created by Leonardo Rodriguez on 6/19/16.
//  Copyright © 2016 imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>

@optional
-(void)locationDidUpdateToLocation:(CLLocation *)location;

@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (nonatomic,weak) id <LocationManagerDelegate> delegate;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,strong) NSDate *lastTimestamp;

@property (nonatomic,strong) CLLocation *currentLocation;

+(instancetype)sharedInstance;
-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;

@end
