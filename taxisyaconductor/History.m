//
//  History.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/7/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "History.h"

@implementation History

-(id)initWithObject:(long)serviceId address:(NSString *)address neighborhood:(NSString *)neighborhood updateAt:(NSString *)updateAt rate:(int)rate {
    
    self = [super init];
    if (self) {
        _serviceId = serviceId;
        _address = address;
        _neighborhood = neighborhood;
        _updateAt = updateAt;
        _rate = rate;
    }
    return self;
}

@end
