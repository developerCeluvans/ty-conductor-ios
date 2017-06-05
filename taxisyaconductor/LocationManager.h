//
//  LocationManager.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/9/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

// blocks first (indefinitely) if there is not yet an authorization decision
// blocks up to milliseconds, 0 never timeout
// returns nil if no location is found
// compatible with the main thread and runloop
+(CLLocation *)currentLocationByWaitingUpToMilliseconds:(NSUInteger)milliseconds;

+(void)start;
+(void)stop; // turn off the lights when you're done or kill the battery.
+(BOOL)isStarted;
+(BOOL)isAuthorized; // YES = location allowed

@end
