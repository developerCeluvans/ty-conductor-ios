//
//  City.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 11/27/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "City.h"

@implementation City

-(id)initWithObject:(long)countryId region:(long)regionId city:(long)cityId name:(NSString *)name {
    self = [super init];
    if (self) {
        _countryId = countryId;
        _regionId = regionId;
        _cityId = cityId;
        _name = name;
    }
    return self;
}

@end
