//
//  Region.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 11/27/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "Region.h"

@implementation Region

-(id)initWithObject:(long)regionId country:(int)countryId name:(NSString *)name {

    self = [super init];
    if (self) {
        _regionId = regionId;
        _countryId = countryId;
        _name = name;
    }
    return self;
}

@end
