//
//  Service.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/9/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "Service.h"

@implementation Service

-(id)initWithObject:(long)serviceId
            address:(NSString *)address
       neighborhood:(NSString *)neighborhood
        destination:(NSString *)destination
        observation:(NSString *)observation
           latitude:(double)latitude
          longitude:(double)longitude
             kindId:(int)kindId
       scheduleType:(int)scheduleType
    serviceDateTime:(NSString *)serviceDateTime
           userName:(NSString *)userName
           status:(long) statusId {
    self = [super init];
    if (self) {
        _serviceId = serviceId;
        _addressService = address;
        _neighborhood = neighborhood;
        _destination = destination;
        _observation = observation;
        _latitude = latitude;
        _longitude = longitude;
        _kindId = kindId;
        if (!statusId)
           _statusId = 1;
        else
            _statusId = statusId;
        _speak = 0;
        _scheduleType = scheduleType;
        _serviceDateTime = serviceDateTime;
        _userName = userName;
        _createdAt = [NSDate date];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.serviceId = [decoder decodeIntegerForKey:@"serviceId"];
        self.addressService = [decoder decodeObjectForKey:@"addressService"];
        self.neighborhood = [decoder decodeObjectForKey:@"neighborhood"];
        self.destination = [decoder decodeObjectForKey:@"destination"];
        self.observation = [decoder decodeObjectForKey:@"observation"];
        self.latitude = [decoder decodeDoubleForKey:@"latitude"];
        self.longitude = [decoder decodeDoubleForKey:@"longitude"];
        self.kindId = [decoder decodeIntForKey:@"kindId"];
        self.scheduleType = [decoder decodeIntForKey:@"scheduleType"];
        self.statusId = [decoder decodeIntForKey:@"statusId"];
        self.speak = [decoder decodeIntForKey:@"speak"];
        self.serviceDateTime = [decoder decodeObjectForKey:@"serviceDateTime"];
        self.userName = [decoder decodeObjectForKey:@"userName"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt64:self.serviceId forKey:@"serviceId"];
    [encoder encodeObject:self.addressService forKey:@"addressService"];
    [encoder encodeObject:self.neighborhood forKey:@"neighborhood"];
    [encoder encodeObject:self.destination forKey:@"destination"];
    [encoder encodeObject:self.observation forKey:@"observation"];
    [encoder encodeDouble:self.latitude forKey:@"latitude"];
    [encoder encodeDouble:self.longitude forKey:@"longitude"];
    [encoder encodeInt:self.kindId forKey:@"kindId"];
    [encoder encodeInt:self.scheduleType forKey:@"scheduleType"];
    [encoder encodeInt:self.statusId forKey:@"statusId"];
    [encoder encodeInt:self.speak forKey:@"speak"];
    [encoder encodeObject:self.serviceDateTime forKey:@"serviceDateTime"];
    [encoder encodeObject:self.userName forKey:@"userName"];

}

@end
