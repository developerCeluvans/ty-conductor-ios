//
//  DirectionService.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 11/25/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "DirectionService.h"

@implementation DirectionService {
@private
    BOOL _sensor;
    BOOL _alternatives;
    NSURL *_directionsURL;
    NSArray *_waypoints;
}

static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";

- (void)setDirectionsQuery:(NSDictionary *)query withSelector:(SEL)selector withDelegate:(id)delegate {
    NSArray *waypoints = [query objectForKey:@"waypoints"];
    NSString *origin = [waypoints objectAtIndex:0];
    long waypointCount = [waypoints count];
    long destinationPos = waypointCount -1;
    NSString *destination = [waypoints objectAtIndex:destinationPos];
    NSString *sensor = [query objectForKey:@"sensor"];
    NSMutableString *url =
    [NSMutableString stringWithFormat:@"%@&origin=%@&destination=%@&sensor=%@",
     kMDDirectionsURL,origin,destination, sensor];
    if(waypointCount>2) {
        [url appendString:@"&waypoints=optimize:true"];
        long wpCount = waypointCount-2;
        for(int i=1;i<wpCount;i++){
            [url appendString: @"|"];
            [url appendString:[waypoints objectAtIndex:i]];
        }
    }
    url = [url
           stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    // test
    NSLog(@"~(1)~~~~~~~~~> setDirectionsQuery %@ ",url);
//    url = @"http://maps.googleapis.com/maps/api/directions/json?&origin=25.667825,-80.373606&destination=25.662499,-80.375572&sensor=false";
    _directionsURL = [NSURL URLWithString:url];

    NSLog(@"~(2)~~~~~~~~~> setDirectionsQuery %@ ",url);

    [self retrieveDirections:selector withDelegate:delegate];
}

- (void)retrieveDirections:(SEL)selector withDelegate:(id)delegate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data =
        [NSData dataWithContentsOfURL:_directionsURL];
        [self fetchedData:data withSelector:selector withDelegate:delegate];
    });
}

- (void)fetchedData:(NSData *)data withSelector:(SEL)selector withDelegate:(id)delegate{
    NSLog(@"~~~~~~~~~~> fetchedData ");
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    [delegate performSelector:selector withObject:json];
}

@end
